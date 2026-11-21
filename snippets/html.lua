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
  s({ trig = 'HTML', name = 'Bootstrap HTML boilerplate' }, {
    t({
      '<!doctype html>',
      '<html lang="en">',
      '  <head>',
      '    <meta charset="utf-8">',
      '    <meta name="viewport" content="width=device-width, initial-scale=1">',
      '    <title>WebPage</title>',
      '    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.9/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-yEPZ7jP9S0QKiUQ0m3jjsO4ProIW7wvR9gXkI7JOGa2XVsw53Yke2bsdkBbjmmiX" crossorigin="anonymous">',
      '  </head>',
      '  <body>',
      '    ',
    }),
    i(1),
    t({
      '',
      '    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.9/dist/js/bootstrap.bundle.min.js" integrity="sha384-WyOxWvTyr1QaMPfiPJSv76iReVthorl5uWlFtZPyK0IEB0hGzo9y5Bp9mYanr8Bu" crossorigin="anonymous"></script>',
      '  </body>',
      '</html>',
    }),
  }),
  s({ trig = 'bsbtn', name = 'Bootstrap button' }, {
    t('<button type="'),
    i(1, 'button'),
    t('" class="btn btn-'),
    i(2, 'primary'),
    t('">'),
    i(3, 'Button'),
    t('</button>'),
  }),
  s({ trig = 'bsfield', name = 'Bootstrap labeled input' }, {
    t({ '<div class="mb-3">', '  <label class="form-label" for="' }),
    i(1, 'field-id'),
    t('">'),
    i(2, 'Label'),
    t({ '</label>', '  <input class="form-control" id="' }),
    rep(1),
    t('" type="'),
    i(3, 'text'),
    t({ '">', '</div>' }),
  }),
  s({ trig = 'bscheck', name = 'Bootstrap checkbox or switch' }, {
    t('<div class="form-check'),
    c(1, { t(''), t(' form-switch') }),
    t({ '">', '  <input class="form-check-input" type="checkbox" id="' }),
    i(2, 'check-id'),
    t({ '">', '  <label class="form-check-label" for="' }),
    rep(2),
    t('">'),
    i(3, 'Label'),
    t({ '</label>', '</div>' }),
  }),
  s({ trig = 'bsmodal', name = 'Bootstrap custom modal' }, {
    t('<div class="modal fade" id="'),
    i(1, 'modal-id'),
    t('" tabindex="-1" aria-labelledby="'),
    rep(1),
    t({
      '-title" aria-hidden="true">',
      '  <div class="modal-dialog">',
      '    <div class="modal-content">',
      '      <div class="modal-header">',
      '        <h2 class="modal-title fs-5" id="',
    }),
    rep(1),
    t('-title">'),
    i(2, 'Modal title'),
    t({
      '</h2>',
      '        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>',
      '      </div>',
      '      <div class="modal-body">',
      '        ',
    }),
    i(3),
    t({
      '',
      '      </div>',
      '    </div>',
      '  </div>',
      '</div>',
    }),
  }),
  s({ trig = 'bscard', name = 'Bootstrap card' }, {
    t('<div class="card">'),
    c(1, {
      t(''),
      sn(nil, {
        t({ '', '  <div class="card-header">' }),
        i(1, 'Card header'),
        t('</div>'),
      }),
    }),
    t({ '', '  <div class="card-body">', '    ' }),
    i(2),
    t({ '', '  </div>', '</div>' }),
  }),
}
