return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    scroll = {
      enabled = true,
      animate = { duration = { step = 8, total = 120 } },
      animate_repeat = { duration = { step = 4, total = 40 } },
      -- Keep prompts, terminals, and other special buffers instant.
      filter = function(buf)
        return vim.g.snacks_scroll ~= false and vim.b[buf].snacks_scroll ~= false and vim.bo[buf].buftype == ''
      end,
    },
    words = {
      enabled = true,
      modes = { 'n' },
      debounce = 250,
      notify_jump = false,
      notify_end = false,
    },
  },
  dependencies = {
    { 'nvim-mini/mini.icons', opts = {} },
  },
}
