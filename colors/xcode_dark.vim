set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "Xcode_Dark"

let s:black = "000000"
let s:red = "FF0000"
let s:yellow = "FFFF00"
let s:white = "FFFFFF"

let s:background = "292A31"
let s:current_line = "2F323A"
let s:selection = "626E85"
let s:invisibles = "424D5B"
let s:sign_column = "192224"
let s:line_number = "747479"
let s:search_background = "646468"

let s:comment = "7D8C9A"
" let s:documentation_markup = "7D8C9A"
" let s:documentation_markup_keywords = "A0B0C0"
let s:strings = "FF7763"
let s:characters = "AD93FD"
let s:numbers = "AD92FD"
let s:keywords = "FF67B0"
let s:preprocessor_statements = "FF9F2D"
" let s:urls = "4FB2FF"
" let s:attributes = "75C3A2"
" let s:project_class_names = "8DE06A"
" let s:project_function_and_method_names = "A8FA85"
" let s:project_constants = "A8FA85"
" let s:project_type_names = "8DE06A"
" let s:project_instance_variables_and_globals = "8DE06A"
" let s:project_prepocessor_macros = "FF9F2E"
" let s:other_class_names = "76D4C4"
let s:other_function_and_metod_names = "95EFDE"
" let s:other_constants = "95EFDE"
let s:other_type_names = "75D5C4"
" let s:other_instance_variables_and_globals = "76D4C4"
" let s:other_preprocessor_macros = "FF9F2E"






let s:cterm_black = "00"
let s:cterm_background = "08"

let s:cterm_red = "01"
let s:cterm_strings = "09"

let s:cterm_sign_column = "02"
let s:cterm_current_line = "10"

let s:cterm_yellow = "03"
let s:cterm_line_number = "11"
let s:cterm_search_background = "11"


let s:cterm_characters = "04"
let s:cterm_numbers = "04"
let s:cterm_selection = "12"

let s:cterm_keywords = "05"
let s:cterm_preprocessor_statements = "13"

let s:cterm_other_function_and_metod_names = "06"
let s:cterm_invisibles = "14"

let s:cterm_comment = "07"
let s:cterm_white = "15"

let s:cterm_other_type_names = "15"








	
	









" Highlighting function
function! g:Base16hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  if a:guifg != ""
    exec "hi " . a:group . " guifg=#" . a:guifg
  endif
  if a:guibg != ""
    exec "hi " . a:group . " guibg=#" . a:guibg
  endif
  if a:ctermfg != ""
    exec "hi " . a:group . " ctermfg=" . a:ctermfg
  endif
  if a:ctermbg != ""
    exec "hi " . a:group . " ctermbg=" . a:ctermbg
  endif
  if a:attr != ""
    exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
  endif
  if a:guisp != ""
    exec "hi " . a:group . " guisp=#" . a:guisp
  endif
endfunction


fun <sid>hi(group, guifg, guibg, ctermfg, ctermbg, attr, guisp)
  call g:Base16hi(a:group, a:guifg, a:guibg, a:ctermfg, a:ctermbg, a:attr, a:guisp)
endfun



"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
"hi Ignore -- no settings --
"hi CTagsImport -- no settings --
"hi CTagsGlobalVariable -- no settings --
"hi EnumerationValue -- no settings --
"hi Union -- no settings --
"hi Question -- no settings --
"hi EnumerationName -- no settings --
"hi DefinedName -- no settings --
"hi LocalVariable -- no settings --
"hi CTagsClass -- no settings --
"hi clear -- no settings --


