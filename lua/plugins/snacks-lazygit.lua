return {
    "folke/snacks.nvim",
    opts = {
        lazygit = {
            win = { width = 0, height = 0, border = "none" },
        },
    },
    keys = {
        { "<leader>g", function() Snacks.lazygit() end, desc = "LazyGit", mode = "n" },
    },
}
