local M = {}

function M.get(modes, id)
    for index, mode in ipairs(modes) do
        if mode.id == id then
            return mode, index
        end
    end
    error("Unknown picker mode: " .. tostring(id))
end

function M.next(modes, current, direction)
    local _, index = M.get(modes, current)
    return modes[(index - 1 + direction) % #modes + 1].id
end

function M.update_title(picker, modes, current, title)
    local layout = vim.deepcopy(picker.resolved_layout)
    layout.layout.title = title and { { title .. " ·", "FloatTitle" } } or {}
    for index, mode in ipairs(modes) do
        layout.layout.title[#layout.layout.title + 1] = {
            mode.label .. (index < #modes and " ·" or ""),
            mode.id == current and "FloatTitle" or "Comment",
        }
    end
    picker:set_layout(layout)
end

return M
