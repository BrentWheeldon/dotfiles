set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.rbenv/shims/rougify

call vundle#begin()

Plugin 'gmarik/vundle'

Plugin 'djoshea/vim-autoread' " update changed files
Plugin 'airblade/vim-gitgutter' " git status in gutter
Plugin 'altercation/vim-colors-solarized' " theme
Plugin 'dense-analysis/ale' " linting, etc.
Plugin 'jgdavey/vim-blockle' " easily move curser between start and end of blocks
Plugin 'jremmen/vim-ripgrep' " fast searching
Plugin 'junegunn/fzf' " fuzzy finding
Plugin 'junegunn/fzf.vim' " fuzzy finding
Plugin 'machakann/vim-highlightedyank' " highlight yanked text
Plugin 'mkitt/tabline.vim' " nice tabs
Plugin 'scrooloose/nerdcommenter' " comment niceties
Plugin 'scrooloose/nerdtree' " file explorer
Plugin 'tpope/vim-abolish' " word variant niceties
Plugin 'tpope/vim-endwise' " insert 'end's, etc.
Plugin 'tpope/vim-fugitive' " git niceties
Plugin 'tpope/vim-projectionist' " related files niceties
Plugin 'tpope/vim-rails' " rails niceties
Plugin 'tpope/vim-repeat' " add plugin support for .
Plugin 'tpope/vim-rhubarb' " github niceties
Plugin 'tpope/vim-surround' " change surrounding quotes, etc.
Plugin 'tpope/vim-unimpaired' " navigation niceties
Plugin 'vim-airline/vim-airline' " status bar
Plugin 'vim-ruby/vim-ruby' " ruby niceties
Plugin 'vim-scripts/gitignore' " ignore things in gitignore
Plugin 'vim-scripts/nextval' " increment niceties
Plugin 'vim-scripts/regreplop.vim' " paste niceties

call vundle#end()

let mapleader = ","

cabbrev W w
cabbrev Q q
cabbrev Wa wa
cabbrev WA wa
cabbrev Wq wq
cabbrev WQ wq

map \           :NERDTreeToggle<CR>
map \|          :NERDTreeFind<CR>
map <leader>f   :Files<CR>
map <leader>/   <plug>NERDCommenterToggle
map <leader>c   :let @* = fnamemodify(expand("%"), ":~:.")<CR>:echo "Copied: ".fnamemodify(expand("%"), ":~:.")<CR>
map <leader>C   :let @* = fnamemodify(expand("%"), ":~:.").":".line(".")<CR>:echo "Copied: ".fnamemodify(expand("%"), ":~:.").":".line(".")<CR>
map <leader>ev  :e $MYVIMRC<cr>
map <leader>sv  :source $MYVIMRC<cr>
map <leader>l :!bin/rubocop -a %<CR>
map Y           yg_
map <MiddleMouse>   <Nop>
map <MiddleMouse>  <Nop>
map <C-t>       :tabe<CR>

" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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
set directory=~/.vim-tmp,~/tmp,/var/tmp,/tmp
set backupdir=~/.vim-tmp,~/tmp,/var/tmp,/tmp

set sessionoptions-=options

set hls                            " search with highlights by default
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>""

set autowriteall                   " Save when doing various buffer-switching things.
autocmd BufLeave,FocusLost * silent! wall

set encoding=utf-8 " Necessary to show unicode glyphs

let g:gitgutter_set_sign_backgrounds = 1
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1

set updatetime=100 " update things like gitgutter after 400ms

let ruby_operators=1

highlight clear SignColumn
call gitgutter#highlight#define_highlights()

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '✘'
highlight ALEWarningSign ctermfg=Red

command! -bang -nargs=* Find
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(empty(<q-args>)?expand("<cword>"):<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%', '?'),
  \   <bang>0)
autocmd FileType fzf tnoremap <buffer> <ESC> <C-c>

let g:rg_command = 'rg --vimgrep --sort-files'

" NeoTerm
let g:neoterm_autoinsert = 0
let g:neoterm_autoscroll = 0
let g:neoterm_size = 20
let g:neoterm_fixedsize = 1
let g:neoterm_open_in_all_tabs = 1

let g:ale_linters = {'ruby': ['ruby', 'rubocop']}
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace'], 'ruby': ['rubocop', 'remove_trailing_lines', 'trim_whitespace'] }
let g:ale_fix_on_save = 1
let g:ale_ruby_rubocop_executable = 'bin/rubocop'

autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell

au BufRead,BufNewFile *.md setlocal textwidth=80

" Local config
if filereadable($HOME . "/.config/nvim/local.vim")
  source ~/.config/nvim/local.vim
endif
