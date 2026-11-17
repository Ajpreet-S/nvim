return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      -- D2 is not in the upstream parser list yet. Install its queries alongside
      -- the grammar so a separate grammar plugin/build step is unnecessary.
      local function register_d2()
        require('nvim-treesitter.parsers').d2 = {
          install_info = {
            url = 'https://github.com/ravsii/tree-sitter-d2',
            revision = 'v0.7.2',
            queries = 'queries',
          },
        }
      end

      local group = vim.api.nvim_create_augroup('TreesitterConfig', { clear = true })
      vim.api.nvim_create_autocmd('User', {
        group = group,
        pattern = 'TSUpdate',
        callback = register_d2,
      })
      register_d2()
      require('nvim-treesitter').install({ 'd2' })

      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(event)
          -- Use installed parsers; retain ordinary syntax for other filetypes.
          pcall(vim.treesitter.start, event.buf)
        end,
      })
    end,
  },
}
