return {
  'folke/snacks.nvim',
  opts = {
    explorer = {
      trash = true,
      replace_netrw = true,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
          win = {
            input = { keys = { ['<a-h>'] = false } },
            list = { keys = { ['<a-h>'] = false } },
          },
          config = function(opts)
            -- Preserve Snacks' explorer setup, then wrap the final on_show:
            -- project-picker actions supply their own callback to close the picker.
            opts = require('snacks.picker.source.explorer').setup(opts)
            local on_show = opts.on_show
            opts.on_show = function(picker)
              -- Main-preview resizes must not be counted as sidebar resizes.
              local on_update = picker.layout.opts.on_update
              picker.layout.opts.on_update = function(layout)
                if picker.preview.main then
                  picker.preview.win.opts.width = vim.api.nvim_win_get_width(picker.main)
                end
                on_update(layout)
              end
              picker.layout.opts.on_update(picker.layout)
              if on_show then
                on_show(picker)
              end
              require('config.panel_layout').arrange()
            end
            return opts
          end,
          -- Preview the highlighted file over the editing pane without
          -- replacing its buffer. P toggles the preview in Explorer.
          layout = {
            preset = 'sidebar',
            preview = 'main',
          },
        },
      },
    },
  },
}
