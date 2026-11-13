return {
    "folke/snacks.nvim",
    dependencies = {
        { "nvim-mini/mini.icons", opts = {} },
    },
    priority = 1000,
    lazy = false,
    keys = {
        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    },
    opts = {
        explorer = { enabled = true },
    },
}
