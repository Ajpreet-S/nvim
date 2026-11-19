return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = { diagnostics = { globals = { 'vim' } } },
        },
      })
      vim.lsp.config('emmet_language_server', {
        filetypes = { 'html', 'css' },
      })
      vim.lsp.config('intelephense', {
        root_markers = { 'composer.json', '.git' },
      })
      vim.lsp.enable({ 'lua_ls', 'html', 'cssls', 'ts_ls', 'eslint', 'bashls', 'emmet_language_server', 'intelephense' })
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    dependencies = { 'L3MON4D3/LuaSnip' },
    opts = {
      snippets = { preset = 'luasnip' },
      completion = { documentation = { auto_show = true } },
      signature = { enabled = true },
    },
  },
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = {
        'lua-language-server',
        'html-lsp',
        'css-lsp',
        'emmet-language-server',
        'typescript-language-server',
        'eslint-lsp',
        'prettier',
        'bash-language-server',
        'shellcheck',
        'shfmt',
        'js-debug-adapter',
        'bash-debug-adapter',
        'php-debug-adapter',
        'intelephense',
      }
    },
  },
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        javascript = { 'prettier' },
        javascriptreact = { 'prettier' },
        typescript = { 'prettier' },
        typescriptreact = { 'prettier' },
        html = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
      },
      format_on_save = function(bufnr)
        local formatters = require('conform').formatters_by_ft[vim.bo[bufnr].filetype] or {}
        if vim.tbl_contains(formatters, 'prettier') then
          return { timeout_ms = 2000, lsp_format = 'never' }
        end
      end,
    },
  },
}
