"                    _     _                         _           
"  ___ ___  _ __ ___| |__ (_)_ __   ___  ___  __   _(_)_ __ ___  
" / __/ _ \| '__/ __| '_ \| | '_ \ / _ \/ __| \ \ / / | '_ ` _ \ 
"| (_| (_) | |  \__ \ | | | | | | |  __/\__ \  \ V /| | | | | | |
" \___\___/|_|  |___/_| |_|_|_| |_|\___||___/   \_/ |_|_| |_| |_|
"                                                                
"                  __ _                       _   _             
"  ___ ___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
" / __/ _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
"| (_| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
" \___\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
"                       |___/                                   
"
"Github: https://github.com/xcorshinex


" List of vim-plug pluggin"
call plug#begin('~/.vim/plugged')

" favorite colorscheme
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'



call plug#end()

" relative number
set number relativenumber

" size of a hard tabstop
set tabstop=2

" always uses spaces instead of tab characters
set expandtab

" size of an "indent"
set shiftwidth=2

set cursorline
set showcmd
set mouse=a

" my colorscheme 
syntax on
set background=dark

" config vim lighline status bar 
set laststatus=2

" config vim nerdtree
" toggle nerd tree
map <C-n> :NERDTreeToggle<CR>

" air-line
let g:airline_powerline_fonts = 1
let g:airline_theme='kalisi' 
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" Syntastic syntax checker settings
"  See :help syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Clang_complete settings
let g:clang_library_path='/usr/lib/llvm-8/lib/'

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''



Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
let g:deoplete#enable_at_startup = 1


Plug 'haya14busa/incsearch.vim'      
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'dir': '~/.local/lib/fzf', 'do': './install --all' }
Plug 'majutsushi/tagbar'                 | " Display tags in a window by scope.
Plug 'qpkorr/vim-bufkill'                | " Delete buffer without losing split window
Plug 'tpope/vim-sleuth'                  | " Autodetect file spacing
Plug 'scrooloose/nerdcommenter'          | " Awesome Commenting
Plug 'vim-scripts/autoswap.vim'          | " Handle swap files intelligently
Plug 'tpope/vim-obsession'               | " continuously update session files
Plug 'tpope/vim-fugitive'                | " Git wrapper
Plug 'airblade/vim-rooter'               | " Set working directory to project root
Plug 'tpope/vim-eunuch'                  | " Add unix commands to vim
Plug 'tpope/vim-unimpaired'              | " Bracket mappings
Plug 'samoshkin/vim-mergetool'           | " use vim as mergetool
Plug 'editorconfig/editorconfig-vim'     | " .editorconfig support
Plug 'easymotion/vim-easymotion'         | " Navigate files with ease
Plug 'junegunn/vim-easy-align'           | " Align things
Plug 'SirVer/ultisnips'                  | " Snippets engine
Plug 'honza/vim-snippets'                | " Snippets
Plug 'thosakwe/vim-flutter'              | " Commands for Flutter from vim
Plug 'Shougo/echodoc'                    | " Displays function signatures from completions
Plug 'camspiers/animate.vim'             |   " A Vim Automatic Window Resizing Plugin
Plug 'camspiers/lens.vim'
Plug 'drewtempelmeyer/palenight.vim'     | " Fantastic colors
Plug 'nightsense/cosmic_latte'           | " Theme that's easy on the eyes
Plug 'kjssad/quantum.vim'                | " A modern colorscheme inspired by firefox
Plug 'owickstrom/vim-colors-paramount'   | " V. Dark colorscheme with purple accent
Plug 'rakr/vim-one'                      | " one-dark colorscheme for vim
Plug 'itchyny/lightline.vim'             | " Awesome status bar
Plug 'maximbaz/lightline-ale'            | " ALE indicator for lightline
Plug 'mengelbrecht/lightline-bufferline' | " A buffer plugin for lightline
Plug 'psliwka/vim-smoothie'              | " Smooth scrolling
Plug 'Yggdroot/indentLine'
Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'deoplete-plugins/deoplete-jedi'
let g:deoplete#enable_at_startup = 1
Plug 'haya14busa/incsearch.vim'      
Plug 'haya14busa/incsearch-fuzzy.vim'








