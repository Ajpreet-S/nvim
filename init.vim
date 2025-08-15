" Neovim config — annotated for future reference
" Conventions: each setting says what/why so future-you remembers.
"
" Philosophy / Intent:
" - Prefer readability and calm defaults over heavy customization.
" - Relative numbers for motion efficiency; system clipboard on by default.
" - Minimal mappings that aid navigation, windows, and buffers.

" Line numbers: absolute + relative for efficient motions
set number          " show absolute line numbers
set relativenumber  " show relative numbers from cursor

" Wrapping: keep long lines on one line (no soft wrap)
set nowrap          " don't wrap long lines

" Indentation: 4 spaces; convert tabs to spaces
set softtabstop=4   " spaces when pressing <Tab> in insert mode
set shiftwidth=4    " spaces used for << and >> and autoindent
set tabstop=4       " how many spaces a literal <Tab> counts for

" Soft ruler to guide line length
set cc=120          " draw a colorcolumn at 120

syntax on           " enable syntax highlighting

" --- Mappings ---
let mapleader="\<space>"   " Space as <Leader> for custom mappings

" Insert mode
" 'jk' quickly to leave insert mode
inoremap jk <esc>

" Normal mode — Files
nnoremap <leader>ex :Ex<cr>        " open file explorer (netrw)
nnoremap <leader>w :write<cr>      " save current file
nnoremap <leader>q :quit<cr>       " quit window
nnoremap <leader>wq :wq<cr>        " save and quit
nnoremap <leader>sv :source %<cr>  " source current file

" Normal mode — Editing
nnoremap <leader>o o<esc>          " new line below without entering insert
nnoremap <leader>O O<esc>          " new line above without entering insert
nnoremap <leader>noh :noh<cr>      " clear search highlight
nnoremap <leader>! :! 
set scrolloff=7     " keep 5 lines visible above/below cursor when scrolling

" --- QoL: Search ---
set ignorecase      " case-insensitive search by default
set smartcase       " ...but case-sensitive if pattern has uppercase
set incsearch       " show matches incrementally as you type
set hlsearch        " highlight all search matches

" --- QoL: UI ---
set signcolumn=yes  " always show signcolumn to prevent text shifting
set termguicolors   " enable 24-bit color support

" --- QoL: Clipboard and mouse ---
set clipboard=unnamedplus " use system clipboard for all yank/paste
set mouse=a               " enable mouse in all modes

" --- QoL: Persistent undo ---
set noswapfile      " avoid swap files (pair with undofile)
set undofile        " keep undo history across sessions
" set undodir=~/.local/share/nvim/undo " custom location for undo files

" --- QoL: Indentation helpers ---
set smartindent     " basic autoindent for common languages
filetype plugin indent on " enable filetype detection, plugins, indentation
