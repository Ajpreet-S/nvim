local rare_prefix = "."
local rare_skip_chance = 0.5 -- 0 = always include rare splashes; 1 = always exclude.

math.randomseed(vim.uv.hrtime())
local include_rare = math.random() >= rare_skip_chance
local splash_file = vim.fn.stdpath("config") .. "/snacks-dashboard-splashes.txt"
local splashes = {}
local readable, lines = pcall(vim.fn.readfile, splash_file)
if readable then
    for _, line in ipairs(lines) do
        local rare = line:sub(1, #rare_prefix) == rare_prefix
        line = rare and line:sub(#rare_prefix + 1) or line
        if line:find("%S") and not line:match("^%s*%-%-") and (not rare or include_rare) then
            splashes[#splashes + 1] = line:gsub("\\n", "\n")
        end
    end
end
local splash = #splashes > 0 and splashes[math.random(#splashes)] or nil
local attribution
if splash then
    local quote, author = splash:match("^(.-) | (.+)$")
    if author then
        splash = quote
        attribution = "— " .. author
    end
end

local revealed = 0

local function splash_text()
    local remaining = revealed
    local result = {}
    for _, line in ipairs(vim.split(splash or "", "\n", { plain = true })) do
        local visible = vim.fn.strcharpart(line, 0, math.max(remaining, 0))
        result[#result + 1] = visible .. string.rep(" ", vim.fn.strdisplaywidth(line) - vim.fn.strdisplaywidth(visible))
        remaining = remaining - vim.fn.strchars(line) - 1
    end
    return table.concat(result, "\n")
end

local function animate_splash()
    if not splash then
        return
    end
    local buffer = vim.api.nvim_get_current_buf()
    local length = vim.fn.strchars(splash)
    local timer = assert(vim.uv.new_timer())
    local stopped = false
    local cleanup

    local function stop()
        if stopped then
            return
        end
        stopped = true
        timer:stop()
        timer:close()
        vim.api.nvim_del_autocmd(cleanup)
        revealed = length
    end

    cleanup = vim.api.nvim_create_autocmd({ "BufLeave", "BufWipeout", "VimLeavePre" }, {
        buffer = buffer,
        callback = function(event)
            stop()
            if event.event == "BufLeave" then
                Snacks.dashboard.update()
            end
        end,
    })
    revealed = 0
    local type_character
    type_character = vim.schedule_wrap(function()
        if stopped then
            return
        end
        if not vim.api.nvim_buf_is_valid(buffer) or vim.api.nvim_get_current_buf() ~= buffer then
            stop()
            return
        end
        revealed = revealed + 1
        Snacks.dashboard.update()
        if revealed >= length then
            stop()
            return
        end

        timer:start(math.random(12, 28), 0, type_character)
    end)
    timer:start(0, 0, type_character)
end


-- CONFIG HERE!
local dashboard = {
    enabled = true,
    width = 50,
    preset = {
        keys = {
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        }
    },
    sections = {
        { section = "header", padding = 1 },
        function()
            return {
                text = { splash_text(), hl = "header" },
                align = "center",
                padding = attribution and 0 or 1,
                enabled = splash ~= nil,
            }
        end,
        { text = { attribution, hl = "Comment" }, align = "center", padding = 2, enabled = attribution ~= nil },
        { section = "keys", gap = 1, padding = 1 },
    },
}

return {
    "folke/snacks.nvim",
    init = function()
        vim.api.nvim_create_autocmd("User", {
            group = vim.api.nvim_create_augroup("DashboardSplashAnimation", { clear = true }),
            pattern = "SnacksDashboardOpened",
            callback = animate_splash,
        })
    end,
    opts = {
        dashboard = dashboard,
    },
}
