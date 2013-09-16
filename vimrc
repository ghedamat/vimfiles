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
Bundle 'Townk/vim-autoclose' 
Bundle 'bronson/vim-trailing-whitespace' 
Bundle 'wincent/Command-T' 
Bundle 'Lokaltog/vim-powerline' 
Bundle 'mileszs/ack.vim' 
"Bundle 'ecomba/vim-ruby-refactoring' 
Bundle 'vimwiki/vimwiki' 
Bundle 'benmills/vimux' 
Bundle 'ervandew/screen' 
Bundle 'vim-scripts/ZoomWin' 
Bundle 'Blackrush/vim-gocode' 
Bundle 'maxbrunsfeld/vim-yankstack' 
Bundle 'dgryski/vim-godef' 
Bundle 'scrooloose/syntastic' 
Bundle 'tpope/vim-fugitive' 
Bundle 'tpope/vim-bundler' 
Bundle 'tpope/vim-unimpaired' 
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-rails'
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'

vnoremap . :norm.<CR>
syntax on
filetype plugin indent on
set noswapfile
"set mouse=a

set ts=2
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set number
"set relativenumber
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
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
colorscheme solarized


" open files in directories of current file
cnoremap %% <C-R>=expand('%-h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" Gary Bernhardt stuff ---------------------- {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some stuff from Gary Bernhardt follows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>



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
  autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
":map <leader>p :PromoteToLet<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . _ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
nnoremap <leader>gR :call ShowRoutes()<cr>
nnoremap <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
nnoremap <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
nnoremap <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
nnoremap <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
nnoremap <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
nnoremap <leader>gp :CommandTFlush<cr>\|:CommandT app/assets<cr>
nnoremap <leader>gs :CommandTFlush<cr>\|:CommandT app/assets/stylesheets/sass<cr>
nnoremap <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
nnoremap <leader>gg :topleft 100 :split Gemfile<cr>
nnoremap <leader>gt :CommandTFlush<cr>\|:CommandTTag<cr>
nnoremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" }}}

" vimClojure ---------------------- {{{
let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#ParenRainbow = 1
" this should only be necessary if you don't have the ng client in your PATH
let vimclojure#NailgunClient = "/home/tha/bin/ng"
let vimclojure#WantNailgun = 1""
" }}}

""""""""""""""""""
" experimentation
""""""""""""""""""
" delete till dtCHAR
" delete find dfCHAR
" delete inside diCHAR
" delete around daCHAR
" delete around paragraph dap
" surround.vim!!

" Ember mappings ---------------------- {{{
" promote to @get
nnoremap <leader>p "zdwa@get('<esc>"zpa')<esc>
" }}}

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
nnoremap 0 <silent>
nnoremap $ <silent>
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

" autocmd experiments ---------------------- {{{
" auto indent html files

"augroup my_filetype_html
"  autocmd!
"  autocmd BufWritePre *.html :normal gg=G
"  autocmd BufNewFile,BufRead *.html setlocal nowrap
"augroup END

" comments! (mmm)
augroup my_comments
  "autocmd!
  "autocmd FileType javascript nnoremap <buffer> <localleader>c I//
  "autocmd FileType ruby     nnoremap <buffer> <localleader>c I#
augroup END

augroup my_markdown
  autocmd!
  autocmd BufNewFile,BufRead *.md onoremap ih :<c-u>execute "normal! ?^==\\+$\r:nohlsearch\rkvg_"<cr>
  autocmd BufNewFile,BufRead *.md onoremap ah :<c-u>execute "normal! ?^==\\+\r:nohlsearch\rg_vk0"<cr>k
augroup END
" }}}

" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}


let g:ScreenImpl = 'Tmux'
let g:ScreenShellTmuxInitArgs = '-2'
let g:ScreenShellInitialFocus = 'shell'
let g:ScreenShellQuitOnVimExit = 0
map <F5> :ScreenShellVertical<CR>

" rails stuff from
" http://velvetpulse.com/2012/11/19/improve-your-ruby-workflow-by-integrating-vim-tmux-pry/
"command -nargs=? -complete=shellcmd W  :w | :call ScreenShellSend("load '".@%."';")
"map <Leader>c :ScreenShellVertical bundle exec rails c<CR>
"map <Leader>r :w<CR> :call ScreenShellSend("rspec ".@% . ':' . line('.'))<CR>
"map <Leader>e :w<CR> :call ScreenShellSend("cucumber --format=pretty ".@% . ':' . line('.'))<CR>
"map <Leader>b :w<CR> :call ScreenShellSend("break ".@% . ':' . line('.'))<CR>
"
"


" SEND CURRENT SELECTION TO SCREEN SHELL
vnoremap <leader>" <esc>`<i"<esc>`>la"<esc>
vnoremap <leader>s "ky :call ScreenShellSend("<c-r>k")<cr>


" inspect a gem
command! -nargs=* -complete=custom,ListGems BundleOpen silent execute "!bundle open <args>"

" The function used to produce the autocomplete results.
fun! ListGems(A,L,P)
  " Note that vim will filter for us... no need to do anything with A args.
  return system("grep -s '^ ' Gemfile.lock | sed 's/^ *//' | cut -d ' '  -f1 | sed 's/!//' | sort | uniq")
endfun

" Shortcut mapping.
nmap <leader>o :BundleOpen

" ack search current word in project
nnoremap <leader>a "ayw:Ack <C-R>a
vnoremap <leader>a "ay:Ack <C-R>a

" SOURCE a local vimfile
if filereadable(glob(".vimrc.local"))
      source .vimrc.local
endif


" YankStack plugin
nmap <c-P> <Plug>yankstack_substitute_older_paste
nmap <c-p> <Plug>yankstack_substitute_newer_paste

set pastetoggle=<leader>y

"nnoremap <leader>y :set paste<cr>
"nnoremap <leader>y :set <cr>

