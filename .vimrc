set clipboard=unnamed
set clipboard=unnamedplus
set nocompatible               " be iMproved, required
set t_Co=256                   " set terminal 256 color

" Plug {{{
" ----------------------------------------------------------------------------
"
call plug#begin('~/.vim/plugged')
" Theme - Only Dracula
Plug 'dracula/vim', { 'as': 'dracula' }

" File Explorer & UI
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ryanoasis/vim-devicons'
Plug 'Yggdroot/indentLine'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Search & Tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-commentary'
Plug 'idbrii/vim-notgrep'

" Language Support & Intellisense
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'jparise/vim-graphql'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'maxmellon/vim-jsx-pretty'

" Ruby & Rails
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/eruby.vim'
Plug 'tpope/vim-bundler'
Plug 'sunaku/vim-ruby-minitest'

" Utilities
Plug 'ntpeters/vim-better-whitespace'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-ragtag'
Plug 'ervandew/sgmlendtag'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'tpope/vim-liquid'
Plug 'tpope/vim-haml'
Plug 'vim-scripts/restore_view.vim'
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/Vimball'
Plug 'tpope/vim-speeddating'
Plug 'chrisbra/NrrwRgn'
Plug 'vim-scripts/utl.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'lervag/vimtex'

call plug#end()

" ----------------------------------------------------------------------------
"  }}}

syntax enable
filetype plugin indent on
set encoding=UTF-8
set number relativenumber
set wrap " wrap text

" Theme Config
colorscheme dracula

" Editor Settings
set formatoptions=cqt
set infercase
set shiftround
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set conceallevel=0

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Autocmds
autocmd FileType html,javascript,json,css,scss,yaml,tex setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=4 tabstop=4 wrap textwidth=79 formatoptions+=t

set splitbelow splitright
let mapleader = ","
let maplocalleader = ','

" Keybindings
nmap <leader>n :bn<cr>
nmap <leader>p :bp<cr>
nnoremap <leader>d :bp<cr>:bd! #<cr>
nmap <leader><space> :noh<cr>
nmap <leader>W :StripWhitespace<cr>
autocmd BufWritePre * %s/\s\+$//e
imap <C-BS> <C-W>
map <leader>C :w! \| !compiler <c-r>%<CR>
tnoremap <Esc> <C-\><C-n>
nnoremap / /\v
vnoremap / /\v
nnoremap n nzzzv
nnoremap N Nzzzv
imap jj <Esc>
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>
nmap <F12> :NERDTreeToggle<cr>
nmap <C-h> <C-w><C-h>
nmap <C-j> <C-w><C-j>
nmap <C-k> <C-w><C-k>
nmap <C-l> <C-w><C-l>
let NERDTreeShowHidden=1
cmap w!! w !sudo tee % >/dev/null
cmap Q qa
noremap <C-u> <C-u>zz
noremap <C-d> <C-d>zz
nmap <F11> :TagbarToggle<cr>
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap <C-p> :Buffers<cr>
nmap <C-f> :FZF<cr>

" Airline Config
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dracula'

" Python Providers
let g:python_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3.7'

" CoC Settings
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Final Line to prevent E121
" vim: ft=vim fdm=marker
