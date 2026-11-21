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
                    on_show = function(picker)
                        -- Snacks counts a full-width main preview's resize as a
                        -- sidebar resize on first open. Give the overlay its real
                        -- width so the layout's resize delta stays zero.
                        local on_update = picker.layout.opts.on_update
                        picker.layout.opts.on_update = function(layout)
                            if picker.preview.main then
                                picker.preview.win.opts.width = vim.api.nvim_win_get_width(picker.main)
                            end
                            on_update(layout)
                        end
                        picker.layout.opts.on_update(picker.layout)
                    end,
                    -- Preview the highlighted file over the editing pane without
                    -- replacing its buffer. P toggles the preview in Explorer.
                    layout = {
                        preset = 'sidebar',
                        preview = 'main',
                        layout = { width = 35, min_width = 35 },
                    },
                }
            }
        }
    },
}
