return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>a", function() Snacks.picker.pick("all") end, desc = "Search All", mode = "n" },
    },
    opts = {
        picker = {
            enabled = true,
            sources = {
                all = {
                    title = "All",
                    prompt = "   ",
                    win = {
                        preview = { wo = { fillchars = "eob: ", wrap = false } },
                    },
                    formatters = { file = { filename_first = true } },
                    icons = { files = { enabled = false } },
                    multi = { "files", { source = "grep", regex = false } },
                    matcher = { frecency = true, sort_empty = true },
                    transform = function(item)
                        item.label = item.pos and "󰈙 " or " "
                        if not item.pos then
                            item.score_mul = 2
                        end
                    end,
                    live = true,
                    supports_live = true,
                    filter = {
                        transform = function(_, filter)
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
                                    box.title = ""
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
