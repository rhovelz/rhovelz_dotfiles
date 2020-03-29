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
