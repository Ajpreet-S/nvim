local limit = 5

local function add_file()
    local list = require('harpoon'):list()
    local item = list.config.create_list_item(list.config)
    if not item or item.value == '' then
        return
    end
    if list:get_by_value(item.value) then
        Snacks.notify.info('Already pinned: ' .. item.value, { title = 'Harpoon' })
        return
    end
    if vim.tbl_count(list.items) >= limit then
        Snacks.notify.warn('Harpoon is full (' .. limit .. ' files). Remove a pin with dd in the menu first.', {
            title = 'Harpoon',
        })
        return
    end
    list:add(item)
    Snacks.notify.info('Pinned: ' .. item.value, { title = 'Harpoon' })
end

return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup()
        harpoon.add_file = add_file

        -- Harpoon changes list keys with cwd, but only loads saved data at setup.
        vim.api.nvim_create_autocmd('DirChanged', {
            group = vim.api.nvim_create_augroup('HarpoonProjectData', { clear = true }),
            callback = function()
                harpoon.data = require('harpoon.data').Data:new(harpoon.config)
            end,
        })
    end,
    lazy = true,
}
