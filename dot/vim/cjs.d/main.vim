" ===== General Notes =================================================

"   We try here to avoid clobbering useful standard key mappings.
"   When considering a new mapping, check `:help index` to see
"   if it's already used.

" ===== Settings ======================================================
" XXX This should gracefully degrade, a la
" http://blog.sanctum.geek.nz/gracefully-degrading-vimrc

" nvi and vim
set autoindent
set shiftwidth=4
set noexrc
set nowarn
set cedit=<C-E>

" vim-only
set timeoutlen=5000
set display+=lastline
set display+=uhex
set nomodeline
set hidden
set hlsearch
set ignorecase
if exists("&wildignorecase")
    set wildignorecase
endif
set smartcase
set noswapfile
set tags=./tags;
set wildmode=longest,list
set matchpairs=(:),{:},[:],<:>
set iskeyword=@,-,48-57,_,192-255

" We need to be careful with .viminfo to avoid leaking sensitive data.
" Note that we blank it later if editing an encrypted file.
set viminfo=!,%,'50,<0

set ruler

" special fixups for unusual Arch Linux defaults
set nobackup
filetype indent off

filetype on
syntax off

" ===== Colors ========================================================
" Available ctermfg colours, in DarkFoo and LightFoo versions:
"     Black Blue Green Cyan Red Magenta Yellow Grey White
" See them with `:runtime syntax/colortest.vim`
"
" N.B.: cterm settings must come after the ctermfg and ctermbg settings
" because subsequent color settings wipe out cterm settings.

set background=light

" editing
highlight NonText ctermfg=DarkGray
highlight Search ctermfg=DarkBlue ctermbg=White cterm=bold
highlight Pmenu ctermbg=NONE ctermfg=4
highlight PmenuSel ctermbg=NONE ctermfg=4 cterm=reverse
highlight ColorColumn ctermbg=lightyellow
highlight Underlined ctermfg=Black      " Remove magenta on Underlined text

" syntax
highlight Comment ctermfg=DarkGray
highlight Constant ctermfg=DarkYellow
highlight Special ctermfg=Black
highlight Identifier ctermfg=DarkBlue
highlight Statement ctermfg=Black
highlight PreProc ctermfg=Black
highlight Type ctermfg=Black
highlight Title ctermfg=Blue cterm=bold
highlight Subtitle ctermfg=Blue

" diffs
highlight diffAdded     ctermfg=DarkBlue
highlight diffRemoved   ctermfg=DarkRed
highlight diffFile      ctermfg=DarkGreen
highlight diffLine      ctermfg=DarkYellow

"   Git commit messages
highlight gitcommitComment ctermfg=Gray
highlight gitcommitOnBranch ctermfg=Gray
highlight gitcommitHeader ctermfg=Gray
highlight gitcommitType ctermfg=Gray
highlight link gitcommitOverflow gitcommitSummary

"   HTML
highlight htmlLink term=underline ctermfg=DarkGreen guifg=DarkGreen
highlight link htmlH3 Subtitle
highlight link htmlH4 Subtitle
highlight link htmlH5 Subtitle
highlight link htmlH6 Subtitle

"   markdown
highlight markdownCode  ctermfg=Brown
highlight link markdownCodeBlock markdownCode
highlight link markdownHeadingDelimiter Subtitle
highlight link markdownHeadingRule Title
"   `[foo]:` reference def; `[foo]` reference use; link assoc. w/reference
"   XXX markdownIdDeclaration defaults to link to `Type`, but despite the
"       setting above, Type is Green, not Black when editing `.md` files (due
"       to system override?) so clearly I need to sort out how my HL defs work
highlight markdownIdDeclaration term=underline cterm=underline
highlight markdownLinkText term=underline cterm=underline
highlight link markdownUrl htmlLink
"   XXX This hack turns of all error highlighting in Markdown files, but
"   it's acceptable because the only syntax match for markdownError is
"   "\w\@<=_\w\@=", which is the one thing we don't consider an error.
highlight link markdownError Normal

" spelling
highlight SpellBad      ctermfg=DarkRed ctermbg=none
highlight SpellCap      ctermfg=none ctermbg=none
highlight SpellRare     ctermfg=none ctermbg=none
highlight SpellLocal    ctermfg=none ctermbg=none

if &term == "kterm"
    set highlight=sb,Sb,lu
