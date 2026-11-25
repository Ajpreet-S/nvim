local rare_prefix = '.'
local rare_skip_chance = 0.5 -- 0 = always include rare splashes; 1 = always exclude.

math.randomseed(vim.uv.hrtime())
local include_rare = math.random() >= rare_skip_chance
local splash_file = vim.fn.stdpath('config') .. '/snacksDashboardSplashes.txt'
local splashes = {}
local readable, lines = pcall(vim.fn.readfile, splash_file)
if readable then
  for _, line in ipairs(lines) do
    local rare = line:sub(1, #rare_prefix) == rare_prefix
    line = rare and line:sub(#rare_prefix + 1) or line
    if line:find('%S') and not line:match('^%s*%-%-') and (not rare or include_rare) then
      splashes[#splashes + 1] = line:gsub('\\n', '\n')
    end
  end
end
local splash = #splashes > 0 and splashes[math.random(#splashes)] or nil
local attribution
if splash then
  local quote, author = splash:match('^(.-) | (.+)$')
  if author then
    splash = quote
    attribution = '— ' .. author
  end
end

local revealed = 0

local function splash_text()
  local remaining = revealed
  local result = {}
  for _, line in ipairs(vim.split(splash or '', '\n', { plain = true })) do
    local visible = vim.fn.strcharpart(line, 0, math.max(remaining, 0))
    result[#result + 1] = visible .. string.rep(' ', vim.fn.strdisplaywidth(line) - vim.fn.strdisplaywidth(visible))
    remaining = remaining - vim.fn.strchars(line) - 1
  end
  return table.concat(result, '\n')
end

local function animate_splash()
  if not splash then
    return
  end
  local buffer = vim.api.nvim_get_current_buf()
  local length = vim.fn.strchars(splash)
  revealed = 0
  if length == 0 or not Snacks.animate.enabled({ buf = buffer }) then
    revealed = length
    Snacks.dashboard.update()
    return
  end

  local cleanup
  local animation = Snacks.animate(0, length, function(value, context)
    revealed = value
    if context.done then
      vim.api.nvim_del_autocmd(cleanup)
    end
    Snacks.dashboard.update()
  end, {
    buf = buffer,
    duration = 20,
    easing = 'inOutSine',
    int = true,
  })
  cleanup = vim.api.nvim_create_autocmd({ 'BufLeave', 'BufWipeout', 'VimLeavePre' }, {
    buffer = buffer,
    once = true,
    callback = function(event)
      animation:stop()
      revealed = length
      if event.event == 'BufLeave' then
        Snacks.dashboard.update()
      end
    end,
  })
end

local function harpoon_section()
  local list = require('harpoon'):list()
  local keys = { 'j', 'k', 'l', ';' }
  local names = {}
  for _, item in pairs(list.items) do
    local name = vim.fn.fnamemodify(item.value, ':t')
    names[name] = (names[name] or 0) + 1
  end

  local section = {
    title = 'pinned files · ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
    padding = 1,
  }
  for slot = 1, list:length() do
    local item = list.items[slot]
    if item and item.value ~= '' then
      local name = vim.fn.fnamemodify(item.value, ':t')
      name = names[name] > 1 and item.value or name
      local hint = keys[slot] and ('[space-' .. keys[slot] .. '] ') or ''
      local index = slot
      section[#section + 1] = {
        desc = hint .. name,
        action = function()
          list:select(index)
        end,
      }
    end
  end
  return #section > 0 and section or nil
end

-- CONFIG HERE!
local dashboard = {
  enabled = true,
  width = 33,
  preset = {
    keys = {
      {
        icon = '',
        key = 'p',
        desc = 'Projects',
        action = function()
          Snacks.picker.projects({
            -- A list-only finder avoids scanning directories or adding recent projects.
            finder = function()
              return vim.tbl_map(function(path)
                path = vim.fs.normalize(vim.fn.expand(path))
                return { file = path, text = path, dir = true }
              end, require('config.projects'))
            end,
            confirm = { 'tcd', 'picker_explorer' },
          })
        end,
      },
      {
        icon = '󰆓',
        key = 's',
        desc = 'Sessions',
        action = function()
          require('config.sessions').select()
        end,
      },
      {
        icon = '',
        key = 'r',
        desc = 'Recents',
        action = function()
          Snacks.picker.recent()
        end,
      },
    },
  },
  sections = {
    { section = 'header', padding = 1 },
    function()
      return {
        text = { splash_text(), hl = 'header' },
        align = 'center',
        padding = attribution and 0 or 1,
        enabled = splash ~= nil,
      }
    end,
    { text = { attribution, hl = 'Comment' }, align = 'center', padding = 2, enabled = attribution ~= nil },
    { section = 'keys', gap = 1, padding = 1 },
    harpoon_section,
  },
}

return {
  'folke/snacks.nvim',
  init = function()
    vim.api.nvim_create_autocmd('User', {
      group = vim.api.nvim_create_augroup('DashboardSplashAnimation', { clear = true }),
      pattern = 'SnacksDashboardOpened',
      callback = animate_splash,
    })
  end,
  opts = {
    dashboard = dashboard,
  },
}
