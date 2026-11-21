#!/usr/bin/env bash
# Regenerate neovimSnippets.pdf at the repository root.
set -euo pipefail

config_dir="$(cd -- "$(dirname -- "$0")/.." && pwd -P)"

if [[ $# -ne 0 ]]; then
    printf 'Usage: %s\n' "$0" >&2
    exit 2
fi

for tool in nvim typst; do
    if ! command -v "$tool" >/dev/null; then
        printf 'Required command not found: %s\n' "$tool" >&2
        exit 1
    fi
done

work_dir="$(mktemp -d "$config_dir/.snippets-pdf.XXXXXXXX")"
trap 'rm -rf -- "$work_dir"' EXIT

cat >"$work_dir/collect.lua" <<'LUA'
local config_dir, metadata_path = unpack(arg)
local luasnip_dir = vim.fn.stdpath('data') .. '/lazy/LuaSnip'
assert(vim.fn.isdirectory(luasnip_dir) == 1, 'Install LuaSnip in Neovim first: ' .. luasnip_dir)
vim.opt.runtimepath:prepend(luasnip_dir)

require('luasnip.loaders.from_lua').load({ paths = { config_dir .. '/snippets' } })

local groups = {}
local by_filetype = {}
local luasnip = require('luasnip')
for _, kind in ipairs({ 'snippets', 'autosnippets' }) do
    for filetype, snippets in pairs(luasnip.get_snippets(nil, { type = kind })) do
        for _, snippet in ipairs(snippets) do
            if not by_filetype[filetype] then
                by_filetype[filetype] = {}
            end
            table.insert(by_filetype[filetype], { trigger = snippet.trigger, name = snippet.name })
        end
    end
end

local language_names = { html = 'HTML', javascript = 'JavaScript', php = 'PHP' }
for _, filetype in ipairs(vim.fn.sort(vim.tbl_keys(by_filetype))) do
    local snippets = by_filetype[filetype]
    table.sort(snippets, function(left, right)
        if left.trigger == right.trigger then
            return left.name < right.name
        end
        return left.trigger:lower() < right.trigger:lower()
            or (left.trigger:lower() == right.trigger:lower() and left.trigger < right.trigger)
    end)
    table.insert(groups, { language = language_names[filetype] or filetype, snippets = snippets })
end

assert(#groups > 0, 'No LuaSnip snippets found in ' .. config_dir .. '/snippets')
assert(vim.fn.writefile({ vim.json.encode(groups) }, metadata_path) == 0, 'Could not write snippet metadata')
LUA

nvim --headless -u NONE -i NONE -n -l "$work_dir/collect.lua" "$config_dir" "$work_dir/snippets.json" </dev/null

cat >"$work_dir/snippets.typ" <<'TYPST'
#set document(title: "Snippets")
#set page(paper: "us-letter", margin: (x: 0.7in, y: 0.55in))
#set text(font: "Libertinus Serif", size: 11pt)
#set heading(numbering: none)

#align(left, text(size: 26pt, weight: "bold")[Snippets])
#v(6pt)

#for group in json("snippets.json") [
  #heading(level: 1, group.language)
  #for snippet in group.snippets [
    #block(below: 2pt)[#text(font: "DejaVu Sans Mono", size: 10pt, snippet.trigger) → #snippet.name]
  ]
]
TYPST

typst compile "$work_dir/snippets.typ" "$work_dir/neovimSnippets.pdf"
mv -fT -- "$work_dir/neovimSnippets.pdf" "$config_dir/neovimSnippets.pdf"
printf '%s\n' "$config_dir/neovimSnippets.pdf"
