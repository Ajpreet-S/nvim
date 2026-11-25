local M = {}
local api = vim.api

function M.arrange()
  local tab = api.nvim_get_current_tabpage()
  vim.schedule(function()
    if api.nvim_get_current_tabpage() ~= tab then
      return
    end

    local debugger
    for _, win in ipairs(api.nvim_tabpage_list_wins(tab)) do
      if api.nvim_win_get_config(win).relative == '' and vim.w[win].dapview_win then
        debugger = win
      end
    end
    if not debugger then
      return
    end

    local debug_height = api.nvim_win_get_height(debugger)
    api.nvim_win_call(debugger, function() vim.cmd.wincmd('J') end)
    api.nvim_win_set_height(debugger, debug_height)
  end)
end

return M
