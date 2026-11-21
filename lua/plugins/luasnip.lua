return {
    {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        lazy = true,
        config = function()
            require('luasnip.loaders.from_lua').lazy_load({
                paths = { vim.fn.stdpath('config') .. '/snippets' },
            })
        end,
    },
    {
        'saghen/blink.cmp',
        dependencies = { 'L3MON4D3/LuaSnip' },
        opts = {
            snippets = { preset = 'luasnip' },
        },
    },
}
