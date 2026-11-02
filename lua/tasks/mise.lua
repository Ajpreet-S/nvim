local M = { title = "Mise Tasks" }

-- Replace this argument prefix to use another external terminal launcher.
local external_terminal = { "xdg-terminal-exec", "--hold", "--" }

function M.run(task, cwd, mode)
    local command = { "mise", "run", task.name }
    local options = { cwd = cwd, auto_close = false }
    local terminal = Snacks.terminal.get(command, vim.tbl_extend("force", options, { create = false }))
    if terminal then
        local job = vim.b[terminal.buf].terminal_job_id
        if vim.fn.jobwait({ job }, 0)[1] == -1 then
            if mode == "background" then
                terminal:hide()
            else
                if mode == "external" then
                    Snacks.notify.info("Task already running in Neovim; showing its terminal.", { title = M.title })
                end
                terminal:show()
                terminal:focus()
                vim.cmd.startinsert()
            end
            return
        end
    end

    if mode == "external" then
        if vim.fn.executable(external_terminal[1]) == 0 then
            Snacks.notify.warn("Configure an available external terminal launcher in lua/tasks/mise.lua.", { title = M.title })
            return
        end
        local arguments = vim.list_extend(vim.deepcopy(external_terminal), command)
        local job = vim.fn.jobstart(arguments, {
            cwd = cwd,
            detach = true,
            on_exit = function(_, code)
                if code ~= 0 then
                    Snacks.notify.error("External terminal exited with code " .. code .. ".", { title = M.title })
                end
            end,
        })
        if job <= 0 then
            Snacks.notify.error("Could not start the external terminal.", { title = M.title })
        end
        return
    end

    if terminal then
        terminal:close()
    end
    local background = mode == "background"
    options.interactive = not background
    options.win = { enter = not background }
    terminal = Snacks.terminal.open(command, options)
    if background then
        terminal:hide()
    end
end

function M.list(cwd, on_tasks)
    if vim.fn.executable("mise") == 0 then
        Snacks.notify.warn("mise is not installed or not on PATH.", { title = M.title })
        return
    end

    vim.system({ "mise", "tasks", "--json" }, { cwd = cwd, text = true }, vim.schedule_wrap(function(result)
        if result.code ~= 0 then
            local message = vim.trim(result.stderr or "")
            Snacks.notify.error(message ~= "" and message or "Could not list mise tasks.", { title = M.title })
            return
        end

        local valid, tasks = pcall(vim.json.decode, result.stdout)
        if not valid or type(tasks) ~= "table" or not vim.islist(tasks) then
            Snacks.notify.error("mise returned an invalid task list.", { title = M.title })
            return
        end
        if #tasks == 0 then
            Snacks.notify.info("No mise tasks available in this directory.", { title = M.title })
            return
        end

        on_tasks(tasks)
    end))
end

return M
