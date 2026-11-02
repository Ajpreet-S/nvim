local M = {}
local state = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")
M.theme_file = state .. "/omarchy/current/theme/neovim.lua"

function M.specs()
  if vim.fn.filereadable(M.theme_file) == 0 then
    return {}
  end
  return dofile(M.theme_file)
end

function M.apply()
  local specs = M.specs()
  local colorscheme = "habamax"
  for _, spec in ipairs(specs) do
    if spec[1] == "LazyVim/LazyVim" then
      colorscheme = spec.opts.colorscheme
    end
  end
  vim.o.background = "dark"

  -- Reconfigure even an already-loaded plugin: two Omarchy themes can use
  -- the same colorscheme with different options (for example, aether).
  for _, spec in ipairs(specs) do
    if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
      local name = spec.name or spec[1]:match("/([^/]+)$"):gsub("%.git$", "")
      local plugin = require("lazy.core.config").plugins[name]
      if plugin and plugin._.loaded then
        require("lazy.core.loader").reload(plugin)
      else
        require("lazy").load({ plugins = { name } })
      end
    end
  end

  vim.cmd.colorscheme(colorscheme)
  vim.cmd.redraw()
end

function M.setup()
  vim.opt.termguicolors = true
  local group = vim.api.nvim_create_augroup("OmarchyTheme", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LazyReload",
    callback = M.apply,
  })
  M.apply()

  if vim.fn.filereadable(M.theme_file) == 1 then
    local watcher = assert(vim.uv.new_fs_poll())
    watcher:start(M.theme_file, 1000, vim.schedule_wrap(function(err)
      if not err then
        -- Reload plugin options before LazyReload reapplies the colorscheme.
        require("lazy.manage.reloader").reload({ { file = M.theme_file, what = "changed" } })
      end
    end))
    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = group,
      callback = function()
        watcher:stop()
        watcher:close()
      end,
    })
  end
end

return M