endif

"   Highlight-related commands
"   Overrides: gh  start select mode (Win/Mac-like selection that I never use)

set list listchars=tab:▹\ ,nbsp:◡,trail:░
noremap ghl   :set invlist<CR>

if exists("&colorcolumn")
    set colorcolumn=81,82,83,84
endif
noremap ghc   :setlocal colorcolumn=<CR>
noremap ghC   :setlocal colorcolumn=81,82,83,84<CR>

map ghd :runtime syntax/diff.vim<CR>    " diff highlighting
map ghs :syntax clear<CR>
map ghS :syntax enable<CR>

"   Display of color and highlighting information
noremap gh? :runtime syntax/colortest.vim<CR>
noremap gh/ :call SynGroup()<CR>
function! SynGroup()
    "   From https://stackoverflow.com/a/37040415/107294
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" ===== Graphical Environment =========================================

set guicursor=a:blinkon0
set guifont=Noto\ Mono\ 8
if has('win32')
    set guifont=Inconsolata:h10,Consolas:h10
endif

"   gg - Graphical settings prefix
"   Overrides: jump to <count> line default first; use `0G` instead
noremap ggfn :set guifont=Noto\ Mono\ 8<CR>
noremap ggfi :set guifont=Inconsolata\ Medium\ 9<CR>

" ===== Window/Tab Management ====================================

"   Default/detected  file/buffer format (unix/dos/mac) and encoding
"
set fileformats=unix
if has('win32')
    set fileformats=unix,dos
endif
set encoding=utf-8
set fileencodings=ascii,utf-8,euc-jp,sjis,cp932,ucs-bom,latin1

"   Status line and other information configuration
"
set laststatus=2                " Always have a status line
set notitle noicon              " Do not set (X11) window icon title
"
"   Fields on the status line are `%-0m.MI` where all but `%I` are optional:
"       • % starts the substitution field
"       • - left justifies instead of right
"       • 0 leading zeros in numerics, unless - given
"       • m minimum width, padded as above
"       • . separator for min/max width
"       • M maximum width; truncation with `<` on left for text,
"           `>N` for N digits on right
"       • I One-letter item code (see `:help statusline`)
set statusline=
set statusline+=%<                  " Truncate at start
set statusline+=%f\                 " Filename
set statusline+=%m%r%w%h            " [+/-], [RO], [PREVIEW], [HELP]
set statusline+=%=                  " Left/right split
set statusline+=%{Statusline_ftef()}" filetype,fileencoding,fileformat
set statusline+=\ \                 "
set statusline+=\\u%04.4B\          " Character code (hex)
set statusline+=%3c%-4.(%0V%)\      " cursor column
set statusline+=%5.l\ %P\           " cursor row and file percentage
set statusline+=%{Statusline_wfh()} " winfixheight indicator

function! Statusline_ftef()
    "   Return filetype and fileformat (if not "unix") for status line
    let l:s = '[' . &filetype
    if &fileencoding == ''
        let l:s .= ',¿'
    elseif &fileencoding == 'utf-8'
        " Don't bother showing it
    elseif &fileencoding == 'ascii'
        let l:s .= ',∀'
    else
        let l:s .= ',' . &fileencoding
    endif
    if &fileformat != "unix"
        let l:s .= ',' . &fileformat
    endif
    let l:s .= ']'
    return l:s
endfunction

function! Statusline_wfh()
    "   Return "FIX" if the window has winfixheight set, or empty spaces
    if &winfixheight == 0
        return "   "
    else
        return "FIX"
    endif
endfunction

"   Generally, new windows open below and all windows are resized to be even.
"   Use `qf` to "fix" windows that should not change size on splits.
set splitbelow equalalways

"   ^N/^P - move to next/previous file
"   Overrides: move to next/previous line
noremap <C-N> :next<CR>
noremap <C-P> :previous<CR>

"   We take over `q` as a prefix for all the stuff in this section.
"   Thus, disable `q` alone or with an unknown char following to avoid
"   accidentally turning on the 'record typed chars to register' mode
"   because sometimes doing that would be very confusing. (It's a
"   lesser-used command that we move elsewhere.)
noremap q :     call ConsumeError("Use `Q@` to record to register")<CR>
"   Having done this, we now restore some of the original qX commands.
noremap q:      q:
noremap q/      q/
noremap q?      q?

