return {
    "folke/snacks.nvim",
    opts = {
        picker = {
            enabled = true,
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
