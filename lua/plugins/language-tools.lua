return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })
      vim.lsp.enable({ "lua_ls", "html", "cssls", "ts_ls", "eslint", "bashls" })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("LanguageKeymaps", { clear = true }),
        callback = function(event)
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
          end
          map("gd", vim.lsp.buf.definition, "Go to Definition")
          map("gD", vim.lsp.buf.declaration, "Go to Declaration")
          map("gr", vim.lsp.buf.references, "Find References")
          map("gI", vim.lsp.buf.implementation, "Go to Implementation")
          map("gy", vim.lsp.buf.type_definition, "Go to Type Definition")
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cs", vim.lsp.buf.signature_help, "Signature Help")
        end,
      })
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
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "x" },
        desc = "Format Code",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
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
