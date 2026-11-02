local M = {}

function M.apply()
  local specs = dofile(vim.fn.stdpath("config") .. "/lua/plugins/theme.lua")
  local colorscheme
  for _, spec in ipairs(specs) do
    if spec[1] == "LazyVim/LazyVim" then
      colorscheme = spec.opts.colorscheme
    end
  end
  if not colorscheme then
    return
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
  -- lazy.nvim watches the linked theme spec and reloads it when Omarchy changes it.
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "LazyReload",
    callback = M.apply,
  })
  M.apply()
end

return M
