# AGENTS.md

## Agent workflow
- Before configuring, debugging, reviewing, or improving this Neovim setup, read `/home/aj/.pi/agent/skills/neovim-config/SKILL.md` and follow it. Include this requirement in relevant subagent briefs when delegation is authorized.

## Tooling preference
- Keep editor tooling low-bloat: favor a small set of tools and plugins, learn them well, and avoid unnecessary tool overlap and the mental overhead of excessive choices.
- Prefer/Recommend Neovim defaults and hand-rolled extensions/plugins/etc in order to not only keep bloat to a minimum, but to learn core Neovim fundamentals.
- Consider aligning keymaps to Vanilla NeoVim > Chrome or Chrome Dev Tools > JetBrains IDEs > VSCode. This is to build transferrable muscle memory.

## Lua style
- Use single-quoted strings.

## Neovim Setup Context/Rules
- `init.lua` is the config entry script
- `lua/config/options.lua` sets all Vanilla Neovim options and the leader key
- Keep global shortcuts in `lua/config/keymaps.lua`, grouped by purpose, so existing mappings are easy to find and new ones easy to add (the leader key stays in `options.lua`).
- Keep context-specific controls (e.g. picker-local bindings and dashboard buttons) alongside their plugin configuration. Preserve lazy-loading behavior and buffer-local scope when moving mappings; avoid extra abstractions just to centralize them.
