local limit = 5

local function add_file()
    local list = require('harpoon'):list()
    local item = list.config.create_list_item(list.config)
    if not item or item.value == '' or list:get_by_value(item.value) then
        return
    end
    if vim.tbl_count(list.items) >= limit then
        Snacks.notify.warn('Harpoon is full (' .. limit .. ' files). Remove a pin with Ctrl-x in the picker first.', {
            title = 'Harpoon',
        })
        return
    end
    list:add(item)
end

local function open_bookmarks()
    local list = require('harpoon'):list()
    return Snacks.picker.pick({
        source = 'harpoon',
        title = 'Harpoon',
        show_empty = true,
        cwd = list.config.get_root_dir(),
        finder = function()
            local items = {}
            for slot = 1, list:length() do
                local pin = list:get(slot)
                if pin then
                    items[#items + 1] = {
                        slot = slot,
                        file = pin.value,
                        text = pin.value,
                        pos = { pin.context.row, pin.context.col },
                    }
                end
            end
            return items
        end,
        format = function(item, picker)
            local display_item = vim.tbl_extend('force', {}, item)
            display_item.pos = nil
            return vim.list_extend({ { item.slot .. ' ', 'Comment' } }, Snacks.picker.format.file(display_item, picker))
        end,
        sort = { fields = { 'slot' } },
        confirm = function(picker, item)
            picker:close()
            if item then
                list:select(item.slot)
            end
        end,
        actions = {
            remove_pin = function(picker, item)
                if item then
                    list:remove_at(item.slot)
                    picker:find()
                end
            end,
        },
        win = {
            preview = { wo = { fillchars = 'eob: ' } },
            input = {
                keys = { ['<C-x>'] = { 'remove_pin', mode = { 'n', 'i' } } },
            },
            list = {
                keys = { ['<C-x>'] = 'remove_pin' },
            },
        },
        layout = {
            preset = 'vertical',
            layout = {
                row = 0.08,
                width = 0.65,
                max_height = 30,
                min_height = 20,
                title = '{title}',
            },
            config = function(layout)
                for _, box in ipairs(layout.layout) do
                    if box.win == 'list' then
                        box.height = limit
                    elseif box.win == 'preview' then
                        box.height = nil
                    end
                end
            end,
        },
    })
end

return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local harpoon = require('harpoon')
        harpoon:setup()
        harpoon.add_file = add_file
        harpoon.open_bookmarks = open_bookmarks
    end,
    lazy = true,
}
