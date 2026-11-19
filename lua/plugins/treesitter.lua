return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({ 'html', 'javascript', 'tsx' })

      local group = vim.api.nvim_create_augroup('TreesitterConfig', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(event)
          -- Use installed parsers; retain ordinary syntax for other filetypes.
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },
}
