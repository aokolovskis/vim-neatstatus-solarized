" NeatStatus (c) 2012 Lukasz Grzegorz Maciak
"
" Based on a script by Tomas Restrepo (winterdom.com)
" " Original available here:
" http://winterdom.com/2007/06/vimstatusline

set ls=2 " Always show status line
let g:last_mode=""

" SOLARIZED HEX     16/8 TERMCOL  XTERM/HEX   L*A*B      sRGB        HSB
" --------- ------- ---- -------  ----------- ---------- ----------- -----------
" base03    #002b36  8/4 brblack  234 #1c1c1c 15 -12 -12   0  43  54 193 100  21
" base02    #073642  0/4 black    235 #262626 20 -12 -12   7  54  66 192  90  26
" base01    #586e75 10/7 brgreen  240 #4e4e4e 45 -07 -07  88 110 117 194  25  46
" base00    #657b83 11/7 bryellow 241 #585858 50 -07 -07 101 123 131 195  23  51
" base0     #839496 12/6 brblue   244 #808080 60 -06 -03 131 148 150 186  13  59
" base1     #93a1a1 14/4 brcyan   245 #8a8a8a 65 -05 -02 147 161 161 180   9  63
" base2     #eee8d5  7/7 white    254 #d7d7af 92 -00  10 238 232 213  44  11  93
" base3     #fdf6e3 15/7 brwhite  230 #ffffd7 97  00  10 253 246 227  44  10  99
" yellow    #b58900  3/3 yellow   136 #af8700 60  10  65 181 137   0  45 100  71
" orange    #cb4b16  9/3 brred    166 #d75f00 50  50  55 203  75  22  18  89  80
" red       #dc322f  1/1 red      160 #d70000 50  65  45 220  50  47   1  79  86
" magenta   #d33682  5/5 magenta  125 #af005f 50  65 -05 211  54 130 331  74  83
" violet    #6c71c4 13/5 brmagenta 61 #5f5faf 50  15 -45 108 113 196 237  45  77
" blue      #268bd2  4/4 blue      33 #0087ff 55 -10 -45  38 139 210 205  82  82
" cyan      #2aa198  6/6 cyan      37 #00afaf 60 -35 -05  42 161 152 175  74  63
" green     #859900  2/2 green     64 #5f8700 60 -20  65 133 153   0  68 100  60


" Override theme settings
hi StatusLine   guifg=#002b36 guibg=#839496 gui=NONE ctermfg=8  ctermbg=12 cterm=NONE
hi StatusLineNC guifg=#839496 guibg=#073642 gui=NONE ctermfg=12 ctermbg=0  cterm=NONE

" Basic color presets
" Mode
hi User1 guifg=#eee8d5 guibg=#073642 gui=NONE ctermfg=7  ctermbg=0 cterm=NONE
" Alt1
hi User2 guifg=#839496 guibg=#073642 gui=bold ctermfg=12 ctermbg=0 cterm=bold
" Alt2
hi User3 guifg=#657b83 guibg=#073642 gui=NONE ctermfg=11 ctermbg=0 cterm=NONE
" Warning
hi User4 guifg=#eee8d5 guibg=#dc322f gui=bold ctermfg=7  ctermbg=1 cterm=bold
" Modified
hi User5 guifg=#eee8d5 guibg=#d33682 gui=bold ctermfg=7  ctermbg=5 cterm=bold

" pretty mode display - converts the one letter status notifiers to words
function! Mode()
    let l:mode = mode()
    if     mode ==# "n"  | return "NORMAL"
    elseif mode ==# "i"  | return "INSERT"
    elseif mode ==# "R"  | return "REPLACE"
    elseif mode ==# "v"  | return "VISUAL"
    elseif mode ==# "V"  | return "V-LINE"
    elseif mode ==# "^V" | return "V-BLOCK"
    else                 | return l:mode
    endif
endfunc    

