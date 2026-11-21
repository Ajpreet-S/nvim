local M = {}

-- Enumerate once per query, then use ripgrep regex or Snacks fuzzy matching.
function M.find(opts, ctx)
  local query = ctx.filter.search
  local pattern = Snacks.picker.util.parse(query)
  ctx.filter = ctx.filter:clone()
  ctx.filter.search = ''
  opts = vim.tbl_extend('force', {}, opts, { cmd = 'rg', sep = '\0' })
  opts.args = vim.list_extend(vim.deepcopy(opts.args or {}), { '--null', '--no-config' })
  ctx = ctx:clone(opts)
  local files = require('snacks.picker.source.files').files(opts, ctx)

  if not opts.search_regex then
    local matcher = require('snacks.picker.core.matcher').new(opts.matcher)
    matcher:init(query)
    return function(cb)
      files(function(item)
        local score = matcher:match(item)
        if score > 0 then
          item.score_add = score
          cb(item)
        end
      end)
    end
  end

  return function(cb)
    local paths = {}
    files(function(item)
      paths[#paths + 1] = item.file
    end)
    if #paths == 0 then
      return
    end

    local async = ctx.async
    local result
    local process = vim.system({
      'rg',
      '--no-config',
      '--engine=default',
      '--null-data',
      '--color=never',
      '--no-heading',
      '--no-filename',
      '--no-line-number',
      '--smart-case',
      '--',
      pattern,
    }, { stdin = table.concat(paths, '\0') .. '\0' }, function(output)
      result = output
      async:resume()
    end)
    async:on('abort', function()
      if not result then
        process:kill('sigterm')
      end
    end)
    while not result do
      async:suspend()
    end
    -- No matches and incomplete/invalid expressions are normal during live typing.
    if result.code ~= 0 then
      return
    end
    for path in vim.gsplit(result.stdout, '\0', { plain = true, trimempty = true }) do
      cb({ text = path, file = path, cwd = opts.cwd or ctx:cwd() })
    end
  end
end

return M
