-- some aliases to make things easier to read and configure
-- Prefer <Cmd> for Ex commands; use : when a Visual range is required.
local map = vim.keymap.set
local n = 'n'
local i = 'i'
local harpoon = require('harpoon')

-- keymap helper
map(n, '<leader>?', function()
  require('which-key').show({ global = true })
end, { desc = 'show keymaps' })

-- settings
map(n, '<C-M-s>', function()
  Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })
end, { desc = 'neovim config' })
map(n, '<leader>R', function()
  package.loaded['config.options'] = nil
  package.loaded['config.keymaps'] = nil
  vim.cmd.source(vim.fn.stdpath('config') .. '/init.lua')
  vim.notify('Reloaded options and keymaps; restart Neovim for plugin changes')
end, { desc = 'reload config (options and keymaps)' })

-- editing
map(i, 'jk', '<Esc>', { desc = 'exit insert mode' })
map(n, '<Esc>', '<Cmd>nohlsearch<CR>', { desc = 'clear search highlights' })
map(n, '<leader>s', '<Cmd>write<CR>', { desc = '[s]ave file' })
map(n, '<leader>S', function()
  require('config.sessions').enroll()
end, { desc = 'save project session (automatic updates)' })
map(n, '<leader>q', '<Cmd>quit<CR>', { desc = '[q]uit window' })
map(n, '<leader><S-q>', '<Cmd>quit!<CR>', { desc = '[Q]uit window without saving' })
map(i, '<M-s>', function()
  require('blink.cmp').show({ providers = { 'snippets' } })
end, { desc = 'browse snippets' })
map({ n, 'x' }, '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'format code' })

-- file explorer and searching
map(n, '<leader>e', function()
  Snacks.explorer()
end, { desc = 'file [e]xplorer' })
map(n, '<leader>f', function()
  Snacks.picker.pick('all')
end, { desc = '[f]ind stuff' })

-- file navigation via Harpoon
map(n, '<S-m>', function()
  harpoon.add_file()
end, { desc = '[M]ark a file (harpoon)' })
map(n, '<M-m>', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = '[Alt]er [m]arked file list (harpoon)' })
map(n, '<M-j>', function()
  harpoon:list():select(1)
end, { desc = 'file 1 (harpoon)' })
map(n, '<M-k>', function()
  harpoon:list():select(2)
end, { desc = 'file 2 (harpoon)' })
map(n, '<M-l>', function()
  harpoon:list():select(3)
end, { desc = 'file 3 (harpoon)' })
map(n, '<M-;>', function()
  harpoon:list():select(4)
end, { desc = 'file 4 (harpoon)' })

-- Custom LSP, linter, formatter actions
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('LanguageKeymaps', { clear = true }),
  callback = function(event)
    local function lsp_map(lhs, rhs, desc)
      map(n, lhs, rhs, { buffer = event.buf, desc = desc })
    end
    -- Use native Ctrl-] for definitions and insert-mode Ctrl-s for signatures.
    lsp_map('grr', function()
      Snacks.picker.lsp_references()
    end, 'find references')
  end,
})
map(n, '<leader>d', vim.diagnostic.setloclist, { desc = 'buffer diagnostics' })

-- tools (mise, lazygit, debugger UI, agent)
map(n, '<M-t>', function()
  require('pickers.mise').open()
end, { desc = 'mise tasks' })
map(n, '<M-g>', function()
  Snacks.lazygit()
end, { desc = 'lazygit' })
map(n, '<M-d>', function()
  require('dap-view').toggle(true)
end, { desc = 'toggle debugger ui' })
map(n, '<M-a>', '<Cmd>CodeCompanionChat Toggle<CR>', { desc = 'toggle agent chat' })
-- tools > debugger
map(n, '<C-b>', function()
  require('dap').toggle_breakpoint()
end, { desc = 'toggle breakpoint' })
map(n, '<C-\\>', function()
  require('dap').continue()
end, { desc = 'debug start / continue' })
map(n, '<C-\'>', function()
  require('dap').step_over()
end, { desc = 'debug step over' })
map(n, '<C-;>', function()
  require('dap').step_into()
end, { desc = 'debug step into' })
map(n, '<C-S-;>', function()
  require('dap').step_out()
end, { desc = 'debug step out' })
-- tools > agent
map('x', '<M-a>', ':CodeCompanionChat Add<CR>', { desc = 'add selection to agent chat' })
