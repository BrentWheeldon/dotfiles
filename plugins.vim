set nocompatible

call plug#begin(stdpath('data') . '/plugged')

Plug 'djoshea/vim-autoread' " update changed files
Plug 'airblade/vim-gitgutter' " git status in gutter
Plug 'altercation/vim-colors-solarized' " theme
Plug 'dense-analysis/ale' " linting, etc.
Plug 'jgdavey/vim-blockle' " easily move curser between start and end of blocks
Plug 'jremmen/vim-ripgrep' " fast searching
Plug 'junegunn/fzf' " fuzzy finding
Plug 'junegunn/fzf.vim' " fuzzy finding
Plug 'machakann/vim-highlightedyank' " highlight yanked text
Plug 'mkitt/tabline.vim' " nice tabs
Plug 'scrooloose/nerdcommenter' " comment niceties
Plug 'scrooloose/nerdtree' " file explorer
Plug 'tpope/vim-abolish' " word variant niceties
Plug 'tpope/vim-endwise' " insert 'end's, etc.
Plug 'tpope/vim-fugitive' " git niceties
Plug 'tpope/vim-projectionist' " related files niceties
Plug 'tpope/vim-rails' " rails niceties
Plug 'tpope/vim-repeat' " add plugin support for .
Plug 'tpope/vim-rhubarb' " github niceties
Plug 'tpope/vim-surround' " change surrounding quotes, etc.
Plug 'tpope/vim-unimpaired' " navigation niceties
Plug 'vim-airline/vim-airline' " status bar
Plug 'vim-ruby/vim-ruby' " ruby niceties
Plug 'vim-scripts/gitignore' " ignore things in gitignore
Plug 'vim-scripts/nextval' " increment niceties
Plug 'vim-scripts/regreplop.vim' " paste niceties

call plug#end()