" Change the values for User1 color preset depending on mode
function! ModeChanged(mode)
    if     a:mode ==# "n"  | hi User1 guifg=#eee8d5 guibg=#002b36 gui=NONE ctermfg=7  ctermbg=0 cterm=NONE
    elseif a:mode ==# "i"  | hi User1 guifg=#fdf6e3 guibg=#cb4b16 gui=bold ctermfg=15 ctermbg=9 cterm=bold
    elseif a:mode ==# "r"  | hi User1 guifg=#fdf6e3 guibg=#d33682 gui=bold ctermfg=15 ctermbg=5 cterm=bold
    "elseif a:mode ==# "v"  | hi User1 guifg=#fdf6e3 guibg=#d33682 gui=bold ctermfg=15 ctermbg=5 cterm=bold
    "elseif a:mode ==# "V"  | hi User1 guifg=#fdf6e3 guibg=#d33682 gui=bold ctermfg=15 ctermbg=5 cterm=bold
    "elseif a:mode ==# "^V" | hi User1 guifg=#fdf6e3 guibg=#d33682 gui=bold ctermfg=15 ctermbg=5 cterm=bold
    else                   | hi User1 guifg=#fdf6e3 guibg=#b58900 gui=NONE ctermfg=15 ctermbg=3 cterm=NONE
    endif
endfunc

" Return a string if file is modified or empty string if its not
function! Modified()
    let l:modified = &modified

    if modified == 0
        return ''
    else
        return 'modified'
endfunc

" Return a string if in paste mode
function! Paste()
    let l:paste = &paste

    if paste == 0
        return ''
    else
        return 'PASTE'
endfunc

if has('statusline')

    " Status line detail:
    "
    " %f    file name
    " %F    file path
    " %y    file type between braces (if defined)
    "
    " %{v:servername}   server/session name (gvim only)
    "
    " %<    collapse to the left if window is to small
    "
    " %( %) display contents only if not empty
    "
    " %1*   use color preset User1 from this point on (use %0* to reset)
    "
    " %([%R%M]%)   read-only, modified and modifiable flags between braces
    "
    " %{'!'[&ff=='default_file_format']}
    "        shows a '!' if the file format is not the platform default
    "
    " %{'$'[!&list]}  shows a '*' if in list mode
    " %{'~'[&pm=='']} shows a '~' if in patchmode
    "
    " %=     right-align following items
    "
    " %{&fileencoding}  displays encoding (like utf8)
    " %{&fileformat}    displays file format (unix, dos, etc..)
    " %{&filetype}      displays file type (vim, python, etc..)
    "
    " #%n   buffer number
    " %l/%L line number, total number of lines
    " %p%   percentage of file
    " %c%V  column number, absolute column number
    "
    function! SetStatusLineStyle()
        let l:divider = "│"
        let &stl=""
        let &stl.="%(%2* %{Paste()} %)"
        " mode (changes color)
        let &stl.="%1*\ %{Mode()} %0*" 
        " file path
        let &stl.=" %<%f "
        " read only, modified, modifiable flags in brackets
        let &stl.="%([%R%M]%) "

        " right-aligh everything past this point
        let &stl.="%= "

        " readonly flag
        let &stl.="%(%{(&ro!=0?'(readonly)':'')} %)"

        " file type (eg. python, ruby, etc..)
        let &stl.="%2*%( %{&filetype} %)%0* "
        " file format (eg. unix, dos, etc..)
        let &stl.="%{&fileformat} ".divider." "
        " file encoding (eg. utf8, latin1, etc..)
        let &stl.="%(%{(&fenc!=''?&fenc:&enc)} ".divider." %)"
        " buffer number
        let &stl.="buf #%n " 
        " minwid=20: column - line number / total lines (percentage)
        let &stl.="%3* %20(%c%V-%2*%l%3*/%L\ (%p%%)%) %0*"
        " modified / unmodified
        let &stl.="%(%5* %{Modified()} %)"
    endfunc
    
    augroup NeatStatusMain
        autocmd!
        autocmd InsertEnter * call ModeChanged(v:insertmode)
        autocmd InsertChange * call ModeChanged(v:insertmode)
        autocmd InsertLeave * call ModeChanged(mode())
    augroup END

    " handle mode exit via C-c
    inoremap <c-c> <c-o>:call ModeChanged(mode())<cr><c-c>

    " Switch between the normal and vim-debug modes in the status line
    nmap _ds :call SetStatusLineStyle()<CR>
    call SetStatusLineStyle()
    " Window title
    if has('title')
        set titlestring=%t%(\ [%R%M]%)
    endif
endif
