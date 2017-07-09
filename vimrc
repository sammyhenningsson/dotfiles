" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'w0ng/vim-hybrid'
Plug 'scrooloose/syntastic'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'skalnik/vim-vroom'

call plug#end()

" Wrap too long lines
set wrap

" Tabs are 4 characters
set tabstop=4
set softtabstop=4

set pastetoggle=<C-u>
set showmode

" (Auto)indent uses 4 characters
set shiftwidth=4

" spaces instead of tabs
set expandtab

" guess indentation
set autoindent

" Expand the command line using tab
set wildchar=<Tab>

" show line numbers
"set number

" Fold using markers {{{
" like this
" }}}

" enable all features
set nocompatible

" powerful backspaces
set backspace=indent,eol,start

" highlight the searchterms
set hlsearch

" jump to the matches while typing
set incsearch

" ignore case while searching
set ignorecase

" don't wrap words
set textwidth=0

" history
set history=50

" 1000 undo levels
set undolevels=1000

" show partial commands
set showcmd

" show matching braces
set showmatch

" write before hiding a buffer
set autowrite

" auto-detect the filetype
filetype plugin indent on

" syntax highlight
syntax on

"Ignore case
set ic

" Smartcase search. If any character is a Capital, search is case sensitive
set scs

" we use a dark background, don't we?
"set bg=dark

" Always show the menu, insert longest match
set completeopt=menuone,longest

"Open new buffers in a new tab
set switchbuf=usetab,newtab

" Yank, delete, change operations use the "+ register => Ctrl+V outside of vim
set clipboard=unnamedplus

autocmd FileType html setl sw=2 sts=2 et
autocmd FileType ruby set sw=2 sts=2 et
autocmd FileType eruby setl sw=2 sts=2 et

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

autocmd BufEnter * stopinsert

" Disable paste mode when leaving Insert Mode
autocmd InsertLeave * set nopaste

let mapleader = ','
map <leader>p :!ruby -c %<CR>
map <leader>c :s/^/#/<CR>:noh<CR>
map <leader>u :s/^#+//<CR>
map <leader>m :s/^/\/\//<CR>:noh<CR>
map <leader>n :set number!<CR>
map <leader>r :set cursorline!<CR>
nnoremap <leader>l :call g:ToggleColorColumn()<CR>

" Change current direcotry to the same as current file
" set autochdir
" autocmd BufEnter * silent! lcd %:p:h

" make (s/tab)find search recursively 
set path=$PWD/**

"Ctags
set tags+=./.ctags;$HOME
"Open the definition in a new tab
nnoremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"Open the definition in a vertical split
nnoremap <A-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"Map Ctrl m to show full path of the current file
nnoremap <C-m> :echo expand('%:p')<CR>

"Map Ctrl h/l to previous/next tab
map <C-h> :tabp<CR>
map <C-l> :tabn<CR>

exec "set <A-H>=\eh"
exec "set <A-J>=\ej"
exec "set <A-K>=\ek"
exec "set <A-L>=\el"
exec "nmap \eh <A-H>"
exec "nmap \ej <A-J>"
exec "nmap \ek <A-K>"
exec "nmap \el <A-L>"
nmap <A-H> 3b
nmap <A-J> 5j
nmap <A-K> 5k
nmap <A-L> 3w

"" in visual mode, select text and type // to search for that selection
vnoremap // y/<C-R>"<CR>

cmap w!! w !sudo tee > /dev/null %

function! g:ToggleColorColumn()
  if &l:colorcolumn != ''
    let &l:colorcolumn=''
  else
    let &l:colorcolumn=col('.')
  endif
endfunction

nnoremap <leader>l :call g:ToggleColorColumn()<CR>

" Make sure highlight search foreground color is displayable on Yellow
highlight Search term=reverse ctermbg=11 ctermfg=Black guibg=Yellow
