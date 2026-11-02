local M = { limit = 5 }

function M.add()
    local list = require("harpoon"):list()
    local item = list.config.create_list_item(list.config)
    if not item or item.value == "" or list:get_by_value(item.value) then
        return
    end
    if vim.tbl_count(list.items) >= M.limit then
        Snacks.notify.warn("Harpoon is full (" .. M.limit .. " files). Remove a pin with Ctrl-x in the picker first.", {
            title = "Harpoon",
        })
        return
    end
    list:add(item)
end

return M
