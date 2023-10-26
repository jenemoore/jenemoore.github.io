---
title: "a vimrc for writers"
type: "post"
date: 2022-10-10
tags: "vim", "config"
---

"a vimrc for writers

syntax on

set noerrorbells "to turn off the default error noise
set textwidth=100
set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set linebreak
set number
set showmatch
set showbreak=++
set smartcase
set noswapfile
set undodir=/vimfiles/undodir
set undofile
set incsearch
set spell
set showmatch
set confirm
set ruler
set autochdir
set autowriteall
set undolevels=1000
set backspace=indent,eol,start

"writing linewrap
set wrap
nnoremap <F5> :set linebreak<CR>
nnoremap <C-F5> :set nolinebreak<CR>

Prose writing plugins:
dpelle/vim-LanguageTool
ron89/.thesaurus_query.vim
junegunn/goyo.vim
junegunn/limelight.vim
reedes/vim-pencil
reedes/vim-wordy
thaerkh/vim-workspace

let g:workspace_session_directory = $HOME . '/vimfiles/sessions/'

jceb/vim-orgmode


