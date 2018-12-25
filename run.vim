func! RunApplescript(COMMAND)
    if has('gui_running')
        let s:hasGUI=1
    else
        let s:hasGUI=0
    endif
    silent exec "! osascript ~/.config/nvim/iterm.scpt " . shellescape(s:hasGUI) . " 1 " . shellescape(a:COMMAND)
    redraw!
endfunction

func! Compile()
    silent :w
    silent !clear
    if filereadable(expand("%:p:h") . "/makefile")
        silent make
        let s:MAKE=1
    else
        "     silent exec "!gcc % -o %<"
        setlocal makeprg=g++\ %\ -o\ %<
        silent make
        let s:MAKE=0
    endif
    return s:MAKE
endfunc

func! Run(MAKE, disp)
    if len(getqflist()) == 0
        let s:PWD=expand("%:p:h:t")
        if a:MAKE == 1
            let s:TARGET="make run -C" . " " . expand("%:p:h")
"             let s:TARGET=expand("%:p:h") . "/" . expand("%:p:h:t")
        else
            let s:TARGET=expand("%:p:h") . "/" . expand("%<")
        endif
        if a:disp == "tmux"
            silent exec "!tmux kill-window -a"
            call VimuxRunCommand("clear;" . s:TARGET)
        elseif a:disp == "applescript"
            call RunApplescript("clear;" . s:TARGET)
        elseif a:disp == "neovim"
"             silent exec 'term clear; ' . s:TARGET
            silent exec 'T clear;' . s:TARGET
        else
            silent exec "!" . s:TARGET . " \&"
        endif
    else
        cw
    endif
endfunc

" func! Run(MAKE, disp)
"     if len(getqflist()) == 0
"         if a:MAKE == 1
"         if a:disp == "tmux"
"             silent exec "!tmux kill-window -a"
"             call VimuxRunCommand("clear; make run")
"         elseif a:disp == "applescript"
"             call RunApplescript("clear; make run")
"         else
"             silent exec "!" . "make run " . " \&"
"         endif
"     else
"         cw
"     endif
" endfunc

" map <F3> :call CompileRun()<CR>
map <D-r> :call CompileRun()<CR>
func! CompileRun()
    let s:MAKE=Compile()
    call Run(s:MAKE, "")
    redraw! " tmux needs it
endfunc

" map <F4> :call CompileRunDisp()<CR>
" map <T-r> :call CompileRunDisp()<CR>
map <leader>r :call CompileRunDisp()<CR>
func! CompileRunDisp()
    let s:MAKE=Compile()
"     if has('gui_running')
"         call Run(s:MAKE, "iterm")
"     else
"         "     call Run(s:MAKE, "tmux")
"         call Run(s:MAKE, "applescript")
"         redraw!
"     endif
"     call Run(s:MAKE, "neovim")
    call Run(s:MAKE, "applescript")
endfunc
