local modes = require("pickers.modes")
-- Source IDs follow the order of the multi-source list.
local search_modes = {
    { id = "all", label = "All" },
    { id = "files", label = "Files", source_id = 1 },
    { id = "text", label = "Text", source_id = 2 },
}

local function update_mode_title(picker)
    picker.title = modes.get(search_modes, picker.opts.search_mode).label
    modes.update_title(picker, search_modes, picker.opts.search_mode)
end

local function cycle_search_mode(picker, direction)
    picker.opts.search_mode = modes.next(search_modes, picker.opts.search_mode, direction)
    update_mode_title(picker)
    picker:find()
end

return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>a", function() Snacks.picker.pick("all") end, desc = "Search All", mode = "n" },
        { "<leader>f", function() Snacks.picker.pick("all", { search_mode = "files" }) end, desc = "Search Files", mode = "n" },
        { "<leader>g", function() Snacks.picker.pick("all", { search_mode = "text" }) end, desc = "Search Text", mode = "n" },
    },
    opts = {
        picker = {
            enabled = true,
            prompt = "   ",
            sources = {
                all = {
                    title = "All",
                    search_mode = "all",
                    on_show = update_mode_title,
                    actions = {
                        next_search_mode = function(picker) cycle_search_mode(picker, 1) end,
                        previous_search_mode = function(picker) cycle_search_mode(picker, -1) end,
                    },
                    win = {
                        input = {
                            keys = {
                                ["<Tab>"] = { "next_search_mode", mode = "i", desc = "Next search mode" },
                                ["<S-Tab>"] = { "previous_search_mode", mode = "i", desc = "Previous search mode" },
                            },
                        },
                        preview = { wo = { fillchars = "eob: ", wrap = false } },
                    },
                    formatters = { file = { filename_first = true } },
                    format = function(item, picker)
                        local display_item = vim.tbl_extend("force", {}, item)
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
                                virt_text = { { " " .. path .. " ", "SnacksPickerDir" } },
                                virt_text_pos = "right_align",
                                hl_mode = "combine",
                            }
                            return result
                        end
                        return Snacks.picker.format.file(display_item, picker)
                    end,
                    multi = { "files", { source = "grep", regex = false } },
                    matcher = { frecency = true, sort_empty = true },
                    transform = function(item)
                        item.label = item.pos and "󰈙 " or nil
                        if not item.pos then
                            item.score_mul = 2
                        end
                    end,
                    live = true,
                    supports_live = true,
                    filter = {
                        transform = function(picker, filter)
                            filter.source_id = modes.get(search_modes, picker.opts.search_mode).source_id
                            -- Match file names with the same query used for text search.
                            filter.pattern = filter.search
                        end,
                    },
                    layout = {
                        preset = "vertical",
                        layout = {
                            row = 0.08,
                            width = 0.65,
                            max_height = 30,
                            min_height = 20,
                            title = "{title}",
                        },
                        config = function(layout)
                            for _, box in ipairs(layout.layout) do
                                if box.win == "list" then
                                    box.height = 7
                                elseif box.win == "preview" then
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
                        ["<Esc>"] = { "close", mode = { "n", "i" } },
                    },
                },
            },
        },
    },
}
