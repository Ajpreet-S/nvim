return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      {
        'igorlfs/nvim-dap-view',
        version = '1.*',
        init = function()
          vim.api.nvim_create_autocmd('FileType', {
            group = vim.api.nvim_create_augroup('DapViewPanelLayout', { clear = true }),
            pattern = 'dap-view',
            callback = function() require('config.panel_layout').arrange() end,
          })
        end,
        opts = {
          windows = {
            position = 'below',
          },
          winbar = {
            sections = { 'repl', 'watches', 'scopes', 'threads' },
            show_keymap_hints = false,
            base_sections = {
              repl = { label = '[R]EPL' },
              watches = { label = '[W]atch' },
              scopes = { label = '[S]cope' },
              threads = { label = '[T]hreads' },
            },
          },
        },
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

      dap.adapters['pwa-chrome'] = dap.adapters['pwa-node']

      dap.configurations['javascript'] = {
        {
          name = 'Launch current file',
          type = 'pwa-node',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          name = 'Attach to Chromium',
          type = 'pwa-chrome',
          request = 'attach',
          address = '127.0.0.1',
          port = 9222,
          urlFilter = 'http://localhost:8080/*',
          webRoot = '${workspaceFolder}/optic-systems-legacy',
          sourceMaps = true,
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
        {
          name = 'Listen for Xdebug (MODX)',
          type = 'php',
          request = 'launch',
          port = 9003,
          pathMappings = {
            ['/var/www/html'] = '/home/aj/Work/codebase/optic-systems-legacy',
          },
        },
      }
    end,
  },
}