" Vim editor colors
call <sid>hi("Normal",         s:white, s:background, s:cterm_white, s:cterm_background, "", "")
call <sid>hi("Include",        s:keywords, "", s:cterm_keywords, "", "", "")
call <sid>hi("Keyword",        s:keywords, "", s:cterm_keywords, "", "", "")
call <sid>hi("Statement",      s:keywords, "", s:cterm_keywords, "", "", "")
call <sid>hi("Boolean",        s:keywords, "", s:cterm_keywords, "", "", "")
call <sid>hi("Structure",      s:keywords, "", s:cterm_keywords, "", "", "")
call <sid>hi("StorageClass",   s:keywords, "", s:cterm_keywords, "", "", "")
call <sid>hi("Conceal",        s:invisibles, s:background, s:cterm_invisibles, s:cterm_background, "", "")
call <sid>hi("Cursor",         s:background, s:white, s:cterm_background, s:cterm_white, "", "")
call <sid>hi("CursorLine",     "", s:current_line, "", s:cterm_current_line, "NONE", "")
call <sid>hi("CursorLineNR",   s:white, "", s:cterm_white, "", "", "")
call <sid>hi("CursorColumn",   "", s:current_line, "", s:cterm_current_line, "", "")
call <sid>hi("Visual",         "", s:selection, "", s:cterm_selection, "", "")
call <sid>hi("Comment",        s:comment, "", s:cterm_comment, "", "", "")
call <sid>hi("Delimiter",      s:strings, "", s:cterm_strings, "", "", "")
call <sid>hi("String",         s:strings, "", s:cterm_strings, "", "", "")
call <sid>hi("Character",      s:characters, "", s:cterm_characters, "", "", "")
call <sid>hi("Float",          s:numbers, "", s:cterm_numbers, "", "", "")
call <sid>hi("Number",         s:numbers, "", s:cterm_numbers, "", "", "")
call <sid>hi("Function",       s:other_function_and_metod_names, "", s:cterm_other_function_and_metod_names, "", "", "")
call <sid>hi("Identifier",     s:other_type_names, "", s:cterm_other_type_names, "", "", "")
call <sid>hi("Type",           s:other_type_names, "", s:cterm_other_type_names, "", "", "")
call <sid>hi("SignColumn",     s:sign_column, s:background, s:cterm_sign_column, s:cterm_background, "", "")
call <sid>hi("LineNr",         s:line_number, "", s:cterm_line_number, "", "", "")
call <sid>hi("Search",         s:black, s:search_background, s:cterm_black, s:cterm_search_background, "", "")
call <sid>hi("IncSearch",      s:black, s:yellow, s:cterm_black, s:cterm_yellow, "NONE", "")
call <sid>hi("Todo",           s:black, s:yellow, s:cterm_black, s:cterm_yellow, "", "")
call <sid>hi("MatchParen",     s:black, s:yellow, s:cterm_black, s:cterm_yellow, "", "")
call <sid>hi("WarningMsg",     s:black, s:yellow, s:cterm_black, s:cterm_yellow, "", "")
call <sid>hi("ErrorMsg",       s:black, s:red, s:cterm_black, s:cterm_red, "", "")
call <sid>hi("Operator",       "", "", "", "", "NONE", "")
call <sid>hi("",        "", "", "", "", "", "")

" swift
call <sid>hi("swiftTypeDeclaration",        "", "", "", "", "NONE", "")



" c/c++/objc
call <sid>hi("cType",          s:keywords, "", "", "", "", "")
call <sid>hi("cppType",        s:keywords, "", "", "", "", "")
call <sid>hi("Constant",       s:keywords, "", "", "", "", "")
call <sid>hi("Repeat",         s:keywords, "", "", "", "", "")
call <sid>hi("Conditional",    s:keywords, "", "", "", "", "")
call <sid>hi("Label",          s:keywords, "", "", "", "", "")
call <sid>hi("cOperator",      s:keywords, "", "", "", "", "")
call <sid>hi("cConstant",      s:keywords, "", "", "", "", "")
call <sid>hi("cppSTLconstant", s:keywords, "", "", "", "", "")
call <sid>hi("SpecialChar",    s:strings, "", "", "", "", "")
call <sid>hi("objcLiteralSyntaxOp",    s:characters, "", "", "", "", "")
call <sid>hi("cSpecialCharacter",    s:characters, "", "", "", "", "")
call <sid>hi("objcImport",        s:preprocessor_statements, "", "", "", "", "")
call <sid>hi("cInclude",        s:preprocessor_statements, "", "", "", "", "")
call <sid>hi("cPreCondit",        s:preprocessor_statements, "", "", "", "", "")
call <sid>hi("cCustomFunc",        "", "", "", "", "NONE", "")
call <sid>hi("cAnsiFunction",        "", "", "", "", "NONE", "")
call <sid>hi("cAnsiName",        "", "", "", "", "NONE", "")
call <sid>hi("objcClassMethod",        "", "", "", "", "NONE", "")
call <sid>hi("objcInstanceMethod",        "", "", "", "", "NONE", "")
call <sid>hi("objcClass",        "", "", "", "", "NONE", "")
call <sid>hi("objcEnumValue",        "", "", "", "", "NONE", "")
call <sid>hi("cppSTLtype",        "", "", "", "", "NONE", "")
call <sid>hi("cppSTLfunction",        "", "", "", "", "NONE", "")
call <sid>hi("cppSTLnamespace",        "", "", "", "", "NONE", "")
call <sid>hi("cppSTLios",        "", "", "", "", "NONE", "")


" python3
call <sid>hi("pythonInclude",  s:keywords, "", "", "", "", "")
call <sid>hi("pythonStatement",s:keywords, "", "", "", "", "")
call <sid>hi("pythonException",s:keywords, "", "", "", "", "")
call <sid>hi("pythonQuotes",   s:strings, "", "", "", "", "")
call <sid>hi("pythonEscape",   s:characters, "", "", "", "", "")
call <sid>hi("Macro",          s:preprocessor_statements, "", "", "", "", "")
call <sid>hi("PreCondit",      s:preprocessor_statements, "", "", "", "", "")
call <sid>hi("pythonExceptions",        "", "", "", "", "NONE", "")
call <sid>hi("pythonBuiltin",        "", "", "", "", "NONE", "")
call <sid>hi("pythonFunction",        "", "", "", "", "NONE", "")



hi Define guifg=#fd8e3f guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi PreProc guifg=#fd8e3f guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi Typedef guifg=#536991 guibg=NONE guisp=NONE gui=bold ctermfg=60 ctermbg=NONE cterm=bold

