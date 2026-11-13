return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        spec = {
            { "<leader>c", group = "Code", mode = { "n", "x" } },
            { "<leader>d", group = "Diagnostics" },
        },
    },
    keys = {
        {
            "<leader>?",
            function() require("which-key").show({ global = true }) end,
            desc = "Show Keymaps",
        },
    },
}
