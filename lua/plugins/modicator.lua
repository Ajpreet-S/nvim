return {
  'mawkler/modicator.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-lualine/lualine.nvim' },
  config = function()
    -- Modicator cannot read a function-based Lualine theme; link its generated highlights instead.
    local function link_modes()
      for mode, section in pairs({
        Normal = 'normal',
        Insert = 'insert',
        Visual = 'visual',
        Command = 'command',
        Replace = 'replace',
        Select = 'visual',
        Terminal = 'terminal',
        TerminalNormal = 'normal',
      }) do
        vim.api.nvim_set_hl(0, mode .. 'Mode', { link = 'lualine_a_' .. section })
      end
    end
    local modicator = require('modicator')
    link_modes()
    vim.api.nvim_create_autocmd('ColorScheme', {
      group = vim.api.nvim_create_augroup('ModicatorTheme', { clear = true }),
      -- Wait until Lualine has rebuilt its highlights, regardless of callback order.
      callback = vim.schedule_wrap(function()
        link_modes()
        modicator.set_cursor_line_highlight(modicator.hl_name_from_mode(vim.api.nvim_get_mode().mode))
      end),
    })
    modicator.setup({ integration = { lualine = { enabled = false } } })
  end,
}