hi WildMenu guifg=NONE guibg=#A1A6A8 guisp=#A1A6A8 gui=NONE ctermfg=NONE ctermbg=248 cterm=NONE
hi SpecialComment guifg=#BD9800 guibg=NONE guisp=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi Title guifg=#F9F9FF guibg=#192224 guisp=#192224 gui=bold ctermfg=189 ctermbg=235 cterm=bold
hi Folded guifg=#192224 guibg=#A1A6A8 guisp=#A1A6A8 gui=italic ctermfg=235 ctermbg=248 cterm=NONE
hi TabLineSel guifg=#192224 guibg=#BD9800 guisp=#BD9800 gui=bold ctermfg=235 ctermbg=1 cterm=bold
hi StatusLineNC guifg=#192224 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=235 ctermbg=66 cterm=bold
hi NonText guifg=#5E6C70 guibg=NONE guisp=NONE gui=italic ctermfg=66 ctermbg=NONE cterm=NONE
hi DiffText guifg=NONE guibg=#492224 guisp=#492224 gui=NONE ctermfg=NONE ctermbg=52 cterm=NONE
hi Debug guifg=#BD9800 guibg=NONE guisp=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=NONE guibg=#848688 guisp=#848688 gui=NONE ctermfg=NONE ctermbg=102 cterm=NONE




hi Special guifg=#BD9800 guibg=NONE guisp=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi StatusLine guifg=#192224 guibg=#BD9800 guisp=#BD9800 gui=bold ctermfg=235 ctermbg=1 cterm=bold
hi PMenuSel guifg=#192224 guibg=#BD9800 guisp=#BD9800 gui=NONE ctermfg=235 ctermbg=1 cterm=NONE

hi SpellRare guifg=#F9F9FF guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi TabLineFill guifg=#192224 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=235 ctermbg=66 cterm=bold
hi VisualNOS guifg=#192224 guibg=#F9F9FF guisp=#F9F9FF gui=underline ctermfg=235 ctermbg=189 cterm=underline
hi DiffDelete guifg=NONE guibg=#192224 guisp=#192224 gui=NONE ctermfg=NONE ctermbg=235 cterm=NONE
hi ModeMsg guifg=#F9F9F9 guibg=#192224 guisp=#192224 gui=bold ctermfg=15 ctermbg=235 cterm=bold
hi FoldColumn guifg=#192224 guibg=#A1A6A8 guisp=#A1A6A8 gui=italic ctermfg=235 ctermbg=248 cterm=NONE
hi MoreMsg guifg=#BD9800 guibg=NONE guisp=NONE gui=bold ctermfg=1 ctermbg=NONE cterm=bold
hi SpellCap guifg=#F9F9FF guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi VertSplit guifg=#192224 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=235 ctermbg=66 cterm=bold
hi Exception guifg=#BD9800 guibg=NONE guisp=NONE gui=bold ctermfg=1 ctermbg=NONE cterm=bold
hi DiffChange guifg=NONE guibg=#492224 guisp=#492224 gui=NONE ctermfg=NONE ctermbg=52 cterm=NONE
hi SpellLocal guifg=#F9F9FF guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi Error guifg=#A1A6A8 guibg=#912C00 guisp=#912C00 gui=NONE ctermfg=248 ctermbg=88 cterm=NONE
hi PMenu guifg=#192224 guibg=#5E6C70 guisp=#5E6C70 gui=NONE ctermfg=235 ctermbg=66 cterm=NONE
hi SpecialKey guifg=#5E6C70 guibg=NONE guisp=NONE gui=italic ctermfg=66 ctermbg=NONE cterm=NONE
hi Tag guifg=#BD9800 guibg=NONE guisp=NONE gui=NONE ctermfg=1 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#a4a6a8 guisp=#a4a6a8 gui=NONE ctermfg=NONE ctermbg=248 cterm=NONE
hi SpellBad guifg=#F9F9FF guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi Directory guifg=#536991 guibg=NONE guisp=NONE gui=bold ctermfg=60 ctermbg=NONE cterm=bold
hi Underlined guifg=#F9F9FF guibg=#192224 guisp=#192224 gui=underline ctermfg=189 ctermbg=235 cterm=underline
hi DiffAdd guifg=NONE guibg=#193224 guisp=#193224 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi TabLine guifg=#192224 guibg=#5E6C70 guisp=#5E6C70 gui=bold ctermfg=235 ctermbg=66 cterm=bold
hi cursorim guifg=#192224 guibg=#536991 guisp=#536991 gui=NONE ctermfg=235 ctermbg=60 cterm=NONE


" Remove functions
delf <sid>hi

" Remove color variables
" unlet s:gui00 s:gui01 s:gui02 s:gui03  s:gui04  s:gui05  s:gui06  s:gui07  s:gui08  s:gui09 s:gui0A  s:gui0B  s:gui0C  s:gui0D  s:gui0E  s:gui0F
" unlet s:cterm00 s:cterm01 s:cterm02 s:cterm03 s:cterm04 s:cterm05 s:cterm06 s:cterm07 s:cterm08 s:cterm09 s:cterm0A s:cterm0B s:cterm0C s:cterm0D s:cterm0E s:cterm0F
