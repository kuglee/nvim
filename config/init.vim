let g:python3_host_prog = '/usr/local/bin/python3'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => minpac
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

" Airline
call minpac#add('vim-airline/vim-airline')
" call minpac#add('vim-airline/vim-airline-themes')

" Clang
call minpac#add('autozimu/LanguageClient-neovim', {
      \ 'branch': 'next', 'do': 'silent !bash install.sh'
      \ })

" Code completion
call minpac#add('ncm2/ncm2')
call minpac#add('roxma/nvim-yarp') " ncm2 dependency

" Formatting
call minpac#add('sbdchd/neoformat')
call minpac#add('Yggdroot/indentLine')

" Git
call minpac#add('tpope/vim-fugitive')

" Haskell
call minpac#add('neovimhaskell/haskell-vim')
call minpac#add('parsonsmatt/intero-neovim')
call minpac#add('alx741/vim-hindent')

" Swift
" call minpac#add('benekastah/neomake')
" call minpac#add('dafufer/nvim-cm-swift-completer')
" call minpac#add('keith/swift.vim')
" call minpac#add('tpope/vim-dispatch')
" call minpac#add('gfontenot/vim-xcode') " custom
" call minpac#add('jerrymarino/xcodebuild.vim')
call minpac#add('bumaociyuan/vim-swift') "Apple Official swift vim plugin mirror

" Terminal
call minpac#add('kassio/neoterm')

" Text manipulation
call minpac#add('jiangmiao/auto-pairs')
call minpac#add('scrooloose/nerdcommenter')
