set nocompatible

source ~/.config/nvim/plugins.vim

autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | OSCYankReg " | endif

let mapleader = ','
let maplocalleader = '-'

cabbrev W w
cabbrev Q q
cabbrev Wa wa
cabbrev WA wa
cabbrev Wq wq
cabbrev WQ wq

noremap \           :NERDTreeToggle<CR>
noremap \|          :NERDTreeFind<CR>
noremap <leader>f   :Files<CR>
noremap <leader>j   :call OSCYankString(expand("%"))<CR>
noremap <leader>J   :call OSCYankString(expand("%").":".line("."))<CR>
noremap <leader>ev  :vsp $MYVIMRC<cr>
noremap <leader>sv  :w<cr>:source $MYVIMRC<cr>
noremap Y           yg_
noremap <C-t>       :tabe<CR>
nnoremap <leader>w :Rg "\b<cword>\b"<cr>
noremap <MiddleMouse>  <Nop>

map <leader>/   <plug>NERDCommenterToggle

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" make me better at vim, kthxbai
inoremap jk <esc>
inoremap <esc> <nop>
nnoremap <Up> <nop>
nnoremap <Down> <nop>
nnoremap <Left> <nop>
nnoremap <Right> <nop>
inoremap <expr> <Up> pumvisible() ? "\<Up>" : ""
inoremap <expr> <Down> pumvisible() ? "\<Down>" : ""
inoremap <Left> <nop>
inoremap <Right> <nop>
vnoremap <Up> <nop>
vnoremap <Down> <nop>
vnoremap <Left> <nop>
vnoremap <Right> <nop>

" use C-j/k to go up/down in popup menu
inoremap <expr> <C-J> pumvisible() ? "\<C-N>" : "j"
inoremap <expr> <C-K> pumvisible() ? "\<C-P>" : "k"

" No, I _never_ want to use ed mode
nnoremap Q <nop>

" stuff to make filetype specific
noremap <leader>l :!bin/rubocop -a %<CR>
nnoremap <leader>d :Rg "def <cword>\b"<cr>
iabbrev fsl # frozen_string_literal: true<cr><BS><BS>
iabbrev pryy require "pry"; binding.pry

syntax enable
set background=dark
let g:solarized_termcolors = 256
colorscheme solarized

set vb    " Silence audio notifications

let NERDSpaceDelims = 1
let NERDTreeShowHidden = 1

filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins

set notimeout                      " No command timeout
set showcmd                        " Show typed command prefixes while waiting for operator
set mouse=a                        " Use mouse support in XTerm/iTerm.

set expandtab                      " Use soft tabs
set tabstop=2                      " Tab settings
set autoindent
set smarttab                       " Use shiftwidth to tab at line beginning
set shiftwidth=2                   " Width of autoindent
set number                         " Line numbers
set nowrap                         " No wrapping
set backspace=indent,eol,start     " Let backspace work over anything.
set wildignore+=tags,tmp/**        " Ignore tags when globbing.

set list                           " Show whitespace
set listchars=trail:·

set showmatch                      " Show matching brackets
set hidden                         " Allow hidden, unsaved buffers
set splitright                     " Add new windows towards the right
set splitbelow                     " ... and bottom
set wildmode=list:longest          " Bash-like tab completion
set scrolloff=3                    " Scroll when the cursor is 3 lines from edge
set cursorline                     " Highlight current line

set laststatus=2                   " Always show statusline

set incsearch                      " Incremental search
set history=1024                   " History size
set ignorecase
set smartcase                      " Smart case-sensitivity when searching

set autoread                       " No prompt for file changes outside Vim

set swapfile                       " Keep swapfiles
set directory=~/.vim-tmp           " Where to put swap files
set backupdir=~/.vim-tmp/backup    " Where to put backup files

set inccommand=nosplit             " Live updating of substitutions

set updatetime=100                 " update things like gitgutter after this many milliseconds

set number relativenumber          " show relative line numbers to encourage better vim use (rather than leaning on an arrow key for a minute)

set hls                            " search with highlights by default
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>""

set autowriteall                   " Save when doing various buffer-switching things.
augroup writeonblur
  autocmd!
  autocmd BufLeave,FocusLost * silent! wall
augroup END

set encoding=utf-8 " Necessary to show unicode glyphs

let g:gitgutter_set_sign_backgrounds = 1
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

let ruby_operators=1

highlight clear SignColumn
call gitgutter#highlight#define_highlights()

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '✘'
highlight ALEWarningSign ctermfg=Red

let g:rg_command = 'rg --vimgrep --sort-files'

let g:ale_linters = {'ruby': ['ruby', 'rubocop']}
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'], 'ruby': ['rubocop', 'remove_trailing_lines', 'trim_whitespace'] }
let g:ale_fix_on_save = 1
let g:ale_ruby_rubocop_executable = 'bin/rubocop'

augroup spelling
  autocmd!
  autocmd BufRead,BufNewFile *.md setlocal spell
  autocmd FileType gitcommit setlocal spell
augroup END
set complete+=kspell

augroup markdown
  autocmd!
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80
augroup END

let g:rg_command = 'rg --vimgrep --hidden --sort path --iglob !.git/'

" Local config
if filereadable($HOME . "/.config/nvim/local.vim")
  source ~/.config/nvim/local.vim
endif
