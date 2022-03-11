" Coloring
syntax enable
set background=dark

" Highlight line
set cursorline
hi CursorLine term=bold,underline cterm=bold,underline guibg=Grey40 gui=underline


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
set clipboard=unnamed
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


" Add VIM Plugins

" " Statusline {{{
" set statusline=
" set statusline+=%7*\[%n]                                  "buffernr
" set statusline+=%1*\ %<%F\                                "File+path
" set statusline+=%2*\ %y\                                  "FileType
" set statusline+=%3*\ %{''.(&fenc!=''?&fenc:&enc).''}      "Encoding
" set statusline+=%3*\ %{(&bomb?\",BOM\":\"\")}\            "Encoding2
" set statusline+=%4*\ %{&ff}\                              "FileFormat (dos/unix..)
" set statusline+=%5*\ %{&spelllang}\                       "Spellanguage
" set statusline+=%8*\ %=\ row:%l/%L\ (%03p%%)\             "Rownumber/total (%)
" set statusline+=%9*\ col:%03c\                            "Colnr
" set statusline+=%0*\ \ %m%r%w\ %P\ \                      "Modified? Readonly?  Top/bot.
" " }}}


" UTF-8 encodig wihthin files
set encoding=utf-8
set termencoding=utf-8

" Tabbing between multple windows
map <F7> :bp<CR>
map <F8> :bn<CR>

