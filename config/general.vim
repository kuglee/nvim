""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "\<Space>"
syntax enable
filetype plugin on
filetype indent on

" Allow buffer switching without saving
set hidden

" Open split below
set splitbelow
set splitright

" Display the current filename in the termial window title
set title

" Help Neovim check if file has changed on disc
" https://github.com/neovim/neovim/issues/2127
augroup checktime
    autocmd!
    if !has("gui_running")
        "silent! necessary otherwise throws errors when using command
        "line window.
        autocmd BufEnter,FocusGained,BufEnter,FocusLost,WinLeave * checktime
    endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Clipboard
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use X's clipboard
if has('clipboard')
   " When possible use + register for copy-paste
   if has('unnamedplus')
      set clipboard=unnamedplus
   " On mac and Windows, use * register for copy-paste
   else
      set clipboard=unnamed
   endif
endif

" Paste over without overwriting register
function! RestoreRegister()
    let @" = s:restore_reg
    if &clipboard == "unnamedplus"
        let @+ = s:restore_reg
    endif
    return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()

" Change to the dir of the current file
" Like autochdir only better
" autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | silent! lcd %:p:h | endif
" set autochdir

" " Sudo save
" command W w !sudo tee % > /dev/null


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Color theme
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if $TERM_PROGRAM != 'Apple_Terminal'
 set termguicolors
endif

colorscheme xcode_dark
" Allow transparency
hi Normal ctermbg=none

" SignColumn should match background
highlight clear signcolumn
set signcolumn=yes


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
set nobackup
set nowb
set noswapfile


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Show line numbers
set number

" Highlight current line
set cul

" Scroll when reaching edge-5
set scrolloff=10

" Allow normal backspace behavior
set backspace=indent,eol,start

" Allow for cursor beyond last character
set virtualedit=onemore

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" Linebreak on 500 characters
set lbr
set tw=500

"Auto indent
set ai

"Smart indent
set si

" helper for indent mistake
set list listchars=tab:»·,trail:·

"Wrap lines
set wrap

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase

" " Highlight search results
" set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Makes search act like search in modern browsers
set inccommand=split

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Clear search (hightlight)
nmap <silent> <leader>/ :nohlsearch<CR>

" Don't insert comment on new line
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o









""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => compiling and running
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd! BufNewFile,BufReadPre,FileReadPre  *.cpp,*.c,*.hs     so ~/.config/nvim/run.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.html     so ~/.vim/html.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.py     nnoremap <leader>r :silent exec 'T clear;python3 ' . expand("%:p") <cr>
" autocmd! BufNewFile,BufReadPre,FileReadPre  *.py     nnoremap <leader>r :silent exec "! osascript ~/.config/nvim/iterm.scpt 0 1 " . expand("%:p") <cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Errorformats
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Haskell
autocmd FileType haskell set errorformat=
                                \%-Z\ %#,
                                \%W%f:%l:%c:\ Warning:\ %m,
                                \%E%f:%l:%c:\ %m,
                                \%E%>%f:%l:%c:,
                                \%+C\ \ %#%m,
                                \%W%>%f:%l:%c:,
                                \%+C\ \ %#%tarning:\ %m,

" oh, wouldn't you guess it - ghc reports (partially) to stderr..
setlocal shellpipe=2>


" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => Code folding
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" vnoremap <Space> zf
" autocmd BufWinLeave *.* mkview!
" autocmd BufWinEnter *.* silent loadview


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Quickfix window
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Toggles the quickfix window
command! -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
  if exists("g:qfix_win") && a:forced == 0
    cclose
  else
    execute "copen " . 10
  endif
endfunction

" Used to track the quickfix window
augroup QFixToggle
 autocmd!
 autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
 autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END
