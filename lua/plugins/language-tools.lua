return {
  {
    "d2lang/d2-vim",
    ft = "d2",
    init = function()
      vim.g.d2_fmt_autosave = 0 -- Keep formatting manual through Conform.
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })
      vim.lsp.enable({ "lua_ls", "html", "cssls", "ts_ls", "eslint", "bashls" })
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    opts = {},
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua-language-server",
        "html-lsp",
        "css-lsp",
        "typescript-language-server",
        "eslint-lsp",
        "bash-language-server",
        "shellcheck",
        "shfmt",
      }
    },
  },
  {
    "stevearc/conform.nvim",
    lazy = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        d2 = { "d2" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
      },
      format_on_save = false,
    },
  },
}
