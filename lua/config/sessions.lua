local M = {}
-- Closing the explorer/splits briefly enters file buffers before the dashboard appears.
local opening_dashboard = false

local function enrolled()
    return vim.fn.filereadable(require('persistence').current() .. '.enrolled') == 1
end

function M.enroll()
    local persistence = require('persistence')
    persistence.save()
    vim.fn.writefile({}, persistence.current() .. '.enrolled')
    persistence.start()
    vim.notify('Project session saved; future updates are automatic.', vim.log.levels.INFO)
end

local function is_file(buf)
    return vim.bo[buf].buftype == ''
        and vim.api.nvim_buf_get_name(buf) ~= ''
        and not vim.tbl_contains({ 'gitcommit', 'gitrebase', 'jj' }, vim.bo[buf].filetype)
end

local function can_restore()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.bo[buf].buftype == '' and vim.bo[buf].modified then
            vim.notify('Save or discard unsaved edits before restoring a session.', vim.log.levels.WARN)
            return false
        end
    end
    return true
end

local function restore(file)
    if not can_restore() then
        return
    end
    if not file or vim.fn.filereadable(file) == 0 then
        vim.notify('No saved session found.', vim.log.levels.INFO)
        return
    end
    local persistence = require('persistence')
    persistence.fire('LoadPre')
    vim.cmd('source ' .. vim.fn.fnameescape(file))
    if enrolled() then
        persistence.start()
    else
        persistence.stop()
    end
    persistence.fire('LoadPost')
end

function M.resume()
    restore(require('persistence').last())
end

function M.select()
    if not can_restore() then
        return
    end
    local files = require('persistence').list()
    if #files == 0 then
        vim.notify('No saved sessions found.', vim.log.levels.INFO)
        return
    end
    -- Select the exact snapshot, including its branch, rather than only its directory.
    Snacks.picker.select(files, {
        prompt = 'Sessions (Ctrl-D to delete)',
        format_item = function(file)
            return vim.fn.fnamemodify(file, ':t:r'):gsub('%%%%', ' · '):gsub('%%', '/')
        end,
        snacks = {
            actions = {
                delete_session = function(picker, item)
                    if not item then
                        return
                    end
                    local file = item.item
                    if vim.fn.delete(file) ~= 0 then
                        vim.notify('Could not delete session: ' .. file, vim.log.levels.ERROR)
                        return
                    end
                    if vim.fn.filereadable(file .. '.enrolled') == 1 then
                        vim.fn.delete(file .. '.enrolled')
                    end
                    if not enrolled() then
                        require('persistence').stop()
                    end
                    picker:close()
                    vim.notify('Session deleted.', vim.log.levels.INFO)
                end,
            },
            win = {
                input = { keys = { ['<c-d>'] = { 'delete_session', mode = { 'i', 'n' } } } },
                list = { keys = { ['<c-d>'] = 'delete_session' } },
            },
        },
    }, function(file)
        if file then
            restore(file)
        end
    end)
end

function M.before_dashboard()
    local persistence = require('persistence')
    if persistence.active() then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            if is_file(vim.api.nvim_win_get_buf(win)) then
                persistence.save()
                break
            end
        end
    end
    -- Hidden file buffers still count towards Persistence's exit-save minimum.
    -- Pause so quitting from the dashboard cannot overwrite the working layout.
    opening_dashboard = true
    persistence.stop()
end

function M.after_dashboard()
    opening_dashboard = false
end

function M.setup()
    require('persistence').stop()
    vim.api.nvim_create_autocmd({ 'BufEnter', 'DirChanged' }, {
        group = vim.api.nvim_create_augroup('SessionEditing', { clear = true }),
        callback = function(event)
            local persistence = require('persistence')
            if not enrolled() then
                persistence.stop()
            elseif not opening_dashboard and is_file(event.buf) and not persistence.active() then
                persistence.start()
            end
        end,
    })
end

return M
