return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'igorlfs/nvim-dap-view',
                version = '1.*',
                opts = {},
            },
        },
        config = function()
            local dap = require('dap')

            -- JAVASCRIPT
            dap.adapters['pwa-node'] = {
                type = 'server',
                host = '::1',
                port = '${port}',
                executable = {
                    command = vim.fn.stdpath('data') .. '/mason/bin/js-debug-adapter',
                    args = { '${port}' },
                },
            }

            dap.configurations['javascript'] = {
                {
                    name = 'Launch current file',
                    type = 'pwa-node',
                    request = 'launch',
                    program = '${file}',
                    cwd = '${workspaceFolder}',
                },
            }

            -- BASH
            local bashdb = vim.fn.stdpath('data') .. '/mason/packages/bash-debug-adapter/extension/bashdb_dir'
            dap.adapters.bashdb = {
                type = 'executable',
                command = vim.fn.stdpath('data') .. '/mason/bin/bash-debug-adapter',
            }
            dap.configurations.sh = {
                {
                    name = 'Debug current Bash script',
                    type = 'bashdb',
                    request = 'launch',
                    env = vim.empty_dict(),
                    args = {},
                    argsString = '',
                    program = '${file}',
                    cwd = '${workspaceFolder}',
                    pathBashdb = bashdb .. '/bashdb',
                    pathBashdbLib = bashdb,
                    pathBash = '/usr/bin/bash',
                    pathCat = '/usr/bin/cat',
                    pathMkfifo = '/usr/bin/mkfifo',
                    pathPkill = '/usr/bin/pkill',
                },
            }

            -- PHP
            dap.adapters['php'] = {
                type = 'executable',
                command = vim.fn.stdpath('data') .. '/mason/bin/php-debug-adapter',
            }

            dap.configurations['php'] = {
                {
                    name = 'Listen for Xdebug (Laravel)',
                    type = 'php',
                    request = 'launch',
                    port = 9003,
                    pathMappings = {
                        ['/var/www/html'] = '/home/aj/Work/codebase/optic-systems-v2',
                    },
                },
            }

        end,
    },
}
