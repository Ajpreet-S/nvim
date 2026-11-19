local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s({ trig = 'cl', name = 'console.log' }, {
        t('console.log('),
        i(1, 'value'),
        t(');'),
        i(0),
    }),
    s({ trig = '()y', name = 'arrow function' }, {
        t('('),
        i(1, 'args'),
        t({ ') => {', '\t' }),
        i(0),
        t({ '', '};' }),
    }),
}
