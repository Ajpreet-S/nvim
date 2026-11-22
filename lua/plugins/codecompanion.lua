return {
  'olimorris/codecompanion.nvim',
  version = 'v20.2.0',
  cmd = {
    'CodeCompanion',
    'CodeCompanionChat',
    'CodeCompanionCodeReview',
    'CodeCompanionCmd',
    'CodeCompanionCLI',
    'CodeCompanionActions',
  },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    display = {
      chat = {
        window = { layout = 'vertical', position = 'right' },
      },
    },
    interactions = {
      chat = {
        adapter = 'codex',
        keymaps = {
          scroll_chat_down = { modes = { n = '<M-n>', i = '<M-n>' } },
          scroll_chat_up = { modes = { n = '<M-p>', i = '<M-p>' } },
        },
      },
    },
    adapters = {
      acp = {
        codex = function()
          return require('codecompanion.adapters').extend('codex', {
            commands = {
              default = { 'npx', '--yes', '@agentclientprotocol/codex-acp@2.7.0' },
            },
            defaults = { auth_method = 'chat-gpt' },
            env = {
              CODEX_PATH = function()
                return vim.fn.exepath('codex')
              end,
              INITIAL_AGENT_MODE = 'read-only',
              -- Functions avoid empty strings resolving as adapter references.
              OPENAI_API_KEY = function()
                return ''
              end,
              CODEX_API_KEY = function()
                return ''
              end,
            },
          })
        end,
      },
    },
  },
}
