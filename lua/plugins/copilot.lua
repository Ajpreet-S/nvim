return {
  {
    'github/copilot.vim',
    branch = 'release',
    event = 'InsertEnter',
    cmd = 'Copilot',
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
  },
}
