"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" New line in normal mode
noremap <Enter> o<ESC>
" iTerm -> Keys -> Send [13;2u
noremap <S-Enter> O<ESC>

" Navigate linewraps
map j gj
map k gk
map <DOWN> gj
map <UP> gk

" Normal text editor Tab behavior
nnoremap <Tab> >>
nnoremap <S-Tab> <<
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Toggle quickfix window
" nmap <silent> <C-k> :QFix<CR>

" Jump between errors
map cn <esc>:cn<cr>
map cp <esc>:cp<cr>

" " Buffers
" nmap ; :CtrlPBuffer<CR>
" " nmap <C-e> :e#<CR>
" nmap <C-n> :bnext<CR>
" nmap <C-p> :bprev<CR>

" Disable movement in insert mode
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>

" Movement for Colemak layout
" map <C-h> h
" map <C-n> gj
" map <C-e> gk
" " interferes with Tab key
" map <C-i> l

nmap  <S-k>  <C-u>
nmap  <S-j>  <c-d>
vmap  <S-k>  <C-u>
vmap  <S-j>  <c-d>

set mouse=a
nmap <LeftMouse> <nop>
imap <LeftMouse> <nop>
vmap <LeftMouse> <nop>
" map <ScrollWheelUp> <C-Y>
" map <ScrollWheelDown> <C-E>

" inoremap {      {}<Left>
" inoremap {<CR>  {<CR>}<Esc>O
" inoremap {{     {
" inoremap {}     {}
" 
" inoremap (      ()<Left>
" inoremap (<CR>  (<CR>)<Esc>O
" inoremap ((     (
" inoremap ()     ()
" 
" inoremap [      []<Left>
" inoremap [<CR>  [<CR>]<Esc>O
" inoremap [[     [
" inoremap []     []
