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
                window = { layout = 'vertical', position = 'right', width = 70 },
            },
        },
        interactions = {
            chat = { adapter = 'codex' },
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
                            CODEX_PATH = function() return vim.fn.exepath('codex') end,
                            INITIAL_AGENT_MODE = 'read-only',
                            -- Functions avoid empty strings resolving as adapter references.
                            OPENAI_API_KEY = function() return '' end,
                            CODEX_API_KEY = function() return '' end,
                        },
                    })
                end,
            },
        },
    },
}
