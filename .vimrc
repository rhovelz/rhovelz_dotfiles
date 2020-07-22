set clipboard=unnamed
set clipboard=unnamedplus
set nocompatible               " be iMproved, required
set t_Co=256                   " set terminal 256 color

" Plug {{{
" ----------------------------------------------------------------------------
"
call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'mattn/emmet-vim'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'jparise/vim-graphql'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-ragtag'
Plug 'majutsushi/tagbar'
Plug 'tpope/vim-commentary'
Plug 'ervandew/sgmlendtag'
"Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-liquid'
Plug 'neoclide/coc.nvim', {'do': './install.sh'}
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
Plug 'tpope/vim-rails'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/eruby.vim'
Plug 'tpope/vim-bundler'
Plug 'Yggdroot/indentLine'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'tpope/vim-haml'
Plug 'flazz/vim-colorschemes'
Plug 'vim-scripts/restore_view.vim'
Plug 'jceb/vim-orgmode'
Plug 'vim-scripts/Vimball'
Plug 'tpope/vim-speeddating'
Plug 'chrisbra/NrrwRgn'
Plug 'vim-scripts/utl.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'idbrii/vim-notgrep'
Plug 'sunaku/vim-ruby-minitest'
Plug 'lervag/vimtex'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'kaicataldo/material.vim'






call plug#end()


" ----------------------------------------------------------------------------
"  }}}
"
syntax enable
filetype plugin indent on
set encoding=UTF-8
set number relativenumber
set wrap " wrap text


"set textwidth=80 " to 80 characters
set formatoptions=cqt " see :help fo-table
set infercase " case inferred by default
set shiftround " round the indent to shiftwidth (when at 3 spaces, and I hit > go to 4, n    ot 5)
set expandtab " no real tabs please!
set shiftwidth=4 " auto-indent amount when using >> <<
set softtabstop=4 " when hitting tab or backspace, how many spaces should a tab be (see e    xpandtab)
set tabstop=4 " real tabs should be 4, and they will show with set list on
set autoindent
"set smartindent
set conceallevel=0
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$' " Highlight VCS conflict markers"
autocmd FileType html setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType json setlocal shiftwidth=2 tabstop=2
autocmd FileType htmldjango setlocal shiftwidth=2 tabstop=2 ft=jinja
autocmd FileType html.django setlocal shiftwidth=2 tabstop=2 ft=jinja
autocmd FileType jinja.html setlocal shiftwidth=2 tabstop=2 ft=jinja
autocmd FileType jinja setlocal shiftwidth=2 tabstop=2
autocmd FileType css setlocal shiftwidth=2 tabstop=2
autocmd FileType scss setlocal shiftwidth=2 tabstop=2
autocmd FileType org setlocal shiftwidth=2 tabstop=2 foldmethod=expr nowrap
autocmd FileType python setlocal shiftwidth=4 tabstop=4 wrap textwidth=79 formatoptions+=t
autocmd FileType markdown setlocal shiftwidth=2 tabstop=2 conceallevel=0
autocmd FileType liquid setlocal shiftwidth=2 tabstop=2 conceallevel=0
autocmd FileType vim setlocal shiftwidth=2 tabstop=2 conceallevel=0
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 conceallevel=0
autocmd FileType tex setlocal shiftwidth=2 tabstop=2 conceallevel=0
au BufRead,BufNewFile *.tex setlocal ft=tex
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
set splitbelow splitright
let mapleader = ","
let maplocalleader = ','

"nmap <leader>ev :e ~/.vimrc<cr>
"nmap <leader>ed :e ~/dex/bandithijo.com/_drafts/2018-01-01-format-penulisan-post.md<cr>
"nmap <leader>eu :e ~/.vim/plugged/utl.vim/plugin/utl_rc.vim<cr>
"nmap <leader>eo :e ~/.vim/plugged/vim-orgmode/doc/orgguide.txt<cr>
"nmap <leader>es :so $MYVIMRC

nmap <leader>n :bn<cr>
nmap <leader>p :bp<cr>
nnoremap <leader>d :bp<cr>:bd! #<cr>

nmap <leader><space> :noh<cr>

nmap <leader><space> :nohlsearch<cr>

nmap <leader>g <C-]>

nmap <leader>W :StripWhitespace<cr>

autocmd BufWritePre * %s/\s\+$//e

imap <C-BS> <C-W>

"autocmd BufWritePost ~/.Xresources,~/.Xdefaults !xrdb %

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


nmap <F9> :PymodeLintToggle<cr>


nmap <C-p> :Buffers<cr>
nmap <C-f> :FZF<cr>
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