"   Window create/move commands
"   These tend to follow `q` with a right-hand key.
"
"   q{np}   move/wrap to next/previous window or window given by count
"   q{hjkl} move to window, just like Ctrl-W{hjkl}
"   q{rR}   resize larger/smaller
"   qf      Toggle fixed window vsize (won't change when splitting/closing)
"   qF      Toggle equalways (resizing all windows on new window)
"   qm      Maximize this window
"   qM      Set all windows equal size ('maximize all', of a sort)
"   q^J     split below and move to next file in arg list
"   q^K     split above and move to previous file in arg list
"
noremap qn      <C-w>w
noremap qp      <C-w>W
noremap qh      <C-W>h
noremap qj      <C-W>j
noremap qk      <C-W>k
noremap ql      <C-W>l
noremap qr      :resize +
noremap qR      :resize -
noremap q<C-R>  :resize 
noremap qf      :set invwinfixheight\|set winfixheight?<CR>
noremap qF      :set invequalalways\|set equalalways?<CR>
noremap qm      :resize +999<CR>
"               Careful to preserve current equalalways settings
noremap qM      :set invequalalways\|set invequalalways<CR>
noremap q<C-J>  :split +next<CR>
noremap q<C-K>  :above split +previous<CR>

"   Window close/delete (including quit) and buffer management commands
"   These tend to follow `q` with a left-hand key.
"
"   ZZ - write and quit all buffers (not just current one)
"   qc - close window
"   qw - quit (close) window if not last window
"   qq - close current window; exit if last window
"   qa - quit vim (closing all windows)
"   qA - force quit (all windows), abandoning unwritten buffers
"
"   qd      Allow DOS format and reload file
"   q{eE}   Change encoding to UTF-8 or prefix to view/change
"   q{tT}   Show/set filetype (for syntax highlighting, autocmd, etc.)
"   qX      Chmod current file to be executable
"
noremap ZZ      :xa<CR>
noremap qa      :quitall<CR>
noremap qA      :quitall!<CR>
noremap qc      <C-W>c
noremap qd      :set fileformats=unix,dos<CR>:e<CR>
noremap qe      :set fileencoding=UTF-8<CR>
noremap qE      :set fileencoding
noremap qt      :set filetype?<CR>
noremap qT      :set filetype=
noremap qq      <C-W>q
noremap qw      <C-W>c
noremap qX      :!chmod +x '%'<CR>

"   Version control commands
"
"   qvb     blame current file
"   qvc,qv/ Find next conflict marker
"           (Replace with <https://github.com/rhysd/conflict-marker.vim>?)
"   qvd     diff current file
"   qvD     diff all files from current dir down
"   qvl     log current file

"   Create command to open a new scratch buffer.
command! Scratch :new | :set buftype=nofile bufhidden=delete
noremap qvd :Scratch<CR>:r!dif #<CR>:runtime syntax/diff.vim<CR>
noremap qvw :Scratch<CR>:r!dif --word-diff=plain #<CR>:runtime syntax/diff.vim<CR>
noremap qvD :Scratch<CR>:r!dif<CR>:runtime syntax/diff.vim<CR>
noremap qvb :Scratch<CR>:r!blame #<CR>
noremap qvl :Scratch<CR>:r!log --follow #<CR>
noremap qvc /^\(<<<<<<< .*\\|\|\|\|\|\|\|\| .*\\|=======\\|>>>>>>> .*\)$<CR>
noremap qv/ /^\(<<<<<<< .*\\|\|\|\|\|\|\|\| .*\\|=======\\|>>>>>>> .*\)$<CR>
noremap qv  :call ConsumeError("Unknown qv command")<CR>

"   Misc. commands on `q`
"
"   q8      Disable colorcolumn (should really be flip setting)
"   q;      Switch to ex (line editor) mode
"   qz      Re-read .vimrc file.
noremap q8      :set colorcolumn=<CR>
noremap q;      gQ
noremap qz      :source $HOME/.vimrc<CR>


" ===== Misc. Key Mappings ==================================================

"   Additional movement commands
"
"   g{ey}   Scroll count*10 + 6 lines down/up in the buffer
"           (Overrides: `ge` backward to end of word)
"   g/      Search for visually selected text
"   gs      Search for whitespace at EOL (Overrides: `gs` sleep)
"
noremap ge  6<C-E>
noremap gy  6<C-Y>
noremap gs  /\s\+$<CR>
"            yank, start search, insert " register contents
vnoremap g/  y/\V<C-R>"<CR>

