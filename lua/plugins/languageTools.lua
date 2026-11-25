return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.lsp.config('lua_ls', {
        on_init = function(client)
          local root = client.config.root_dir
          if not root or vim.uv.fs_realpath(root) ~= vim.uv.fs_realpath(vim.fn.stdpath('config')) then
            return
          end
          -- Respect explicit project settings rather than overriding them.
          if vim.uv.fs_stat(root .. '/.luarc.json') or vim.uv.fs_stat(root .. '/.luarc.jsonc') then
            return
          end
          local library = { vim.env.VIMRUNTIME }
          local snacks = vim.api.nvim_get_runtime_file('lua/snacks', false)[1]
          if snacks then
            library[#library + 1] = vim.fs.dirname(snacks)
          end
          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
            runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
            workspace = { checkThirdParty = false, library = library },
          })
        end,
        settings = {
          Lua = { diagnostics = { globals = { 'vim', 'Snacks' } } },
        },
      })
      vim.lsp.config('emmet_language_server', {
        filetypes = { 'html', 'css' },
      })
      vim.lsp.config('intelephense', {
        root_markers = { 'composer.json', '.git' },
      })
      vim.lsp.config('bashls', {
        settings = { bashIde = { shellcheckPath = '' } },
      })
      vim.lsp.enable({ 'lua_ls', 'html', 'cssls', 'ts_ls', 'bashls', 'emmet_language_server', 'intelephense' })
    end,
  },
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
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
        'stylua',
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
      },
    },
  },
  {
    'stevearc/conform.nvim',
    cmd = 'ConformInfo',
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
    },
  },
}
