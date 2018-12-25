""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Airline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set laststatus=2
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline_theme="xcode_dark"
let g:airline#extensions#ale#enabled = 1

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'


" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " => Clang Format
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" let g:clang_format#code_style = 'llvm'
" let g:clang_format#style_options = {"Standard": "C++11"}
" 
" autocmd FileType c,cpp,objc ClangFormatAutoEnable
" 
" autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
" nmap <Leader>C :ClangFormatAutoToggle<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Fugitive
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>gd :Gdiff<CR>
nmap <leader>gl :!clear && Git log<CR>
nmap <leader>gc :Gcommit -a<CR>
nmap <leader>gs :Gstatus<CR> 


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => haskell-vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Align 'then' two spaces after 'if'
let g:haskell_indent_if = 4
" Indent 'where' block two spaces under previous body
let g:haskell_indent_before_where = 4
" Allow a second case indent style (see haskell-vim README)
let g:haskell_indent_case_alternative = 1
" Only next under 'let' if there's an equals sign
let g:haskell_indent_let_no_in = 0

let g:ale_linters = {'haskell': ['stack-ghc-mod', 'hlint']}


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => interio-neovim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Prefer starting Intero manually (faster startup times)
let g:intero_start_immediately = 0
" Use ALE (works even when not using Intero)
let g:intero_use_neomake = 0

augroup interoMaps
  au!

  au FileType haskell nnoremap <silent> <leader>io :InteroOpen<CR>
  au FileType haskell nnoremap <silent> <leader>iov :InteroOpen<CR><C-W>H
  au FileType haskell nnoremap <silent> <leader>ih :InteroHide<CR>
  au FileType haskell nnoremap <silent> <leader>is :InteroStart<CR>
  au FileType haskell nnoremap <silent> <leader>ik :InteroKill<CR>

  au FileType haskell nnoremap <silent> <leader>wr :w \| :InteroReload<CR>
  au FileType haskell nnoremap <silent> <leader>il :InteroLoadCurrentModule<CR>
  au FileType haskell nnoremap <silent> <leader>if :InteroLoadCurrentFile<CR>

  au FileType haskell map <leader>t <Plug>InteroGenericType
  au FileType haskell map <leader>T <Plug>InteroType
  au FileType haskell nnoremap <silent> <leader>it :InteroTypeInsert<CR>

  au FileType haskell nnoremap <silent> <leader>jd :InteroGoToDef<CR>
  au FileType haskell nnoremap <silent> <leader>iu :InteroUses<CR>
  au FileType haskell nnoremap <leader>ist :InteroSetTargets<SPACE>
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => indentLine
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_setColors = 0
let g:indentLine_char = '│'
" let g:indentLine_color_term = 10
" let g:indentLine_color_gui = '#eee8d5'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => LanguageClient-neovim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:LanguageClient_serverCommands = {
  \ 'cpp': ['/usr/local/bin/clangd'],
  \ 'swift': ['/usr/local/bin/sourcekit-lsp'],
  \ }


" nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
nnoremap <F5> :call LanguageClient_contextMenu()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ncm2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enable ncm2 for all buffers
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANTE: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect
set shortmess+=c

inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neoformat
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType c,cpp,objc,swift nnoremap <buffer><Leader>nf :<C-u>Neoformat<CR>

fun! NeoFormatAutoToggle()
  let g:neoformat_enabled = !g:neoformat_enabled

  if g:neoformat_enabled
    echo "NeoFormat is enabled."
    return
  endif

    echo "NeoFormat is disabled."
endfun

nnoremap <Leader>N :call NeoFormatAutoToggle()<CR>

fun! FormatWithNeoformat()
    if g:neoformat_enabled == 0
        return
    endif

    Neoformat
endfun

let g:neoformat_only_msg_on_error = 1
let g:neoformat_enabled = 1

" autocmd FileType c,cpp,objc,swift autocmd BufWritePre <buffer> undojoin | call FormatWithNeoformat()
" autocmd FileType c,cpp,objc,swift nnoremap <buffer><Leader>cf undojoin \| Neoformat<CR>
" autocmd FileType c,cpp,objc,swift vnoremap <buffer><Leader>cf undojoin \| Neoformat<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Neomake
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"au BufEnter * let g:neomake_swiftc_maker = {
"       \ 'args': ['-typecheck'] + systemlist("ls " . expand('%:p:h') . "/*.swift"),
"       \ 'append_file': 0,
"       \ 'errorformat':
"         \ '%E%f:%l:%c: error: %m,' .
"         \ '%W%f:%l:%c: warning: %m,' .
"         \ '%Z%\s%#^~%#,' .
"         \ '%-G%.%#',
"      \ }
"
"let g:neomake_swift_enabled_makers = ['swiftc']
"au VimEnter * call neomake#configure#automake('nrwi', 500)
"" au VimEnter * call neomake#configure#automake('w', 500)
"" let g:neomake_logfile = '/tmp/neomake.log'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Neoterm
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neoterm_default_mod = "vertical"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERD Commenter
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'start'
let g:NERDCommentEmptyLines = 1
let NERDCommentWholeLinesInVMode = 1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tabs
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set switchbuf=useopen,usetab,newtab
" let g:ctrlp_prompt_mappings = {
"     \ 'AcceptSelection("e")': ['<c-t>'],
"     \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
"     \ }
" " nmap <F11> :tabnext<cr>
" nmap <C-n> :tabnext<CR>
" nmap <C-p> :tabprev<CR>
