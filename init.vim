set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=/Users/bwheeldon/.rvm/rubies/ruby-2.3.3/bin/rougify

call vundle#begin()

Plugin 'gmarik/vundle'

Plugin 'Keithbsmiley/rspec.vim', {'for': 'ruby'}
Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'djoshea/vim-autoread'
Plugin 'janko-m/vim-test'
Plugin 'jgdavey/vim-blockle'
Plugin 'jremmen/vim-ripgrep'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'kassio/neoterm'
Plugin 'kchmck/vim-coffee-script'
Plugin 'majutsushi/tagbar'
Plugin 'mkitt/tabline.vim'
Plugin 'mxw/vim-jsx'
Plugin 'nvie/vim-flake8'
Plugin 'pangloss/vim-javascript'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-scripts/gitignore'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'vim-scripts/nextval'
Plugin 'vim-scripts/regreplop.vim'
Plugin 'w0rp/ale'

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
map <D-N>       :Files<CR>
map <leader>f   :Files<CR>
map <leader>/   <plug>NERDCommenterToggle
map <leader>c   :let @* = expand("%")<CR>:echo "Copied: ".expand("%")<CR>
map <leader>C   :let @* = expand("%").":".line(".")<CR>:echo "Copied: ".expand("%").":".line(".")<CR>
map <leader>ev  :vsplit $MYVIMRC<cr>
map <leader>sv  :source $MYVIMRC<cr>
map <leader>u   :GundoToggle<CR>
map Y           yg_
map <MiddleMouse>   <Nop>
map <MiddleMouse>  <Nop>

nmap <silent> <leader>t :TestNearest<CR>
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>

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

au FocusLost * silent! wa

let python_highlight_all=1
syntax enable
set background=dark
let g:solarized_termcolors = 256
colorscheme solarized

set vb    " Silence audio notifications

autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost .git/index set nolist

let g:gundo_close_on_revert = 1

autocmd BufRead,BufNewFile *.json set filetype=javascript

function! StripTrailingWhitespace()
  let save_cursor = getpos(".")
  %s/\s\+$//e
  call setpos('.', save_cursor)
endfunction

autocmd BufWritePre *.* call StripTrailingWhitespace()

let g:ale_sign_column_always = 1
let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
let g:ale_sign_warning = '✘'
highlight ALEWarningSign ctermfg=Blue

let NERDSpaceDelims = 1

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
inoremap <c-s> <Esc>:w<CR>
noremap <c-s> :w<CR>

set autowriteall                   " Save when doing various buffer-switching things.
autocmd BufLeave,FocusLost * silent! wall

set encoding=utf-8 " Necessary to show unicode glyphs

autocmd FileType javascript let b:surround_36 = "$(\r)"
                        \ | let b:surround_95 = "_(\r)"

let ruby_operators=1

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

runtime macros/matchit.vim

highlight clear SignColumn
call gitgutter#highlight#define_highlights()

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

let g:loaded_python3_provider=1

" Vim Test
let g:test#strategy = 'neoterm'

" Ruby Tests
let g:test#ruby#runner = 'rspec'
let g:test#ruby#rspec#executable = 'spring rspec'
let g:test#ruby#rspec#file_pattern = '_spec\.rb'
let g:test#runner_commands = ['RSpec']
