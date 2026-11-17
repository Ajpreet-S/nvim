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
                }
            }
        }
    },
}
