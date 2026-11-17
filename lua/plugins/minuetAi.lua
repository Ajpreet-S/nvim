return {
    {
        'milanglacier/minuet-ai.nvim',
        lazy = false,
        opts = {
            provider = 'openai_compatible',
            n_completions = 1,
            context_window = 4096,
            request_timeout = 15,
            throttle = 1500,
            debounce = 600,
            virtualtext = {
                auto_trigger_ft = { '*' },
                show_on_completion_menu = false,
                keymap = {
                    accept = '<A-a>',
                    accept_line = '<A-A>',
                    prev = '<A-[>',
                    next = '<A-]>',
                    dismiss = '<A-e>',
                },
            },
            provider_options = {
                openai_compatible = {
                    name = 'LM Studio',
                    end_point = 'http://127.0.0.1:1234/v1/chat/completions',
                    model = 'QuickCoder',
                    -- LM Studio does not require authentication on this local server.
                    api_key = function() return 'lm-studio' end,
                    optional = {
                        max_tokens = 128,
                        temperature = 0.2,
                        chat_template_kwargs = { enable_thinking = false },
                    },
                },
            },
        },
    },
}
