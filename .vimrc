" Highlight line
set cursorline

" Search Option
set ignorecase
set smartcase
set hlsearch
set incsearch

" Coloring
" set termguicolors
colorscheme desert
syntax enable

" Tabbing
set expandtab     " Use only space
set tabstop=3     " Width of tabstop
set shiftwidth=3  " Indent width

" Backspace Problem-Workarround
set backspace=indent,eol,start

" Store last cursor position
if has("autocmd")
   au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

" UTF-8 encodig wihthin files
set encoding=utf-8
set termencoding=utf-8
