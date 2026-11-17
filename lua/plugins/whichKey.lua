return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
        preset = 'helix',
        spec = {
            { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
            { '<leader>d', group = 'Diagnostics' },
        },
    },
}
