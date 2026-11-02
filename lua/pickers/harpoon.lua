local M = {}

function M.open()
    local list = require("harpoon"):list()
    return Snacks.picker.pick({
        source = "harpoon",
        title = "Harpoon",
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
            local display_item = vim.tbl_extend("force", {}, item)
            display_item.pos = nil
            return vim.list_extend({ { item.slot .. " ", "Comment" } }, Snacks.picker.format.file(display_item, picker))
        end,
        sort = { fields = { "slot" } },
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
            preview = { wo = { fillchars = "eob: " } },
            input = {
                keys = { ["<C-x>"] = { "remove_pin", mode = { "n", "i" } } },
            },
            list = {
                keys = { ["<C-x>"] = "remove_pin" },
            },
        },
        layout = {
            preset = "vertical",
            layout = {
                row = 0.08,
                width = 0.65,
                max_height = 30,
                min_height = 20,
                title = "{title}",
            },
            config = function(layout)
                for _, box in ipairs(layout.layout) do
                    if box.win == "list" then
                        box.height = require("bookmarks.harpoon").limit
                    elseif box.win == "preview" then
                        box.height = nil
                    end
                end
            end,
        },
    })
end

return M
