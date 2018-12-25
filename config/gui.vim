""""""""""""""""""""""""""""""
" => Gui options
""""""""""""""""""""""""""""""
if has('gui_running')
    colorscheme base16-solarized-light
    set nohidden
    set guifont=SF\ Mono\ for\ Powerline:h12
    set guioptions-=T
    set guioptions-=r
    set gcr=n:blinkon0

    " Disable the list of buffers
    let g:airline#extensions#tabline#enabled = 0
    nmap <C-n> :tabnext<CR>
    nmap <C-p> :tabprev<CR>
endif


if exists("g:gui_oni")
  set nohidden
  set noshowmode
  set noruler
  set laststatus=0
  set noshowcmd
  let g:indentLine_enabled = 0
  let g:loaded_airline = 1
"   let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"   set termguicolors
"   colorscheme solarized8_light
endif

" if has("gui_vimr")
" endif