nnoremap <C-W>s Hmx`` \|:split<CR>`xzt``


" Vim-Airline {{{
"let g:airline_powerline_fonts = 1

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#whitespace#enabled = 0
"let g:airline#extensions#tmuxline#enabled = 0

" Vim-Airline-Theme
"let g:airline_theme='hybridline'
let g:airline_theme='dracula'

let s:saved_theme = []
let g:airline_theme_patch_func = 'AirlineThemePatch'
function! AirlineThemePatch(palette)
  for colors in values(a:palette)
    if has_key(colors, 'airline_c') && len(s:saved_theme) ==# 0
      let s:saved_theme = colors.airline_c
    endif
    if has_key(colors, 'airline_term')
      let colors.airline_term = s:saved_theme
    endif
  endfor
endfunction




" Rubycomplete {{{
let g:rubycomplete_rails=1
let g:rubycomplete_classes_in_global=1
let g:rubycomplete_buffer_loading=1
let g:rubycomplete_include_object=1
let g:rubycomplete_include_objectspace=1

set grepprg=ag
let g:grep_cmd_opts = '--line-numbers --noheading'
" ----------------------------------------------------------------------------

" pylint {{{
" ----------------------------------------------------------------------------
let g:syntastic_python_checkers = ['pylint']  "" or ['flake8', 'pylint'], etc
let g:syntastic_python_pylint_args = '-E'
"" to show it accepts a string of args, also:
" let g:syntastic_python_pylint_args = '--rcfile=/path/to/rc -E'
" ----------------------------------------------------------------------------
" }}}

" markdown-preview {{{
" ----------------------------------------------------------------------------
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0

" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1

" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0

" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0

" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0

" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''

" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''

" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0

" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {}
    \ }

let g:mkdp_markdown_css = ''
let g:mkdp_highlight_css = ''
let g:mkdp_port = ''

let g:mkdp_page_title = '?${name}?'
" ----------------------------------------------------------------------------
" }}}

" FZF {{{
" ----------------------------------------------------------------------------
" Default fzf layout
" - down / up / left / right
"let g:fzf_layout = { 'down': '~50%' }
" Required:
" - width [float]
" - height [float]
"let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" Optional:
" - highlight [string default 'Comment']: Highlight group for border
" - rounded [boolean default v:true]: Use rounded border
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8, 'highlight': 'Normal', 'rounded': v:false } }

" In Neovim, you can set up fzf window using a Vim command
"let g:fzf_layout = { 'window': 'enew' }
"let g:fzf_layout = { 'window': '-tabnew' }
"let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
\   'bg':      ['bg', 'Normal'],
\   'hl':      ['fg', 'Comment'],
\   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\   'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\   'hl+':     ['fg', 'Statement'],
\   'info':    ['fg', 'PreProc'],
\   'border':  ['fg', 'Ignore'],
\   'prompt':  ['fg', 'Conditional'],
\   'pointer': ['fg', 'Exception'],
\   'marker':  ['fg', 'Keyword'],
\   'spinner': ['fg', 'Label'],
\   'header':  ['fg', 'Comment'] }

" let g:fzf_colors =
" \ { 'fg':         ['fg', 'Normal'],
" \   'bg':         ['bg', 'Normal'],
" \   'preview-fg': ['bg', 'Normal'],
" \   'preview-bg': ['bg', 'Normal'],
" \   'hl':         ['fg', 'Search'],
" \   'fg+':        ['bg', 'Search'],
" \   'bg+':        ['fg', 'Search'],
" \   'hl+':        ['bg', 'CursorLine'],
" \   'info':       ['fg', 'Search'],
" \   'border':     ['fg', 'Normal'],
" \   'prompt':     ['fg', 'Search'],
" \   'pointer':    ['fg', 'Search'],
" \   'marker':     ['fg', 'Search'],
" \   'spinner':    ['fg', 'Search'],
" \   'header':     ['fg', 'Search'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
"let g:fzf_history_dir = '~/.local/share/fzf-history'

" Custom statusline
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=0 ctermbg=15
  highlight fzf2 ctermfg=0 ctermbg=15
  highlight fzf3 ctermfg=0 ctermbg=15
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

" preview
"let  $FZF_DEFAULT_OPTS='--reverse --margin=1,1 --preview-window=right:50% --preview="bat --style=plain --color=never {}"'
"let  $FZF_DEFAULT_OPTS='--margin=1,1 --preview-window=right:50% --preview="less {}"'
" ----------------------------------------------------------------------------
" }}}

" Python-Mode {{{
" ----------------------------------------------------------------------------
"let g:pymode_python = 'python3'
"let g:pymode_rope = 0
"let g:pymode_rope_lookup_project = 0
"let g:pymode_rope_complete_on_dot = 0
"let g:pymode_rope_autoimport = 0
let g:python_host_prog = '/usr/local/bin/python2.7'
let g:python3_host_prog = '/usr/local/bin/python3.7'
" linter syntax checker : pylint, pycodestyle, pyflakes, pep8, flake8
"let g:pymode_lint_checkers = ['pylint']
" ----------------------------------------------------------------------------
" }}}

" pgsql {{{
" ----------------------------------------------------------------------------
let g:sql_type_default = 'pgsql'
" ----------------------------------------------------------------------------
" }}}

" LanguageTool {{{
" ----------------------------------------------------------------------------
let g:languagetool_jar='/home/bandithijo/app/LanguageTool/LanguageTool-4.6/languagetool-commandline.jar'
" ----------------------------------------------------------------------------
" }}}

" CoC {{{
" ----------------------------------------------------------------------------
" Enable if want to install the extensions
" let g:coc_global_extensions = [
"             \ 'coc-yank', 'coc-vimlsp', 'coc-ultisnips', 'coc-snippets',
"             \ 'coc-lists', 'coc-highlight', 'coc-git', 'coc-emmet',
"             \ 'coc-yaml', 'coc-tsserver', 'coc-svg', 'coc-solargraph',
"             \ 'coc-rls', 'coc-python', 'coc-phpls', 'coc-json', 'coc-java',
"             \ 'coc-html', 'coc-css', 'coc-angular']

let g:coc_force_debug = 1
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" ----------------------------------------------------------------------------
" }}}

" indentLine {{{
" ----------------------------------------------------------------------------
let g:indentLine_color_term = 10
"let g:indentLine_char = '?'
let g:indentLine_fileTypeExclude = [
           \ '', 'markdown', 'json', 'liquid', 'org', 'conf', 'tex']
let g:indentLine_leadingSpaceEnabled = 0
"let g:indentLine_leadingSpaceChar = '?'
" ----------------------------------------------------------------------------
" }}}

" vim-gitgutter {{{
" ----------------------------------------------------------------------------
let g:gitgutter_async = 1
"let g:gitgutter_realtime = 1
"let g:gitgutter_eager = 1
" ----------------------------------------------------------------------------
" }}}

" vim-commentary {{{
" ----------------------------------------------------------------------------
autocmd FileType desktop setlocal commentstring=#\ %s
autocmd FileType vim setlocal commentstring=\"\ %s
" ----------------------------------------------------------------------------
" }}}

" restore_view {{{
" ----------------------------------------------------------------------------
set viewoptions=cursor,folds,slash,unix
" let g:skipview_files = ['*\.vim']

" ----------------------------------------------------------------------------
" }}}

" vim-orgmode {{{
" ----------------------------------------------------------------------------
let g:org_indent = 1
let g:org_aggressive_conceal = 0
let g:org_heading_highlight_colors = ['Title', 'Constant', 'Identifier',
            \   'Statement', 'PreProc', 'Type', 'Special']
let g:org_heading_highlight_levels = len(g:org_heading_highlight_colors)
let g:org_heading_shade_leading_stars = 1

let g:org_todo_keywords = [
            \ ['TODO(t)', 'WAITING(w)', 'DONE(d)'],
            \ ['REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)', 'FIXED(f)'],
            \ ['CANCELED(c)']]
let g:org_todo_keyword_faces = [
            \ ['WAITING', [':foreground 3']], ['DONE', [':foreground 2']],
            \ ['REPORT', [':foreground 3']],
            \ ['BUG', [':foreground 3']],
            \ ['KNOWNCAUSE', [':foreground 3']],
            \ ['FIXED', [':foreground 2']],
            \ ['CANCELED', [':foreground red']]]
" ----------------------------------------------------------------------------
" }}}

" vim-table-mode {{{
" ----------------------------------------------------------------------------
" To start using the plugin in the on-the-fly mode use :TableModeToggle
" mapped to <Leader>tm by default (which means \ t m if you didn't override
" the by :let mapleader = ',' to have , t m).

" Corner separators are adjustable:
" For Markdown-compatible tables use
"let g:table_mode_corner='|'
" To get ReST-compatible tables use
"let g:table_mode_corner_corner='+'
"let g:table_mode_header_fillchar='='

" Tip : You can use the following to quickly enable / disable table mode
" in insert mode by using || or __ :
function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'
" ----------------------------------------------------------------------------
" }}}

" vimtex {{{
" ----------------------------------------------------------------------------
" Default keybindings: https://github.com/lervag/vimtex/wiki/usage
" https://github.com/lervag/vimtex/wiki/introduction
let g:vimtex_compiler_progname='nvr'

let g:vimtex_latexmk_enabled=1
let g:vimtex_latexmk_continuous=1

let g:vimtex_compiler_latexmk = {
        \ 'executable' : 'latexmk',
        \ 'options' : [
        \   '-xelatex',
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=nonstopmode',
        \ ],
        \}

let g:vimtex_quickfix_mode=2
let g:vimtex_quickfix_open_on_warning=0

let g:vimtex_quickfix_autoclose_after_keystrokes=1

let g:vimtex_quickfix_latexlog = {
      \ 'default'       : 1,
      \ 'general'       : 1,
      \ 'references'    : 1,
      \ 'overfull'      : 1,
      \ 'underfull'     : 1,
      \ 'font'          : 1,
      \ 'packages' : {
      \   'default'     : 1,
      \   'general'     : 1,
      \   'babel'       : 1,
      \   'biblatex'    : 1,
      \   'fixltx2e'    : 1,
      \   'hyperref'    : 1,
      \   'natbib'      : 1,
      \   'scrreprt'    : 1,
      \   'titlesec'    : 1,
      \ },
      \}
" ----------------------------------------------------------------------------
" }}}


" }}}
" ---------------------------------------------------------------------------

" vim: ft=vim fdm=marker
