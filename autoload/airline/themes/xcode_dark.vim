let g:airline#themes#xcode_dark#palette = {}

function! airline#themes#xcode_dark#refresh()
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Options
  """"""""""""""""""""""""""""""""""""""""""""""""
  let s:background           = get(g:, 'airline_solarized_bg', &background)
  let s:ansi_colors          = get(g:, 'solarized_termcolors', 16) != 256 && &t_Co >= 16 ? 1 : 0
  let s:use_green            = get(g:, 'airline_solarized_normal_green', 0)
  let s:dark_text            = get(g:, 'airline_solarized_dark_text', 0)
  let s:dark_inactive_border = get(g:, 'airline_solarized_dark_inactive_border', 0)
  let s:tty                  = &t_Co == 8

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Colors
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Base colors
  " Extended base16 support by @cuviper.
  " Via https://github.com/blueyed/vim-colors-solarized/commit/92f2f994 /
  " https://github.com/cuviper/vim-colors-solarized.
"   if s:ansi_colors && get(g:, 'solarized_base16', 0)
"     let s:base03  = {'t':   8, 'g': "#002b36"}  " Base 00
"     let s:base02  = {'t':  10, 'g': "#073642"}  " Base 01
"     let s:base01  = {'t':   8, 'g': "#586e75"}  " Base 02
"     let s:base00  = {'t':   8, 'g': "#657b83"}  " Base 03
"     let s:base0   = {'t':  12, 'g': "#839496"}  " Base 04
"     let s:base1   = {'t':   7, 'g': "#93a1a1"}  " Base 05
"     let s:base2   = {'t': 255, 'g': "#eee8d5"}  " Base 06
"     let s:base3   = {'t': 255, 'g': "#fdf6e3"}  " Base 07
"     let s:yellow  = {'t':   1, 'g': "#dc322f"}  " Base 0A
"     let s:orange  = {'t':   9, 'g': "#cb4b16"}  " Base 09
"     let s:red     = {'t':   3, 'g': "#b58900"}  " Base 08
"     let s:magenta = {'t':   2, 'g': "#859900"}  " Base 0F
"     let s:violet  = {'t':   6, 'g': "#2aa198"}  " Base 0E
"     let s:blue    = {'t':   4, 'g': "#268bd2"}  " Base 0D
"     let s:cyan    = {'t':  13, 'g': "#6c71c4"}  " Base 0C
"     let s:green   = {'t':   5, 'g': "#d33682"}  " Base 0B
"   else
"     let s:base03  = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 234), 'g': '#002b36'}
"     let s:base02  = {'t': s:ansi_colors ?  10 : (s:tty ? '0' : 235), 'g': '#073642'}
"     let s:base01  = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 240), 'g': '#586e75'}
"     let s:base00  = {'t': s:ansi_colors ?   8 : (s:tty ? '7' : 241), 'g': '#657b83'}
"     let s:base0   = {'t': s:ansi_colors ?  12 : (s:tty ? '7' : 244), 'g': '#839496'}
"     let s:base1   = {'t': s:ansi_colors ?   7 : (s:tty ? '7' : 245), 'g': '#93a1a1'}
"     let s:base2   = {'t': s:ansi_colors ? 255 : (s:tty ? '7' : 254), 'g': '#eee8d5'}
"     let s:base3   = {'t': s:ansi_colors ? 255 : (s:tty ? '7' : 230), 'g': '#fdf6e3'}
"     let s:yellow  = {'t': s:ansi_colors ?   3 : (s:tty ? '3' : 136), 'g': '#b58900'}
"     let s:orange  = {'t': s:ansi_colors ?   9 : (s:tty ? '1' : 166), 'g': '#cb4b16'}
"     let s:red     = {'t': s:ansi_colors ?   1 : (s:tty ? '1' : 160), 'g': '#dc322f'}
"     let s:magenta = {'t': s:ansi_colors ?   5 : (s:tty ? '5' : 125), 'g': '#d33682'}
"     let s:violet  = {'t': s:ansi_colors ?  13 : (s:tty ? '5' : 61 ), 'g': '#6c71c4'}
"     let s:blue    = {'t': s:ansi_colors ?   4 : (s:tty ? '4' : 33 ), 'g': '#268bd2'}
"     let s:cyan    = {'t': s:ansi_colors ?   6 : (s:tty ? '6' : 37 ), 'g': '#2aa198'}
"     let s:green   = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#859900'}
"   endif


  let s:white = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#FFFFFF'}
  let s:red = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#FF0000'}
  let s:selection  = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#626E85'}
  let s:search_background = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#424D5B'}
  let s:comment = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#7D8C9A'}
  let s:preprocessor_statements   = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#FF9F2D'}
  let s:strings = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#FF7763'}
  let s:keyword = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#FF67B0'}

  let s:line_number = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#747479'}
  let s:invisibles = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#646468'}
  let s:other_function_and_metod_names = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#95EFDE'}

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Simple mappings
  " NOTE: These are easily tweakable mappings. The actual mappings get
  " the specific gui and terminal colors from the base color dicts.
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Normal mode
  if s:background == 'dark'
    let s:N1 = [s:white, s:search_background, '']
    let s:N2 = [s:white, s:comment, '']
    let s:N3 = [s:white, s:selection, '']
  else
    let s:N1 = [s:white, s:search_background, '']
    let s:N2 = [s:white, s:comment, '']
    let s:N3 = [s:white, s:selection, '']
  endif
  let s:NF = [s:strings, s:white, '']
  let s:NW = [s:white, s:strings, '']
  if s:background == 'dark'
    let s:NM = [s:keyword, s:N3[1], '']
    let s:NMi = [s:other_function_and_metod_names, s:N3[1], '']
  else
    let s:NM = [s:keyword, s:N3[1], '']
    let s:NMi = [s:other_function_and_metod_names, s:N3[1], '']
  endif

  " Insert mode
  let s:I1 = [s:N1[0], s:preprocessor_statements, 'bold']
  let s:I2 = s:N2
  let s:I3 = s:N3
  let s:IF = s:NF
  let s:IM = s:NM

  " Visual mode
  let s:V1 = [s:N1[0], s:keyword, 'bold']
  let s:V2 = s:N2
  let s:V3 = s:N3
  let s:VF = s:NF
  let s:VM = s:NM

  " Replace mode
  let s:R1 = [s:N1[0], s:red, '']
  let s:R2 = s:N2
  let s:R3 = s:N3
  let s:RM = s:NM
  let s:RF = s:NF

  " Inactive, according to VertSplit in solarized
  " (bg dark: base00; bg light: base0)
  if s:background == 'dark'
    if s:dark_inactive_border
      let s:IA = [s:line_number, s:invisibles, '']
    else
      let s:IA = [s:line_number, s:search_background, '']
    endif
  else
    let s:IA = [s:line_number, s:invisibles, '']
  endif

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Actual mappings
  " WARNING: Don't modify this section unless necessary.
  """"""""""""""""""""""""""""""""""""""""""""""""
  let s:NFa = [s:NF[0].g, s:NF[1].g, s:NF[0].t, s:NF[1].t, s:NF[2]]
  let s:IFa = [s:IF[0].g, s:IF[1].g, s:IF[0].t, s:IF[1].t, s:IF[2]]
  let s:VFa = [s:VF[0].g, s:VF[1].g, s:VF[0].t, s:VF[1].t, s:VF[2]]
  let s:RFa = [s:RF[0].g, s:RF[1].g, s:RF[0].t, s:RF[1].t, s:RF[2]]

  let g:airline#themes#xcode_dark#palette.accents = {
        \ 'red': s:NFa,
        \ }

  let g:airline#themes#xcode_dark#palette.inactive = airline#themes#generate_color_map(
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]])
  let g:airline#themes#xcode_dark#palette.inactive_modified = {
        \ 'airline_c': [s:NMi[0].g, '', s:NMi[0].t, '', s:NMi[2]]}

  let g:airline#themes#xcode_dark#palette.normal = airline#themes#generate_color_map(
        \ [s:N1[0].g, s:N1[1].g, s:N1[0].t, s:N1[1].t, s:N1[2]],
        \ [s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]],
        \ [s:N3[0].g, s:N3[1].g, s:N3[0].t, s:N3[1].t, s:N3[2]])

  let g:airline#themes#xcode_dark#palette.normal.airline_warning = [
        \ s:NW[0].g, s:NW[1].g, s:NW[0].t, s:NW[1].t, s:NW[2]]

  let g:airline#themes#xcode_dark#palette.normal.airline_error = [
        \ s:NW[0].g, s:NW[1].g, s:NW[0].t, s:NW[1].t, s:NW[2]]

  let g:airline#themes#xcode_dark#palette.normal_modified = {
        \ 'airline_c': [s:NM[0].g, s:NM[1].g,
        \ s:NM[0].t, s:NM[1].t, s:NM[2]]}

  let g:airline#themes#xcode_dark#palette.normal_modified.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.insert = airline#themes#generate_color_map(
        \ [s:I1[0].g, s:I1[1].g, s:I1[0].t, s:I1[1].t, s:I1[2]],
        \ [s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]],
        \ [s:I3[0].g, s:I3[1].g, s:I3[0].t, s:I3[1].t, s:I3[2]])

  let g:airline#themes#xcode_dark#palette.insert.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.insert_modified = {
        \ 'airline_c': [s:IM[0].g, s:IM[1].g,
        \ s:IM[0].t, s:IM[1].t, s:IM[2]]}

  let g:airline#themes#xcode_dark#palette.insert_modified.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.visual = airline#themes#generate_color_map(
        \ [s:V1[0].g, s:V1[1].g, s:V1[0].t, s:V1[1].t, s:V1[2]],
        \ [s:V2[0].g, s:V2[1].g, s:V2[0].t, s:V2[1].t, s:V2[2]],
        \ [s:V3[0].g, s:V3[1].g, s:V3[0].t, s:V3[1].t, s:V3[2]])

  let g:airline#themes#xcode_dark#palette.visual.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.visual_modified = {
        \ 'airline_c': [s:VM[0].g, s:VM[1].g,
        \ s:VM[0].t, s:VM[1].t, s:VM[2]]}

  let g:airline#themes#xcode_dark#palette.visual_modified.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.replace = airline#themes#generate_color_map(
        \ [s:R1[0].g, s:R1[1].g, s:R1[0].t, s:R1[1].t, s:R1[2]],
        \ [s:R2[0].g, s:R2[1].g, s:R2[0].t, s:R2[1].t, s:R2[2]],
        \ [s:R3[0].g, s:R3[1].g, s:R3[0].t, s:R3[1].t, s:R3[2]])

  let g:airline#themes#xcode_dark#palette.replace.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.replace_modified = {
        \ 'airline_c': [s:RM[0].g, s:RM[1].g,
        \ s:RM[0].t, s:RM[1].t, s:RM[2]]}

  let g:airline#themes#xcode_dark#palette.replace_modified.airline_warning =
        \ g:airline#themes#xcode_dark#palette.normal.airline_warning

  let g:airline#themes#xcode_dark#palette.tabline = {}

  let g:airline#themes#xcode_dark#palette.tabline.airline_tab = [
        \ s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]]

  let g:airline#themes#xcode_dark#palette.tabline.airline_tabtype = [
        \ s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]]
endfunction

call airline#themes#xcode_dark#refresh()

