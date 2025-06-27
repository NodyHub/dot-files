" Coloring - optimized for Light Tango Theme
syntax enable
syntax on
set background=light

" Color scheme optimization for Tango
if has('termguicolors')
  set termguicolors
endif

" Try to use a colorscheme that works well with Tango if available
try
  colorscheme PaperColor
catch /^Vim\%((\a\+)\)\=:E185/
  " Fallback to default with some Tango-friendly adjustments
endtry

" Highlight current line - adjusted for Light Tango theme
set cursorline
hi CursorLine ctermbg=255 guibg=#f2f2f2 cterm=NONE gui=NONE
hi CursorLineNr ctermfg=32 guifg=#4271ae cterm=bold gui=bold


" Search Option
set incsearch
set hlsearch
set ignorecase

set title
set noautoindent
set ruler
set shortmess=aoOTI
set showmode
set splitbelow
set splitright
set laststatus=2
set nomodeline
set showcmd
set showmatch
set tabstop=3
set shiftwidth=3
set expandtab
set cinoptions=(0,m1,:1
set formatoptions=tcqr2
set laststatus=2
set nomodeline
set clipboard=unnamed,unnamedplus
set softtabstop=3
set showtabline=1
set smartcase
set ignorecase
set sidescroll=2
set scrolloff=4
set ttyfast
set history=10000
set hidden
set number
set backspace=indent,eol,start
set ttimeoutlen=100
set completeopt=noinsert,menuone,noselect " Modifies the auto-complete menu to behave more like an IDE.
set mouse= " Disable mouse in Vim to allow terminal selection
set wildmenu " Show a more advance menu



" Tabbing
set expandtab     " Use only space
set tabstop=2     " Width of tabstop
set shiftwidth=2  " Indent width

" Backspace Problem-Workarround
set backspace=indent,eol,start

" Disable default status line
set noshowmode

" Store last cursor position
if has("autocmd")
   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline
    au WinEnter,InsertLeave * set cursorline
augroup END
" }}}

" Autocompletion rebind {{{
if has("gui_running")
    " C-Space seems to work under gVim on both Linux and win32
    inoremap <C-Space> <C-n>
else " no gui
  if has("unix")
    inoremap <Nul> <C-n>
  else
  " I have no idea of the name of Ctrl-Space elsewhere
  endif
endif
" }}}


" Backups {{{
set backup                        " enable backups
set noswapfile                    " it's 2013, Vim.
set undodir=~/.vim/tmp/undo//     " undo files
set backupdir=~/.vim/tmp/backup// " backups
set directory=~/.vim/tmp/swap//   " swap files
" Make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif
" }}}

" UTF-8 encodig wihthin files
set encoding=utf-8
set termencoding=utf-8

" Custom syntax highlighting for Light Tango theme
hi Normal ctermfg=238 ctermbg=NONE guifg=#444444 guibg=NONE
hi Comment ctermfg=246 guifg=#909090
hi Constant ctermfg=94 guifg=#8f5902
hi Statement ctermfg=25 guifg=#204a87 gui=NONE
hi Identifier ctermfg=31 guifg=#3465a4
hi PreProc ctermfg=91 guifg=#75507b
hi Type ctermfg=28 guifg=#4e9a06 gui=NONE
hi Special ctermfg=160 guifg=#cc0000
hi Search ctermbg=228 ctermfg=NONE guibg=#fcf7bd guifg=NONE
hi MatchParen ctermbg=147 ctermfg=NONE guibg=#a4cdff guifg=NONE
hi Visual ctermbg=153 guibg=#b3d6ff
hi LineNr ctermfg=246 ctermbg=NONE guifg=#909090 guibg=NONE
hi StatusLine ctermfg=231 ctermbg=25 guifg=#ffffff guibg=#204a87
hi StatusLineNC ctermfg=250 ctermbg=240 guifg=#bcbcbc guibg=#585858

" Tabbing between multple windows
map <F7> :bp<CR>
map <F8> :bn<CR>

" Light theme optimizations
if &background == 'light'
  " Fix Vim's popup menu colors to be more readable in light themes
  hi Pmenu ctermbg=253 ctermfg=238 guibg=#dddddd guifg=#444444
  hi PmenuSel ctermbg=25 ctermfg=231 guibg=#204a87 guifg=#ffffff
  hi PmenuSbar ctermbg=250 guibg=#bcbcbc
  hi PmenuThumb ctermbg=240 guibg=#585858
  
  " Fix diff colors for light theme
  hi DiffAdd ctermbg=194 guibg=#d7ffd7
  hi DiffChange ctermbg=223 guibg=#ffd7af
  hi DiffDelete ctermbg=224 ctermfg=224 guibg=#ffd7d7 guifg=#ffd7d7
  hi DiffText ctermbg=222 guibg=#ffd787
endif

" Recommended plugins for better Light Tango experience:
" - PaperColor: colorscheme that works well with light backgrounds
" - vim-gitgutter: for git indicators with light theme suitable colors
" - vim-airline: status line with Tango-compatible themes
" Install with:
" mkdir -p ~/.vim/pack/plugins/start
" git clone https://github.com/NLKNguyen/papercolor-theme.git ~/.vim/pack/plugins/start/papercolor-theme
" git clone https://github.com/airblade/vim-gitgutter.git ~/.vim/pack/plugins/start/vim-gitgutter
" git clone https://github.com/vim-airline/vim-airline.git ~/.vim/pack/plugins/start/vim-airline

" Terminal-friendly mouse settings
" With mouse=, Vim's mouse handling is completely disabled
" allowing the terminal to handle all mouse interactions
" This lets you select and copy text using the terminal's selection mechanism

" Note: When mouse=, these settings below have no effect
" but are kept for reference/documentation

