return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    spec = {
      { '<leader>A', group = 'Agent', mode = { 'n', 'x' } },
      { '<leader>Ar', group = 'Review' },
      { '<leader>c', group = 'Code', mode = { 'n', 'x' } },
      { '<leader>d', group = 'Diagnostics' },
    },
  },
}
