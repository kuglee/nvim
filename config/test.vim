""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Testing area
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType swift nmap <silent> <buffer> <C-k> :call swift_completer#begin_replacing_placeholder()<CR>
autocmd FileType swift nmap <silent> <buffer> <leader>a :call swift_completer#begin_replacing_placeholder()<CR>
autocmd FileType swift imap <buffer> <C-k> <esc>:call swift_completer#begin_replacing_placeholder()<CR>

" let g:xcode_runner_command = 'Dispatch {cmd}'

map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
