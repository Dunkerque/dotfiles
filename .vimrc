set nocompatible      " Nécessaire
filetype off          " Nécessaire

" Ajout de Vundle au runtime path et initialisation
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
    
" On indique à Vundle de s'auto-gérer :)
Plugin 'gmarik/Vundle.vim'  " Nécessaire
 
" C'est ici que vous allez placer la liste des plugins que Vundle doit gérer

call vundle#end()            " Nécessaire
filetype plugin indent on    " Nécessaire


" CONFIG
syntax enable
colorscheme monokai
set nocompatible

" support mous 
set mouse=a
set number

" windows like clipboard
" yank to and paste from the clipboard without prepending "* to commands
let &clipboard = has('unnamedplus') ? 'unnamedplus' : 'unnamed'
" map c-x and c-v to work as they do in windows, only in insert mode
vm <c-x> "+x
vm <c-c> "+y
cno <c-v> <c-r>+
exe 'ino <script> <C-V>' paste#paste_cmd['i']

" save with ctrl+s
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>


"EXIT VIM WITH NERTREE
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" PLUGINS
" Le plugin est hébergé à https://github.com/itchyny/lightline.vim
Plugin 'itchyny/lightline.vim'
" added nerdtree
Plugin 'scrooloose/nerdtree.git'


" auto start tree
autocmd vimenter * NERDTree
