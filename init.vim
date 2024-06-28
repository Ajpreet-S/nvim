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

let mapleader="\<space>"
" normal mode remaps
inoremap jk <esc>

" insert mode remaps
nnoremap <leader>ex :Ex<cr>
nnoremap <leader>wq :wq<cr>
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>
nnoremap <leader>! :! 
nnoremap <leader>noh :noh<cr>


" Show at least 5 lines above or below when scrolling
set scrolloff=5
