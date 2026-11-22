-- some aliases to make things easier to read and configure
-- Prefer <Cmd> for Ex commands; use : when a Visual range is required.
local map = vim.keymap.set
local n = 'n'
local i = 'i'
local panel_modes = { n, i }
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

-- focus
local function is_editor_window(win)
  return vim.api.nvim_win_is_valid(win)
    and vim.api.nvim_win_get_config(win).relative == ''
    and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ''
end

vim.api.nvim_create_autocmd('WinLeave', {
  group = vim.api.nvim_create_augroup('EditorWindowFocus', { clear = true }),
  callback = function()
    local win = vim.api.nvim_get_current_win()
    if is_editor_window(win) then
      vim.t.last_editor_win = win
    end
  end,
})

map(panel_modes, '<M-k>', function()
  if is_editor_window(vim.api.nvim_get_current_win()) then
    return
  end

  local tab = vim.api.nvim_get_current_tabpage()
  local win = vim.t.last_editor_win
  if not (win and is_editor_window(win) and vim.api.nvim_win_get_tabpage(win) == tab) then
    win = vim.iter(vim.api.nvim_tabpage_list_wins(tab)):find(is_editor_window)
  end
  if win then
    vim.cmd.stopinsert()
    vim.api.nvim_set_current_win(win)
  end
end, { desc = 'focus editor window' })

-- file explorer and searching
map(panel_modes, '<M-h>', function()
  vim.cmd.stopinsert()
  local explorer = Snacks.picker.get({ source = 'explorer' })[1]
  if explorer and not explorer:is_focused() then
    explorer:focus('list')
  else
    Snacks.explorer()
  end
end, { desc = 'focus or toggle file explorer' })
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
map(n, '<leader>j', function()
  harpoon:list():select(1)
end, { desc = 'file 1 (harpoon)' })
map(n, '<leader>k', function()
  harpoon:list():select(2)
end, { desc = 'file 2 (harpoon)' })
map(n, '<leader>l', function()
  harpoon:list():select(3)
end, { desc = 'file 3 (harpoon)' })
map(n, '<leader>;', function()
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
map(panel_modes, '<M-j>', function()
  vim.cmd.stopinsert()
  local view = require('dap-view')
  local state = require('dap-view.state')
  local win = state.winnr
  if win and vim.api.nvim_win_is_valid(win) then
    if win == vim.api.nvim_get_current_win() then
      view.toggle(true)
    else
      vim.api.nvim_set_current_win(win)
    end
    return
  end

  view.toggle(true)
  if state.winnr and vim.api.nvim_win_is_valid(state.winnr) then
    vim.api.nvim_set_current_win(state.winnr)
  end
end, { desc = 'focus or toggle debugger ui' })
map(panel_modes, '<M-l>', function()
  vim.cmd.stopinsert()
  if vim.bo.filetype ~= 'codecompanion' and vim.bo.filetype ~= 'codecompanion_chat_input' then
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == 'codecompanion' then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
  vim.cmd('CodeCompanionChat Toggle')
end, { desc = 'focus or toggle agent chat' })
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