" copy and paste with GUI system clipboard(s)
map gc  :call ConsumeError("Unknown gc (copy/paste) function")<CR>
map gcc "+y
map gcy "+y
map gcl "+yl
map gcw "+yw
map gcW "+yW
map gcY "+Y
map gcf "+yf
map gct "+yt
map gc} "+y}
map gc{ "+y{
map gc$ "+y$
map gcG "+yG
map gcC "+y'a
map gcF :1,$y +<CR>
map gca :'a,.yank +<CR>
map gcA :1,$yank +<CR>
map gcv "+p
map gcp "+p
" "Paste into input mode" for local buffer
map gci :setlocal invpaste paste?<CR>

" gu - turn off search highlighting (like less(1) ESC-u)
map gu :nohlsearch<CR>

"   Help us unlearn deprecated mappings
noremap gr      :call DisplayError("gr: Use `qr` instead")<CR>
noremap g<C-N>  :call DisplayError("gr: Use `q^N` instead")<CR>

" Esc-s we leave undefined so that an accidental use of it in command
" mode still saves the file.

"   Q  - unmapped to avoid going into ex-mode (use better `gQ` for that)
"   Q@ - (followed by register) record for later execution with `@<reg`>`/`@@`
"   Overrides: Q (alone) to go into record mode
map     Q  :call ConsumeError("Unknown Q command")<CR>
noremap Q@ q

"-----------------------------------------------------------------------
" Visual mode

"   */# - search for text selected in visual mode, forward/backward
"   From: http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gV:call setreg('"', old_reg, old_regtype)<CR>


"-----------------------------------------------------------------------
" Formatting

set nojoinspaces
"   Turn off autowrap (formatoptions=t) so textwidth used only for autoformat.
set formatoptions=qn
set textwidth=70
"   See `gt` mappings for changing textwidth.

"-----------------------------------------------------------------------
" General commands

" ===== g commands

" g[67] - insert separation comment
map g7 O<ESC>70i-<ESC>0
map g6 O<ESC>68A#<ESC>0
noremap g! O<ESC>A<!--<ESC>64A-<ESC>A--><ESC>


" ga - autoindent
" gA - show ASCII/Unicode value of char under cursor
map     ga   :setlocal invai<CR>:setlocal ai?<CR>
noremap gA   ga

" gb - byte/word/line count
" vim uses g^G
map gb g<C-G>

" gF/gf fail/unfail a ruby test
map gF :s/def test_/def FAILING_test_/<CR>
map gf :s/def FAILING_test_/def test_/<CR>

" gg - GUI options (see elsewhere)

" gi - save and Install
map gi :wall<CR>:!run-install-upwards<CR><CR>

" gl  - line wrapping;      gL      - word wrapping
" g^L - toggle spellcheck;  g<ESC>l - "word processor" mode
map gl      :setlocal invwrap <CR>:setlocal wrap?<CR>
map gL      :setlocal invlbr  <CR>:setlocal lbr?<CR>
map g<C-L>  :setlocal invspell<CR>:set spell?<CR>
map g<ESC>l :call WordProcessorMode()<CR>
"   zy - Replace word with first spelling fix suggestion (normally unmapped)
noremap zy  1z=

function! WordProcessorMode()
    setlocal wrap scrolloff=0 linebreak nolist colorcolumn=
    setlocal spell spelllang=en_us
    set showbreak=┊
    " Up/down move screen lines, not file lines
    noremap j gj
    noremap k gk
    echo "Word Processor mode."
endfunction

" gM - turn off matchpairs (for speed)
map gM :set matchpairs=<CR>

" go - sort (order) this paragraph
map go {!}sort<CR>


"   gp - Format current pagagraph (very frequently used, so short is good)
"   g{ - Format from current position to beginning of this paragraph
"   g[ - Format from current position to end of this paragraph
"   gP - Preview markdown rendered in instant-markdown-d (must be running)
"        https://github.com/suan/instant-markdown-d
"   Overrides: gp gP  to paste but leave cursor after pasted text
"   Not sure if I want to move these elsewhere and start trying to use those.
noremap gp gwap
noremap g{ gw{
noremap g[ gw}
noremap gP :w !curl -X PUT -T - http://localhost:8090/<CR><CR>

"----------------------------------------------------------------------
"   gq - formatting and putting quotes or similar around text
"   Overrides: `gq` format commands that are not useful or nonsensical
"       (mostly smaller-than-line movement commands)

"   g{q,w}p - format short aliases: to mark 'a, 'b and paragraph
noremap gqa gq'a
noremap gwa gw'a
noremap gqb gq'b
noremap gwb gw'b
noremap gqp gqap
noremap gwp gwap

"   gqv␣ - "quote" visually selected area by putting ␣ on either side of it
noremap gqv' xi''<ESC>P
noremap gqv" xi""<ESC>P
noremap gqv` xi``<ESC>P
noremap gqv_ xi__<ESC>P
noremap gqv( xi()<ESC>P
noremap gqv[ xi[]<ESC>P
noremap gqv{ xi[]<ESC>P
noremap gqv< xi<><ESC>P

"   gqw␣, gqW␣ - select word and quote with gqv␣
"   (These are intentionally not `noremap` because they call `gqv`.)
map gqw viwgqv
map gqW viWgqv

"----------------------------------------------------------------------

" gR Run entire file in ruby.
map gR :w !ruby<CR>

" ----------------------------------------------------------------------
"  gt - column-related (tab-like) functions and tab pages
"  gT - tab and tabstop functions
"  Overrides: `gt`, `gT`: next and prev tab page

"  next/prev tab page
noremap gtn   gt
noremap gtp   gT
noremap gtN   :tabnew<CR>

noremap gTs   :set tabstop=
noremap gT2   :set tabstop=2 shiftwidth=2<CR>
noremap gT4   :set tabstop=4<CR>
noremap gT8   :set tabstop=8<CR>

noremap gte   :set expandtab softtabstop=4<CR>
noremap gts   :set shiftwidth=
noremap gt2   :set shiftwidth=2<CR>
noremap gt4   :set shiftwidth=4<CR>
noremap gt8   :set shiftwidth=8<CR>

noremap gtw   :set textwidth=
noremap gt5   :set textwidth=50<CR>
noremap gt%   :set textwidth=55<CR>
noremap gt6   :set textwidth=60<CR>
noremap gt^   :set textwidth=65<CR>
noremap gt7   :set textwidth=70<CR>
noremap gt&   :set textwidth=75<CR>
noremap gt8   :set textwidth=79<CR>
noremap gt*   :set textwidth=80<CR>

noremap gtv   :set virtualedit=<CR>
noremap gtV   :set virtualedit=all<CR>

"   Markdown configuration (see :help comments)
"   (Also see `autocmd FileType markdown`)
noremap gtm   :set comments=fb:*,fb:-,b:>


" ----------------------------------------------------------------------

" gZ run named-checkzone
map gZ :!named-checkzone 


" ===== Expansions/Abbreviations ==========================================

" functions for use with ^r= to insert things
function! It()
    strftime("%H:%M")
endfunction

" ^I - insert (really append) stuff
" (Don't use comments at the ends of these lines becuase for some reason
" they appear when run from insert mode with ^O.)
"
" Todo: make a vim function that takes a shell command as the arg, runs it,
" and strips the trailing newline off the output, so we don't need to use
" the "echo -n" thing in all the mappings below.
"
" dates:  YYYY-MM-DD, date+time, time only, time only
map <TAB>d      "=system('. ~/.bashrc && echo -n `i-date`')<CR>p
map <TAB>D      "=system('echo -n `date "+%y%m%d" "$@"`')<CR>p
map <TAB>t      "=system('. ~/.bashrc && echo -n `i-time`')<CR>p
map <TAB>T      "=system('echo -n `date +\%H:\%M`')<CR>p
map <TAB><C-T>  "=system('echo -n `date +\%H:\%M`')<CR>p
"
" password generation
map <TAB>p      "=system('echo -n `makepw all`')<CR>p
map <TAB>P      "=system('echo -n `makepw nopunc`')<CR>p

" English
"abbr sb substitution
abbr coop coöp
abbr cooperation coöperation

" ===== Autocmd Cleanup ==================================================

augroup redhat  " Remove annoying RH packager's idea of vim startup
autocmd!
augroup end     " Remove autocommands from default group so we start clean
autocmd!

" ===== Tab Settings =====================================================

" Use spaces instead of tabs for any files that have no tabs
" near the beginning (in the first thousand lines)
function! ExpandTabCheck()
    let s:tab = search("\t", "n")", 1000)
    if s:tab == 0
        setlocal expandtab
        setlocal softtabstop=4
    endif
endfunction
autocmd BufEnter * call ExpandTabCheck()

" ===== TXT files ========================================================

autocmd! BufNewFile                 *.txt setlocal fileformat=dos
" The following line doesn't seem to work, thus the hack after it.
"autocmd! BufReadPre,FileReadPre            *.txt set fileforamts=dos,unix
autocmd! BufReadPost,FileReadPost   *.txt call TXTFile()
function! TXTFile()
    set fileformats=unix,dos
    edit
endfunction

" ===== Git Commit Messages ==========================================

autocmd FileType gitcommit setlocal textwidth=70 fileencoding=UTF-8
autocmd FileType gitcommit syntax on

" ===== Markdown mode ================================================

"   Some vim installations set syntax=modula2 for *.md files
autocmd BufNewFile,BufFilePre,BufRead       *.md set filetype=markdown

autocmd Filetype markdown setlocal sw=2
autocmd FileType markdown setlocal textwidth=70
autocmd FileType markdown syntax on
                          " Also see `gtm` mapping
autocmd FileType markdown set comments=fb:*,fb:-,b:>

" ===== YAML mode ===================================================

autocmd! BufNewFile,BufReadPre,FileReadPre  *.yml   setlocal sw=4
autocmd! BufNewFile,BufReadPre,FileReadPre  *.yaml  setlocal sw=4

" ===== C mode ========================================================

function! SetCCodeSettings()
    setlocal iskeyword=@,48-57,_,192-255
endfunction
autocmd! BufNewFile,BufReadPre,FileReadPre  *.c     call SetCCodeSettings()
autocmd! BufNewFile,BufReadPre,FileReadPre  *.h     call SetCCodeSettings()
autocmd! BufNewFile,BufReadPre,FileReadPre  *.cpp   call SetCCodeSettings()
autocmd! BufNewFile,BufReadPre,FileReadPre  *.hpp   call SetCCodeSettings()

" ===== Go mode =======================================================

function! SetGoCodeSettings()
    setlocal noexpandtab
    setlocal tabstop=4
    setlocal iskeyword=@,48-57,_,192-255
endfunction
autocmd! BufNewFile,BufReadPre,FileReadPre  *.go    call SetGoCodeSettings()
" Override the changes made by ExpandTabCheck:
autocmd! BufEnter                           *.go    call SetGoCodeSettings()

" ===== Haskell mode ==================================================

autocmd! BufNewFile,BufReadPre,FileReadPre  *.hs    so ~/.vim/haskell.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.hsc   so ~/.vim/haskell.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.cabal so ~/.vim/haskell.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.erl   so ~/.vim/haskell.vim

" ===== Encrypted file editing  =======================================

" Edit gpg-encrypted ascii-armoured files
autocmd! BufReadPre,FileReadPre      *.asc  setlocal viminfo= bin
autocmd  BufReadPost,FileReadPost    *.asc  '[,']!gpg -q -d
autocmd  BufReadPost,FileReadPost    *.asc  setlocal nobin
autocmd! BufWritePre,FileWritePre    *.asc  setlocal bin
autocmd  BufWritePre,FileWritePre    *.asc  '[,']!gpg -e
autocmd  BufWritePost,FileWritePost  *.asc  undo
autocmd  BufWritePost,FileWritePost  *.asc  setlocal nobin

" ===== Explorer settings =============================================

let g:explDetailedList=1
let g:explDateFormat="%Y-%b-%d %H:%M"

" ===== Buffer explorer plugin =====

"let loaded_bufexplorer = 1
let mapleader = "g"

" ===== Taglist Plugin ==============================================

let Tlist_Ctags_Cmd = "/usr/pkg/bin/exctags"

" ===== StarlingCopyrightCheck ======================================

map z. :call DisplayError("Try using zz instead.")<CR>

function! DisplayError(s)
    echohl ErrorMsg
    " We don't use :echoerr here because that always adds a line with the
    " current script line number; it's clearly intended for debugging.
    echomsg a:s
    echohl None
endfunction

function! ConsumeError(s)
    "   Consume a character and then display an error. This is used
    "   with multichar mappings when a prefix matches but the last
    "   char doesn't match any mapping in order to prevent that last
    "   char from being executed as a new command.
    "
    "   On timeout you'll end up with the `call DisplayError` below
    "   displayed at the command line, waiting for a keypress. This
    "   should probably be fixed, but it's fairly obvious to the end
    "   user what the problem is.
    "
    let l:c = getchar()
    call DisplayError(a:s . ': ' . nr2char(l:c))
endfunction

function! StarlingCopyrightCheck()
    let s:year = strftime("%Y")
    let s:cmatch = search("Copyright.*Starling Software", "n")
    let s:ymatch = search("Copyright.*" . s:year . ".*Starling Software", "n")
    if s:cmatch > 0 && s:ymatch == 0
        echohl ErrorMsg
        echo "Warning: Starling copyright notice without current year (" .  s:year . ")."
        echohl None
    endif
endfunction
"autocmd  BufEnter * call StarlingCopyrightCheck()

" ===== Inline substitutions =========================================
function! FilterUnnamedBuffer(command)
    # .. send unnamed buffer as stdin to command....
endfunction

" XXX extract common code here!
"
" Run expression through calc, using default options.
:map gC y:silent call setreg('@', system("printf '%s' $(calc " . shellescape(@@) . ")"))<CR>:normal! gvp<CR><CR>
" Run expression through calc then round to nearest even integer.
:map gCR y:silent call setreg('@', system("printf '%.0f' $(calc " . shellescape(@@) . ")"))<CR>:normal! gvp<CR><CR>

" ===== Digraphs =====================================================
" Input with Ctrl-K followed by two chars.

" Commonly used digraphs to remember:
"
"      .M ·   1m ○   0M ●       (but see custom digraphs below)
"      OK ✓   /\ ×
"      *X ×   :- ÷
"      FA ∀   TE ∃   AN ∧   OR ∨   .: ∴
"      (- ∈   -) ∋
"      00 ∞
" -1,-N,-M,NS   hyphen,en-dash,em-dash,nb-space
" greek ends in *: G*‐Γ  g*‐γ
" s/S = superscript/subscript: 1s=₁ 2S=²
" Also see: http://www.alecjacobson.com/weblog/?p=443
"
" Bullet somehow seems to be a regular problem. 0m produces diamonds...
" Check https://unicode-table.com/en/2022/

" Custom digraphs
"
"        .M  183    " · U+00b7 Middle dot/interpunct is built in
digraph  .m 8226    " • U+2022 Bullet (don't confuse with middle dot or
                    " ● 0M Black Circle which doesn't work in some fonts).
digraph  is 7522    " ࠳ Latin Subscript Small Letter I
digraph  iS 8305    " ࠳ Latin Superscript Small Letter I
digraph  ns 8345    " ࠳ Latin Subscript Small Letter N
digraph  nS 8319    " ࠳ Latin Superscript Small Letter N
digraph  -^ 8593    " ↑ Upwards Arrow (alternative to -!)
digraph \|- 8866    " ⊢ Right Tack
digraph  cm 8984    " ⌘ Place of Interest Sign (Mac Command Key)
digraph  om 8997    " ⌥ Option Key (Mac)
digraph  '/  773    " a̅ Combining Overbar (like / for "active low")
digraph  0+ 8853    " ْْࣷ⊕ Circled Plus Operator (overrides Arabic Sukun)


" ----------------------------------------------------------------------
" External Program Settings

"   We want to source `.bashrc` before executing any shell commands so
"   we can use shell functions and aliases with `:!`. However, we
"   cannot use `-i` to ask bash to source `.bashrc` because it will
"   also do other 'interactive' things that cause unwanted behaviour,
"   such as starting a new process group that on some command exits
"   (particularly for commands that produce no output) will still be
"   there when vim next generates output and thus stopping vim with a
"   SIGTTOU ('Background write to tty') signal and leaving you at your
"   original shell prompt. (Type `fg` to bring vim back.) Further
"   information:
"       https://superuser.com/a/646268
"       https://apple.stackexchange.com/q/199520/175545
"       https://github.com/christoomey/vim-tmux-navigator/issues/97
"
"   So instead we have a special script that will source `.bashrc` and
"   then `exec "$1"` to run the command in that same shell.
"
set shell=bash-rcc
