local modes = require('pickers.modes')
-- Source IDs follow the order of the multi-source list.
local search_modes = {
    { id = 'all', label = 'All' },
    { id = 'files', label = 'Files', source_id = 1 },
    { id = 'text', label = 'Text', source_id = 2 },
}

local function update_mode_title(picker)
    local matching = picker.opts.search_regex and 'Regex' or 'Fuzzy Files / Literal Text'
    picker.title = matching .. ' · ' .. modes.get(search_modes, picker.opts.search_mode).label
    modes.update_title(picker, search_modes, picker.opts.search_mode, matching)
end

local function cycle_search_mode(picker, direction)
    picker.opts.search_mode = modes.next(search_modes, picker.opts.search_mode, direction)
    update_mode_title(picker)
    picker:find()
end

return {
    'folke/snacks.nvim',
    opts = {
        picker = {
            enabled = true,
            prompt = '   ',
            sources = {
                all = {
                    title = 'Regex · All',
                    search_mode = 'all',
                    search_regex = true,
                    on_show = update_mode_title,
                    actions = {
                        next_search_mode = function(picker) cycle_search_mode(picker, 1) end,
                        previous_search_mode = function(picker) cycle_search_mode(picker, -1) end,
                        toggle_search_matching = function(picker)
                            picker.opts.search_regex = not picker.opts.search_regex
                            update_mode_title(picker)
                            picker:find()
                        end,
                    },
                    win = {
                        input = {
                            keys = {
                                ['<a-r>'] = { 'toggle_search_matching', mode = { 'i', 'n' }, desc = 'Toggle regex / fuzzy files + literal text' },
                                ['<Tab>'] = { 'next_search_mode', mode = 'i', desc = 'Next search mode' },
                                ['<S-Tab>'] = { 'previous_search_mode', mode = 'i', desc = 'Previous search mode' },
                            },
                        },
                        preview = { wo = { fillchars = 'eob: ', wrap = false } },
                    },
                    formatters = { file = { filename_first = true } },
                    format = function(item, picker)
                        local display_item = vim.tbl_extend('force', {}, item)
                        display_item.pos = nil
                        if item.line then
                            display_item.file = nil
                            display_item.ft = vim.filetype.match({ filename = item.file })
                            local result = Snacks.picker.format.file(display_item, picker)
                            local path = Snacks.picker.util.truncpath(
                                Snacks.picker.util.path(item),
                                math.floor(vim.api.nvim_win_get_width(picker.list.win.win) / 3) - 2,
                                { cwd = picker:cwd() }
                            )
                            result[#result + 1] = {
                                virt_text = { { ' ' .. path .. ' ', 'SnacksPickerDir' } },
                                virt_text_pos = 'right_align',
                                hl_mode = 'combine',
                            }
                            return result
                        end
                        return Snacks.picker.format.file(display_item, picker)
                    end,
                    multi = {
                        {
                            source = 'files',
                            finder = function(opts, ctx)
                                return require('pickers.search_files').find(opts, ctx)
                            end,
                        },
                        {
                            source = 'grep',
                            args = { '--no-config', '--engine=default' },
                            finder = function(opts, ctx)
                                opts = vim.tbl_extend('force', {}, opts, { regex = opts.search_regex })
                                return require('snacks.picker.source.grep').grep(opts, ctx)
                            end,
                        },
                    },
                    matcher = { frecency = true, sort_empty = true },
                    transform = function(item)
                        item.label = item.pos and '󰈙 ' or nil
                        if not item.pos then
                            item.score_mul = 2
                        end
                    end,
                    live = true,
                    supports_live = true,
                    filter = {
                        transform = function(picker, filter)
                            filter.source_id = modes.get(search_modes, picker.opts.search_mode).source_id
                            -- Each source handles its own matching; do not filter text results again.
                            filter.pattern = ''
                        end,
                    },
                    layout = {
                        preset = 'vertical',
                        layout = {
                            row = 0.08,
                            width = 0.65,
                            max_height = 30,
                            min_height = 20,
                            title = '{title}',
                        },
                        config = function(layout)
                            for _, box in ipairs(layout.layout) do
                                if box.win == 'list' then
                                    box.height = 7
                                elseif box.win == 'preview' then
                                    box.height = nil -- Fill the space below the results.
                                end
                            end
                        end,
                    },
                },
            },
            win = {
                input = {
                    keys = {
                        ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
                    },
                },
            },
        },
    },
}
