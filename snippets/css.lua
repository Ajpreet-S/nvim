local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local sn = ls.snippet_node
local rep = require('luasnip.extras').rep

ls.config.set_config({
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
})

return {
  -- hello world!
  s({ trig = 'reset', name = 'Bootstrap HTML boilerplate' }, {
    t({
      '::before,',
      '::after,',
      '* {',
      '    padding: 0;',
      '    margin: 0;',
      '    box-sizing: border-box;',
      '}',
    }),
  }),
}
