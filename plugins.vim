set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim

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
