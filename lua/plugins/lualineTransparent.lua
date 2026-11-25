local function panel_name()
  local ft = vim.bo.filetype
  if ft:match('^dap%-view') or ft == 'dap-repl' then
    return 'debugger'
  elseif ft == 'snacks_dashboard' then
    return 'dashboard'
  elseif ft:match('^snacks_picker') then
    for _, picker in ipairs(Snacks.picker.get()) do
      if picker:is_focused() then
        return picker.opts.source == 'explorer' and 'explorer' or 'search'
      end
    end
    return 'search'
  elseif ft == 'qf' then
    return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1].loclist == 1 and 'location list' or 'quickfix'
  elseif vim.bo.buftype == 'terminal' then
    return 'terminal'
  end
end

return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      globalstatus = true,
      icons_enabled = false,
      component_separators = '',
      section_separators = '',
      -- Rebuilt by Lualine on ColorScheme, including Omarchy's live theme changes.
      theme = function()
        local theme = require('lualine.utils.loader').load_theme('auto')
        local color = require('lualine.utils.utils').extract_highlight_colors
        local muted = color('Comment', 'fg')
        for _, mode in pairs(theme) do
          for section, hl in pairs(mode) do
            if section == 'a' then
              hl.fg = hl.bg ~= 'None' and hl.bg or hl.fg
              hl.gui = nil
            else
              hl.fg = muted or hl.fg
            end
            hl.bg = 'None'
          end
        end
        return theme
      end,
    },
    sections = {
      lualine_a = {
        function()
          local cwd = vim.fn.getcwd()
          local name = vim.fn.fnamemodify(cwd, ':t')
          return name ~= '' and name or cwd
        end,
      },
      lualine_b = { 'branch', { 'diff', colored = false } },
      lualine_c = {
        {
          'filename',
          symbols = { modified = '●', readonly = '[ro]', unnamed = '[no name]' },
          fmt = function(name)
            return panel_name() or name
          end,
        },
      },
      lualine_x = {
        { 'searchcount', timeout = 50 },
        { 'diagnostics', sources = { 'nvim_diagnostic' } },
      },
      lualine_y = {},
      lualine_z = { 'location' },
    },
  },
}
