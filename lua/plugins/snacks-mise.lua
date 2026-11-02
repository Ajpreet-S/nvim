local modes = require("pickers.modes")
local mise = require("tasks.mise")
local launch_modes = {
    { id = "neovim", label = "Neovim" },
    { id = "background", label = "Background" },
    { id = "external", label = "External" },
}

local function mise_tasks()
    local cwd = vim.fn.getcwd()
    mise.list(cwd, function(tasks)
        local launch_mode = "neovim"
        local function update_title(picker)
            modes.update_title(picker, launch_modes, launch_mode, mise.title)
        end
        local function cycle_launch_mode(picker, direction)
            launch_mode = modes.next(launch_modes, launch_mode, direction)
            update_title(picker)
        end

        Snacks.picker.select(tasks, {
            prompt = mise.title,
            format_item = function(task, supports_chunks)
                if supports_chunks then
                    return {
                        { task.name },
                        {
                            virt_text = { { " " .. task.description .. " ", "Comment" } },
                            virt_text_pos = "right_align",
                            hl_mode = "combine",
                        },
                    }
                end
                return task.name .. (task.description ~= "" and (" — " .. task.description) or "")
            end,
            snacks = {
                on_show = update_title,
                actions = {
                    next_launch_mode = function(picker) cycle_launch_mode(picker, 1) end,
                    previous_launch_mode = function(picker) cycle_launch_mode(picker, -1) end,
                },
                win = {
                    input = {
                        keys = {
                            ["<Tab>"] = { "next_launch_mode", mode = "i", desc = "Next launch mode" },
                            ["<S-Tab>"] = { "previous_launch_mode", mode = "i", desc = "Previous launch mode" },
                        },
                    },
                },
                layout = {
                    preset = "select",
                    layout = {
                        row = 0.15,
                        width = 65,
                        min_width = 65,
                    },
                },
            },
        }, function(task)
            if task then
                mise.run(task, cwd, launch_mode)
            end
        end)
    end)
end

return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>m", mise_tasks, desc = mise.title, mode = "n" },
    },
}
