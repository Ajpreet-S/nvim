" line numbers
set number relativenumber nowrap

" tabs
set softtabstop=4
set shiftwidth=4
set expandtab

" column line at 100th column
set cc=100

" enable syntax highlighting
syntax on

" remaps
let mapleader="\<space>"
inoremap jk <esc>
nnoremap <leader>ex :Ex<cr>
nnoremap <leader>wq :wq<cr>

" Show at least 5 lines above or below when scrolling
set scrolloff=5
