local picker_title = "Mise Tasks"
local launch_modes = { "Neovim", "Background", "External" }
-- Replace this argument prefix to use another external terminal launcher.
local external_terminal = { "xdg-terminal-exec", "--hold", "--" }

local function run_task(task, cwd, mode)
    local command = { "mise", "run", task.name }
    local options = { cwd = cwd, auto_close = false }
    local terminal = Snacks.terminal.get(command, vim.tbl_extend("force", options, { create = false }))
    if terminal then
        local job = vim.b[terminal.buf].terminal_job_id
        if vim.fn.jobwait({ job }, 0)[1] == -1 then
            if mode == "Background" then
                terminal:hide()
            else
                if mode == "External" then
                    Snacks.notify.info("Task already running in Neovim; showing its terminal.", { title = picker_title })
                end
                terminal:show()
                terminal:focus()
                vim.cmd.startinsert()
            end
            return
        end
    end

    if mode == "External" then
        if vim.fn.executable(external_terminal[1]) == 0 then
            Snacks.notify.warn("Configure an available external terminal launcher in snacks-mise.lua.", { title = picker_title })
            return
        end
        local arguments = vim.list_extend(vim.deepcopy(external_terminal), command)
        local job = vim.fn.jobstart(arguments, {
            cwd = cwd,
            detach = true,
            on_exit = function(_, code)
                if code ~= 0 then
                    Snacks.notify.error("External terminal exited with code " .. code .. ".", { title = picker_title })
                end
            end,
        })
        if job <= 0 then
            Snacks.notify.error("Could not start the external terminal.", { title = picker_title })
        end
        return
    end

    if terminal then
        terminal:close()
    end
    local background = mode == "Background"
    options.interactive = not background
    options.win = { enter = not background }
    terminal = Snacks.terminal.open(command, options)
    if background then
        terminal:hide()
    end
end

local function mise_tasks()
    if vim.fn.executable("mise") == 0 then
        Snacks.notify.warn("mise is not installed or not on PATH.", { title = picker_title })
        return
    end

    local cwd = vim.fn.getcwd()
    vim.system({ "mise", "tasks", "--json" }, { cwd = cwd, text = true }, vim.schedule_wrap(function(result)
        if result.code ~= 0 then
            local message = vim.trim(result.stderr or "")
            Snacks.notify.error(message ~= "" and message or "Could not list mise tasks.", { title = picker_title })
            return
        end

        local valid, tasks = pcall(vim.json.decode, result.stdout)
        if not valid or type(tasks) ~= "table" or not vim.islist(tasks) then
            Snacks.notify.error("mise returned an invalid task list.", { title = picker_title })
            return
        end
        if #tasks == 0 then
            Snacks.notify.info("No mise tasks available in this directory.", { title = picker_title })
            return
        end

        local launch_mode = 1
        local function update_title(picker)
            local layout = vim.deepcopy(picker.resolved_layout)
            layout.layout.title = { { picker_title .. " ·", "FloatTitle" } }
            for index, mode in ipairs(launch_modes) do
                layout.layout.title[#layout.layout.title + 1] = {
                    mode .. (index < #launch_modes and " ·" or ""),
                    index == launch_mode and "FloatTitle" or "Comment",
                }
            end
            picker:set_layout(layout)
        end
        local function cycle_launch_mode(picker, direction)
            launch_mode = (launch_mode - 1 + direction) % #launch_modes + 1
            update_title(picker)
        end

        Snacks.picker.select(tasks, {
            prompt = picker_title,
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
                run_task(task, cwd, launch_modes[launch_mode])
            end
        end)
    end))
end

return {
    "folke/snacks.nvim",
    keys = {
        { "<leader>m", mise_tasks, desc = picker_title, mode = "n" },
    },
}
