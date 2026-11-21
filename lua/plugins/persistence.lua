return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = { branch = false },
  config = function(_, opts)
    require('persistence').setup(opts)
    require('config.sessions').setup()
  end,
}
