set nocompatible

source ~/.config/nvim/plugins.vim

autocmd TextYankPost * if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankReg "' | endif

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

cnoremap <C-A> <Home>

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

inoremap jk <esc>

" No, I _never_ want to use ed mode
nnoremap Q <nop>

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

set signcolumn=yes                 " always show sign column so things don't jump around

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

let g:rg_command = 'rg --vimgrep --hidden --sort path --iglob !.git/ --iglob !sorbet/'

" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
let g:airline#extensions#coc#enabled = 1
let airline#extensions#coc#error_symbol = 'E:'
let airline#extensions#coc#warning_symbol = 'W:'
let g:airline#extensions#coc#show_coc_status = 1
let airline#extensions#coc#stl_format_err = '%C(L%L)'
let airline#extensions#coc#stl_format_warn = '%C(L%L)'

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:projectionist_heuristics = {
      \  "lib/**/*.ex": {
      \    "alternate": "test/{}_test.exs",
      \    "type": "source",
      \    "template": [
      \      "defmodule {camelcase|capitalize|dot} do",
      \      "end"
      \    ]
      \  },
      \  "test/**/*_test.exs": {
      \    "alternate": "lib/{}.ex",
      \    "type": "test",
      \   "template": [
      \     "defmodule {camelcase|capitalize|dot}Test do",
      \     "  use ExUnit.Case, async: true",
      \     "",
      \     "  alias {camelcase|capitalize|dot}",
      \     "end"
      \   ]
      \  }
      \}

autocmd FileType cobol setlocal iskeyword+=-

lua << EOF
require("neotest").setup{
  adapters = {
    require("neotest-elixir"){
      -- Wrap the elixir command in direnv exec . to load the nix environment
      post_process_command = function(cmd)
        return vim.tbl_flatten({{"direnv", "exec", "."}, cmd})
      end,
    }
  }
}
EOF

noremap <leader>t   :lua require("neotest").run.run()<CR>
noremap <leader>T   :lua require("neotest").run.run(vim.fn.expand("%"))<CR>
noremap <leader>st  :lua require("neotest").summary.open()<CR>

" Local config
if filereadable($HOME . "/.config/nvim/local.vim")
  source ~/.config/nvim/local.vim
endif
