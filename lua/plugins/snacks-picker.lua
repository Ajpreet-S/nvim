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
                    formatters = { file = { filename_first = true } },
                    multi = { "files", { source = "grep", regex = false } },
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
                        layout = { row = 0.08, width = 0.65 },
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
