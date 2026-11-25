-- Neovim options. Loaded before lazy.nvim.

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.autoread = true
vim.opt.undofile = true -- Keep undo history after saving and reopening files.
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.cmdheight = 1
vim.opt.fillchars:append({ eob = ' ' })

-- Restore editing layouts, not help windows, terminals, or empty dashboard panes.
vim.opt.sessionoptions = { 'buffers', 'curdir', 'folds', 'tabpages', 'winsize' }

-- Default indentation; override per language in after/ftplugin/<filetype>.lua.
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.g.autoformat = false

-- Set leaders before loading plugins so their mappings use the right keys.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
