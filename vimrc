set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

runtime macros/matchit.vim

Bundle 'vim-ruby/vim-ruby'
Bundle 'tomtom/tcomment_vim' 
Bundle 'kchmck/vim-coffee-script' 
Bundle 'scrooloose/nerdtree' 
Bundle 'tpope/vim-haml' 
Bundle 'nono/vim-handlebars' 
Bundle 'bronson/vim-trailing-whitespace' 
"Bundle 'wincent/Command-T' 
Bundle 'mileszs/ack.vim' 
Bundle 'vimwiki/vimwiki' 
Bundle 'benmills/vimux' 
Bundle 'Blackrush/vim-gocode' 
Bundle 'dgryski/vim-godef' 
"Bundle 'scrooloose/syntastic' 

Bundle 'tpope/vim-bundler' 
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'altercation/vim-colors-solarized.git'
Bundle 'ecomba/vim-ruby-refactoring'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-classpath'
Bundle 'guns/vim-clojure-static'
Bundle 'guns/vim-sexp'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'Shutnik/jshint2.vim'
Bundle 'vim-scripts/Align'
Bundle 'vim-scripts/SQLUtilities'
Bundle 'terryma/vim-multiple-cursors'

Bundle 'pangloss/vim-javascript'
Bundle 'mxw/vim-jsx'

Bundle 'Shougo/vimproc.vim'
Bundle 'Shougo/unite.vim'


vnoremap . :norm.<CR>
syntax on
filetype plugin indent on
set noswapfile
set hidden
set autoread
"set mouse=a

set ts=2
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
"set number
"set relativenumber
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
""set cursorline
set cmdheight=1
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
" This makes RVM work inside Vim. I have no idea why.
set shell=zsh
let mapleader=","
let maplocalleader="\\"
nnoremap <leader><leader> <c-^>

augroup filetypedetect
  au! BufRead,BufNewFile *nc setfiletype nc
augroup END
noremap <silent> <F11> :cal VimCommanderToggle()<CR>

" status line customization ---------------------- {{{
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 10
let g:Powerline_symbols = 'fancy'
set laststatus=2
" }}}

set ai
set si
set t_Co=256 " 256 colors
set background=dark
let g:solarized_termcolors=256
colorscheme solarized


" open files in directories of current file
cnoremap %% <C-R>=expand('%-h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
" Clear all autocmds in the group
autocmd!
autocmd FileType text setlocal textwidth=78
" Jump to last cursor position unless it's invalid or in an event handler
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

"for ruby, autoindent with two spaces, always expand tabs
autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
autocmd FileType python set sw=4 sts=4 et

autocmd! BufRead,BufNewFile *.sass setfiletype sass 

autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

" Indent p tags

" Don't syntax highlight markdown because it's often wrong
autocmd! FileType mkd setlocal syn=off

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)



" global mappings ---------------------- {{{

inoremap jk <Esc>

" nerdtree
nnoremap <silent> <F9> :NERDTree<CR>

" remove search highlight
nnoremap <CR> :nohlsearch<cr>
" move lines
nnoremap - ddp
nnoremap _ ddkP
" uppercase word
inoremap <c-u> <esc>vawUea
nnoremap <c-u> <esc>vawU

" edit vim rc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"abbreviations as spell correct
iabbrev lenght length

" surround in quotes TODO remove
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
vnoremap <leader>" <esc>`<i"<esc>`>la"<esc>

nnoremap H 0
nnoremap L $
nnoremap K <silent>

" adding movements
" inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>
" inside last parens
onoremap il( :<c-u>normal! F)vi(<cr>

" Vimwiki keys
nnoremap <leader>wd :VimwikiDiaryIndex<cr>
augroup my_vimwiki
  autocmd!
  " mark task as done
  autocmd BufNewFile,BufRead *.wiki nnoremap <leader>wm ^i_<esc>A_<esc>0
  " unmark task
  autocmd BufNewFile,BufRead *.wiki nnoremap <leader>wu 0x$x0
augroup END

"vimux mappings
nnoremap <leader>rc :VimuxPromptCommand<cr>
nnoremap <leader>rl :RunLastVimTmuxCommand<cr>
" }}}

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}


" inspect a gem
command! -nargs=* -complete=custom,ListGems BundleOpen silent execute "!bundle open <args>"

" Shortcut mapping.
nmap <leader>o :BundleOpen

" SOURCE a local vimfile
if filereadable(glob(".vimrc.local"))
      source .vimrc.local
endif

set pastetoggle=<leader>y

nnoremap  <leader>t :tabnew<cr>
nnoremap  <leader>s :vs<cr>
nnoremap  <leader>w :sv<cr>

function! s:ChangeHashSyntax(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/:\([a-z0-9_]\+\)\s\+=>/\1:/g'
    call setpos('.', l:save_cursor)
endfunction

command! -range=% ChangeHashSyntax call <SID>ChangeHashSyntax(<line1>,<line2>)

set wildignore+=*.o,*.obj,.git,node_modules

"au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" UNITE VIM
let g:unite_source_history_yank_enable = 1
nnoremap <leader>f :Unite -no-split -buffer-name=files -start-insert file_rec/async<cr>
nnoremap <leader>/ :Unite grep:.<cr>
nnoremap <leader>s :Unite -no-split -quick-match buffer<cr>
nnoremap <leader>y :Unite history/yank<cr>
