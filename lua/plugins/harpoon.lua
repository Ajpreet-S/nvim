return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("harpoon"):setup()
    end,
    keys = {
        { "<leader>H", function() require("bookmarks.harpoon").add() end, desc = "Harpoon Add File", mode = "n" },
        { "<leader>h", function() require("pickers.harpoon").open() end, desc = "Harpoon Menu", mode = "n" },
        { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1", mode = "n" },
        { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2", mode = "n" },
        { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3", mode = "n" },
        { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4", mode = "n" },
        { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon File 5", mode = "n" },
    },
}
