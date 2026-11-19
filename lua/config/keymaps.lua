local map = vim.keymap.set

-- Editing
map('i', 'jk', '<Esc>', { desc = 'exit insert mode' })
map('n', '<leader>s', '<Cmd>write<CR>', { desc = 'save file' })
map('n', '<leader>q', '<Cmd>quit<CR>', { desc = 'quit window' })
map('n', '<leader><S-q>', '<Cmd>quit!<CR>', { desc = 'quit window without saving' })

-- Files and search (Snacks is loaded at startup)
map('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })
map('n', '<leader>f', function() Snacks.picker.pick('all') end, { desc = 'Search All' })

-- Focus
map('n', '<leader>z', function() Snacks.zen() end, { desc = 'Toggle Zen Mode' })
map('n', '<leader>Z', function() Snacks.zen.zoom() end, { desc = 'Toggle Zoom' })

-- Bookmarks (require inside callbacks lets Lazy load Harpoon on demand)
map('n', '<leader>h', function() require('harpoon').add_file() end, { desc = 'Harpoon Add File' })
map('n', '<leader>H', function()
    local harpoon = require('harpoon')
    harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon Bookmarks' })
map('n', '<leader>j', function() require('harpoon'):list():select(1) end, { desc = 'Harpoon File 1' })
map('n', '<leader>k', function() require('harpoon'):list():select(2) end, { desc = 'Harpoon File 2' })
map('n', '<leader>l', function() require('harpoon'):list():select(3) end, { desc = 'Harpoon File 3' })
map('n', '<leader>;', function() require('harpoon'):list():select(4) end, { desc = 'Harpoon File 4' })
map('n', '<leader>\'', function() require('harpoon'):list():select(5) end, { desc = 'Harpoon File 5' })

-- Git and tasks
map('n', '<leader>g', function() Snacks.lazygit() end, { desc = 'LazyGit' })
map('n', '<leader>m', function() require('pickers.mise').open() end, { desc = 'Mise Tasks' })

-- Code
map('i', '<C-j>', 'copilot#Accept("\\<CR>")', {
    expr = true,
    replace_keycodes = false,
    desc = 'Accept Copilot Suggestion',
})
map('i', '<M-s>', function()
    require('blink.cmp').show({ providers = { 'snippets' } })
end, { desc = 'Browse Snippets' })
map({ 'n', 'x' }, '<leader>cf', function()
    require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format Code' })

-- LSP shortcuts apply only to buffers with an attached language server.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('LanguageKeymaps', { clear = true }),
    callback = function(event)
        local function lsp_map(lhs, rhs, desc)
            map('n', lhs, rhs, { buffer = event.buf, desc = desc })
        end
        lsp_map('gd', vim.lsp.buf.definition, 'Go to Definition')
        lsp_map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
        lsp_map('grr', function() Snacks.picker.lsp_references() end, 'Find References')
        lsp_map('<leader>cs', vim.lsp.buf.signature_help, 'Signature Help')
    end,
})

-- Diagnostics
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Buffer Diagnostics' })
map('n', '<leader>dw', vim.diagnostic.setqflist, { desc = 'Workspace Diagnostics' })

-- Discover mappings
map('n', '<leader>?', function() require('which-key').show({ global = true }) end, { desc = 'Show Keymaps' })

-- Debugging
map('n', '<C-\\>', function() require('dap').continue() end, { desc = 'DapContinue' })
map('n', "<C-'>", function() require('dap').step_over() end, { desc = 'DapStepOver' })
map('n', "<C-;>", function() require('dap').step_into() end, { desc = 'DapStepInto' })
map('n', "<C-S-;>", function() require('dap').step_out() end, { desc = 'DapStepOut' })
map('n', '<C-b>', function() require('dap').toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })

-- Dashboard
map('n', '<leader><S-d>', function()
    for _, picker in ipairs(Snacks.picker.get()) do
        picker:close()
    end
    vim.schedule(function()
        vim.cmd('fclose!')
        vim.cmd('silent only')
        if vim.bo.filetype ~= 'snacks_dashboard' then
            Snacks.dashboard({ win = 0 })
        end
    end)
end, { desc = 'Dashboard' })
map('n', '<leader><S-c>', function() Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')}) end, { desc = 'Neovim Config' })
