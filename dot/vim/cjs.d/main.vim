" ===== General Notes =================================================

"   We try here to avoid clobbering useful standard key mappings.
"   When considering a new mapping, check `:help index` to see
"   if it's already used.

"   Documentation:
"   ∙ Vim scripting help: :help eval
"   ∙ Vim scripting cheatsheet: https://devhints.io/vimscript

" ===== Debugging Notes  ==============================================

"   To figure out what lines in this file are causing other files to
"   be sourced, create an empty file named as below, enable this line
"   at any point in this file, and then use :scriptnames or :scr to see
"   where it is shown in the order of scripts that were run.
"source ~/.vim/checkpoint0.vim

" ===== Settings ======================================================
" XXX This should gracefully degrade, a la
" http://blog.sanctum.geek.nz/gracefully-degrading-vimrc

set nocompatible
:scriptencoding utf-8

" ===== Reset Environment =============================================
"
"   It's not entirely clear how to deal with using my environment in
"   accounts where the user brings in a ton of very aggressive stuff, such
"   as the "airline" package that  overrides any other status line. For the
"   moment I just clear 'packpath' and leave it at that. I _don't_ clean up
"   'runtimepath' because that blocks access to some of my own stuff as
"   well, and I don't want to stop others from :runtime'ing in a
"   bit of their own stuff from time to time.
"
"   Certain user's use of symlinks make this even more complex because if
"   ~/.vim is a symlink, dot-home will not be able to place my files in it.
"   Probably for that I need to add paths into ~/.home/cjs0/.
"
"set runtimepath=$VIMRUNTIME    " XXX would cut out my own stuff!
if has('packages')
    set packpath=               " Avoid autoloading another user's packages.
endif

" ===== FileType ==================================================

"   This needs to be done before the autocmds so that we can set
"   filetypes in those.
"   Sources /usr/share/vim/vim80/filetype.vim
filetype on

" ===== Autocmd Cleanup ==================================================

augroup redhat  " Remove annoying RH packager's idea of vim startup
autocmd!
augroup end     " Remove autocommands from default group so we start clean
autocmd!

" ===== Tab Settings =====================================================
"   Generic to all files.

"   Use spaces instead of tabs for any files that have no tabs
"   near the beginning (in the first thousand lines)
function! ExpandTabCheck()
    let s:tab = search("\t", "n")", 1000)
    if s:tab == 0
        setlocal expandtab
        setlocal softtabstop=4
    endif
endfunction
autocmd BufEnter * call ExpandTabCheck()

" ===== Custom Filename Extensions =======================================
"   These files use standard settings, but are extensions not
"   recognized by /usr/share/vim/vim80/filetype.vim.

"   Pytest files. Overrides: Zope template files.
autocmd! filetypedetect BufNewFile,BufRead *.pt setf python

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

autocmd FileType gitcommit setlocal textwidth=75 fileencoding=UTF-8
autocmd FileType gitcommit syntax on

" ===== Markdown mode ================================================

"   Some vim installations set syntax=modula2 for *.md files
autocmd BufNewFile,BufFilePre,BufRead       *.md set filetype=markdown

autocmd Filetype markdown setlocal sw=2
autocmd FileType markdown setlocal textwidth=75
autocmd FileType markdown syntax on
                          " Also see `gtm` mapping
autocmd FileType markdown setlocal comments=fb:*,fb:-,b:>

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

" ===== Assembly language modes ========================================

function! SetAsmCodeSettings()
    " Maybe should set filetype=asm and/or call s:FTasm?
    setlocal comments=b:;
    setlocal textwidth=75
endfunction
"   Probably we should use `setf asm` here....
autocmd! BufReadPre,FileReadPre
    \ *.{asm,i80,i85,z80,a68,a69,a65}
    \ call SetAsmCodeSettings()

"   'asm' syntax highlighting doesn't work very well for me
autocmd! BufReadPost
    \ *.{asm,i80,i85,z80,a68,a69,a65}
    \ setlocal filetype=

"   These files are generated, not edited:
"   • .lst  Listing output from assemblers
"   • .dis  Disassembler output
function! SetListCodeSettings()
    setlocal readonly autoread
    setlocal nolist nowrap
    setlocal iskeyword-=-
endfunction
autocmd! BufReadPre,FileReadPre
    \ *.{lst,dis}
    \ call SetListCodeSettings()

"   'asm' syntax highlighting doesn't work very well with listing files.
autocmd! BufReadPost *.{lst,dis}  setlocal filetype=


" ===== Encrypted file editing  =======================================

" Edit gpg-encrypted ascii-armoured files
autocmd! BufReadPre,FileReadPre      *.asc  setlocal viminfo= bin
autocmd  BufReadPost,FileReadPost    *.asc  '[,']!gpg -q -d
autocmd  BufReadPost,FileReadPost    *.asc  setlocal nobin
autocmd! BufWritePre,FileWritePre    *.asc  setlocal bin
autocmd  BufWritePre,FileWritePre    *.asc  '[,']!gpg -e
autocmd  BufWritePost,FileWritePost  *.asc  undo
autocmd  BufWritePost,FileWritePost  *.asc  setlocal nobin


" ===== Settings from .vim/cjs.d/tiny.vim =============================
"   XXX Possibly this should be reading that file instead.
noremap s :w<CR>
noremap S :wa<CR>

" ===== Basic Settings ================================================
" nvi and vim
set autoindent
set shiftwidth=4
set noexrc
set nowarn
set cedit=<C-E>

" vim-only
set nofixeol                " If I need to fix, I just add an empty line at end
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
set suffixesadd=.md
"   shortmess=filnxtToOS    " default
set shortmess-=S            " display "[1/5]" search count
set shortmess+=I            " suppress :intro message

" We need to be careful with .viminfo to avoid leaking sensitive data.
" Note that we blank it later if editing an encrypted file.
set viminfo=!,%,'50,<0

set ruler

" special fixups for unusual Arch Linux defaults
set nobackup
filetype indent off

" ===== Colors ========================================================

"   Sources  /usr/share/vim/vim80/syntax/nosyntax.vim
"syntax off

syntax enable
set background=light
colorscheme cjs

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
if has('win32')
    set guifont=Inconsolata:h10,Consolas:h10
else
    set guifont=Noto\ Mono\ 8
endif

"   gg - Graphical settings prefix
"   Overrides: `gg`; use `0G` or `g<C-M>` instead.
noremap g<C-M>  gg      " kinda parallel to z<C-M>
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
set statusline+=\\u%05.5B\          " Character code (hex)
set statusline+=%3vc                " ###c: cursor column on screen
set statusline+=%-4{Statusline_bytecol()}
set statusline+=%5.l\ %P\           " cursor row and file percentage
set statusline+=%{Statusline_wfh()} " winfixheight indicator
set statusline+=\ %{exists('*mode')?mode():'•'}

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

function! Statusline_bytecol()
    "   Return cursor position as the number of bytes into the line in the
    "   current character encoding, or a space if it's the same as the
    "   screen column.
    let l:screencol = wincol()
    let l:bytecol = col('.')
    if l:bytecol != l:screencol
        return l:bytecol
    else
        "   Must return space because an empty string will remove the
        "   field entirely from the status line (shifting other items)
        "   rather than fill it out to minwidth.
        return ' '
    end
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
"   ZZ      write and quit all buffers (not just current one)
"   qc      close window
"   qw      quit (close) window if not last window
"   qq      close current window; exit if last window
"   qa      quit vim (closing all windows)
"   qA      force quit (all windows), abandoning unwritten buffers
"   q^A     force quit with error code (:cquit even without ! does this)
"
"   qC      Add additional comment character
"   q-      Remove - from list of "word" characters
"   qd      Allow DOS format and reload file
"   q{eE}   Change encoding to UTF-8 or prefix to view/change
"   q{tT}   Show/set filetype (for syntax highlighting, autocmd, etc.)
"   qX      Chmod current file to be executable
"
noremap ZZ      :xa<CR>
noremap q-      :setlocal iskeyword-=-<CR>
noremap q_      :setlocal iskeyword-=_<CR>
noremap qa      :quitall<CR>
noremap qA      :quitall!<CR>
noremap q<C-A>  :cquit!<CR>
noremap qc      :call DisplayError("qc: Use `qw` to close window")<CR>
noremap qC      :setlocal comments+=b:
noremap qd      :set fileformats=unix,dos<CR>:e<CR>
noremap qe      :set fileencoding=UTF-8<CR>
noremap qE      :set fileencoding
noremap qK      :setlocal iskeyword-=
noremap qs      :checktime<CR>          " reload files saved outside vim
noremap qt      :set filetype?<CR>
noremap qT      :set filetype=
noremap qq      :call DisplayError("qq: use `qw` to close window")<CR>
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
"   qvs     diff staged changes for current file
"   qvS     diff staged changes for all files from current dir down
"   qvw     word diff

"   Create command to open a new scratch buffer.
command! Scratch :new | :set buftype=nofile bufhidden=delete
noremap qvd :Scratch<CR>:r!dif #<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvD :Scratch<CR>:r!dif<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvs :Scratch<CR>:r!dif --staged #<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvS :Scratch<CR>:r!dif --staged<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvw :Scratch<CR>:r!dif --word-diff=plain #<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvb :Scratch<CR>:r!blame #<CR>:normal gg<CR>
noremap qvl :Scratch<CR>:r!log --follow #<CR>:set nolist<CR>:normal gg<CR>
noremap qvC :call GitCommit()<CR>
noremap qvc :call GitCommit('-f')<CR>
noremap qv/ /^\(<<<<<<< .*\\|\|\|\|\|\|\|\| .*\\|=======\\|>>>>>>> .*\)$<CR>
noremap qv  :call ConsumeError("Unknown qv command")<CR>

"   Run a commit script, if available, otherwise just run 'git commit'.
"   • We search for an executable file named 'commit' in the current directory
"     and then each parent directory above it.
"   • The `gc` mapping passes '-f', which the commit script should interpret
"     as: commit using (script-defined) message file without using the editor.
"     With no arguments, the script should bring up an editor.
"   • If no `commit` script is found, it runs `git commit -v -a`.
"
function! GitCommit(...)
    let l:dir = expand('%:p:h')
    while l:dir != '/'
        let l:commit = l:dir . '/commit'
        if executable(l:commit)
            execute '!' . '"' . l:commit . '"' . ' ' . join(a:000, ' ')
            return
        endif
        let l:dir = fnamemodify(l:dir, ':h')
    endwhile
    execute '!git commit -v -a'
endfunction

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
"   gS      Search for whitespace at EOL (Overrides: `gs` sleep)
"   g/      Search for visually selected text
"   gr      Search for Markdown reference under cursor
"
noremap ge  6<C-E>
noremap gy  6<C-Y>
noremap gS  /\s\+$<CR>
"            yank, start search, insert " register contents
vnoremap g/  y/\V<C-R>"<CR>
"   gr commands: Markdown references under cursor
"       grn: find next use of reference
"       grN: find previous use of reference
"       grp: alias for `grN`; saves a shift keystroke
"       gru: copy URL of reference
"       grl: copy link; alias of `gru`
"       gri: copy in-line reference version of reference ("[…](…)")
"       gro: open URL in browser (with xdg-open)
nnoremap grn :call MarkdownRefLabelSearch('/')<CR>
nnoremap grN :call MarkdownRefLabelSearch('?')<CR>
nnoremap grp :call MarkdownRefLabelSearch('?')<CR>
nnoremap gru :call MarkdownRefDefinitionSearch('url')<CR>
nnoremap grl :call MarkdownRefDefinitionSearch('url')<CR>
nnoremap gri :call MarkdownRefDefinitionSearch('inline')<CR>
nnoremap gro :call MarkdownRefDefinitionSearch('open')<CR>
nnoremap gr  :call ConsumeError('Unknown gr command')<CR>

"   Markdown reference label search.
"   This does not add the pattern to the search history, but instead
"   leaves the reference (with brackets) in register r for later pasting
"   (usually with `Ctrl-R r` in insert mode).
"   `search_command` should be `/` for forward search or `?` for reverse
function! MarkdownRefLabelSearch(search_command)
    "   Select bracketed block around [c[a]b]cursor and yank to register r
    "   The yank must be a separate :normal command in case the select fails.
    normal! va[
    normal! "ry
    "               echom "DEBUG selection len=" . len(@r) . " /" . @r . "/"
    "   If the select failed we are left with a 1-char block.
    if len(@r) == 1
        call DisplayError("Cursor not on a markdown reference")
        return
    endif
    "   Escape slashes in search pattern. Dunno why we need 4× "\" here.
    let l:pat = "\\c\\V" . substitute(@r, "/", "\\\\/", "g")
    "               echom "DEBUG pat /" . l:pat . "/"
    "  Set our last search pattern so that n and p commands can be used.
    let @/ = l:pat
    "               echom 'DEBUG search_command = ' . a:search_command
    "   Move from current position at start of this reference to the next
    "   or previous instance of it.
    call feedkeys(a:search_command . "\n", 'n')
endfunction

"   Markdown reference definition search, copying URL or inline reference.
"   As above, but finds only the definition, leaves the cursor on
"   the start of the URL after the label, and copies the URL to the
"   system clipboard. (Or inline def, with the right param.)
"   This does _not_ set the search pattern, so that `n` will continue
"   to search for what was previously found; we expect that there will
"   be only one definition so destroying `n` is not helpful.
"   XXX Lots of duplicate code that needs to be refactored out.
function! MarkdownRefDefinitionSearch(copy)
    "   Select bracketed block around [c[a]b]cursor and yank to register r
    "   The yank must be a separate :normal command in case the select fails.
    normal! va[
    normal! "ry
    "                   echo "DEBUG selection len=" . len(@r) . " /" . @r . "/"
    "   If the select failed we are left with a 1-char block.
    if len(@r) == 1
        call DisplayError("Cursor not on a markdown reference")
        return
    endif
    "   Escape slashes in search pattern. Dunno why we need 4× "\" here.
    let l:pat = "\\c\\V" . substitute(@r, "/", "\\\\/", "g")
    "   Extend pattern to include line start, trailing colon and any whitespace
    let l:pat = '^' . l:pat . ":\\s\\*"
    "                   echo "DEBUG pat /" . l:pat . "/"
    "   Search for it, not affecting user's searches.
    "   We move one char to the right afterwards (if possible) to move
    "   the cursor past the trailing whitespace to the start of the URL.
    "   XXX should have error handling here to indicate no definition.
    let l:line = search(l:pat, "e")
    "                   echo "DEBUG line " . l:line
    if l:line == 0
        call DisplayError("Definition not found: " . l:pat)
        return
    endif

    "                   echom "DEBUG copy arg " . a:copy
    if a:copy == 'url' || a:copy == 'open'
        normal! l
        normal! "+y$
        execute "normal \<c-O>"
    elseif a:copy == 'inline'
        "   Move to start of line. Copy bracketed ref. Skip to URL.
        "   Append it with parens to + buffer.
        normal! 0
        keepjumps normal! "+y%
        keepjumps normal! %W
        let @+ = @+ . '(' . getline(".")[col(".") - 1:] . ')'
        execute "normal \<c-O>"
    else
        call DisplayError("MarkdownRefDefinitionSearch: bad copy arg " . a:copy)
        return
    endif

    if a:copy == 'open'
        "   This unfortunately hides errors. The stdout redirect is unrelated
        "   to that; it just suppresses the "Opening in existing browser
        "   session" message that appears in the background shortly after
        "   xdg-open exits.
        execute ":silent !xdg-open >/dev/null '" .. getreg('') .. "'"
        "   :silent skips the Press Enter prompt, but messes up the screen.
        redraw!
    endif

    "   Need a redraw *before* we echo anything, maybe because of all the
    "   cursor movement above, otherwise what we echo won't display even
    "   with a redraw afterwards.
    redraw
    let l:s = "Copied: " . @+
    if strchars(l:s) < 80
        echo l:s
    else
        "   Avoid wrapping in 80 column terminal, which will prompt for ENTER
        echo strcharpart(l:s, 0, 76) . "..."
    endif
endfunction

" ----------------------------------------------------------------------

"   We use virtual replace mode in place of standard replace mode
"   because we typically don't want spacing to change just because
"   we're using the tab key (or editing files with tabs).
noremap R gR

" copy and paste with GUI system clipboard(s)
set clipboard=
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
map gcb :'b,.yank +<CR>
map gcA :1,$yank +<CR>
map gc% %"+y%
map gcv "+p
map gcp "+p
map gcP "+P
" "Paste into input mode" for local buffer
map gci :setlocal invpaste paste?<CR>

" gu - turn off search highlighting (like less(1) ESC-u)
map gu :nohlsearch<CR>

"   Help us unlearn deprecated mappings
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
set textwidth=75
"   See `gt` mappings for changing textwidth.

"-----------------------------------------------------------------------
" General commands

" ===== g commands

" g[67] - insert separation comment
map g7 O<ESC>70i-<ESC>0
map g& O<ESC>75i-<ESC>0
map g6 O<ESC>68A#<ESC>0
noremap g! O<ESC>A<!--<ESC>64A-<ESC>A--><ESC>


" ga - autoindent
" gA - show ASCII/Unicode value of char under cursor
map     ga   :setlocal invai<CR>:setlocal ai?<CR>
noremap gA   ga

" gb - byte/word/line count
" vim uses g^G
map gb g<C-G>

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
noremap gtE   :set noexpandtab<CR>
noremap gts   :set shiftwidth=
noremap gt2   :set shiftwidth=2<CR>
noremap gt4   :set shiftwidth=4<CR>
noremap gt8   :set shiftwidth=8<CR>

noremap gtw   :setlocal textwidth=
noremap gt0   :setlocal textwidth=0<CR>
noremap gt5   :setlocal textwidth=50<CR>
noremap gt%   :setlocal textwidth=55<CR>
noremap gt6   :setlocal textwidth=60<CR>
noremap gt^   :setlocal textwidth=65<CR>
noremap gt7   :setlocal textwidth=70<CR>
noremap gt&   :setlocal textwidth=75<CR>
noremap gt8   :setlocal textwidth=79<CR>
noremap gt*   :setlocal textwidth=80<CR>

noremap gtv   :setlocal virtualedit=<CR>
noremap gtV   :setlocal virtualedit=all<CR>

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
" retain access to "move (count) forward in jump list" by making it ^I^I
noremap <TAB><TAB>  <TAB>
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
abbr cooperation coöperation

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
    "   Ensure that display of the message is not suppressed because we
    "   have buffered output requests that have not yet been displayed.
    redraw
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
" (Ctrl-K space CHAR enters CHAR with high bit set.)

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
"        .P 8901    " ·  U+22c5 Dot Operator                        built in
"        .M  183    " ·  U+00b7 Middle Dot (interpunct)             built in
"        0M 9679    " ●  U+25cf Black Circle (not in some fonts)    built in
digraph  oo 8226    " •  U+2022 Bullet (built in in Vim ≥8.2)
"
digraph  xx  215    " ×  Multiplication Sign
digraph  BC 9587    " ╳　Box Drawing Light Diagonal Cross
digraph  !@ 8214    " ‖  Double vertical line (duplicates !2 digraph)
digraph  dS 7496    " ᵈ  Latin Superscript Small Letter D
digraph  hS 0688    " ʰ  Latin Superscript Small Letter H
digraph  iS 8305    " ⁱ  Latin Superscript Small Letter I
digraph  nS 8319    " ⁿ  Latin Superscript Small Letter N
digraph  oS 7506    " ᵒ  Latin Superscript Small Letter O
digraph  is 7522    " ᵢ  Latin Subscript Small Letter I
digraph \|> 8614    " ↦  Rightwards Arrow From Bar (maplet, \mapsto)
digraph  ns 8345    " ₙ  Latin Subscript Small Letter N
digraph  xs 8339    " ₓ  Latin Subscript Small Letter X
digraph  -^ 8593    " ↑  Upwards Arrow (alternative to -!)
digraph \|- 8866    " ⊢  Right Tack (turnstyle)
digraph -\| 8867    " ⊣  Left Tack
digraph  -T 8868    " ⊤  Down Tack
digraph  -t 8869    " ⊥  Up Tack
digraph \|= 8872    " ⊨  True (double turnstile)
digraph  <m 10216   " ⟨  Mathematical Left Angle Bracket
digraph  >m 10217   " ⟩  Mathematical Right Angle Bracket
digraph  cl 8452    " ℄ Centre Line Symbol
digraph  CR 8629    " ↵  Keyboard Enter or carriage return key symbol
digraph  cm 8984    " ⌘  Place of Interest Sign (Mac Command Key)
digraph  om 8997    " ⌥  Option Key (Mac)
digraph  '/  773    " a̅  Combining Overbar (like / for "active low")
digraph  0+ 8853    " ْْࣷ⊕  Circled Plus Operator (overrides Arabic Sukun)
digraph  D0 8960    " ⌀  Diameter Sign
digraph  XO 8891    " ⊻  XOR
digraph  XR 8891    " ⊻  XOR
digraph  NA 8892    " ⊼  NAND
digraph  NR 8893    " ⊽  NOR
digraph  ** 0981    " ϕ  U+03D5 Greek Phi Symbol (φ for math/sci contexts)
                    "    `f%` would make more sense, but harder to type.
digraph  DC 9107    " ⎓  Direct Current Symbol Form Two

"   e[a-z]: electronics (overrides some Bopomofo)
digraph ep 9101   " ⎍ "pulse" Monostable Symbol
digraph eh 9102   " ⎎ Hysteresis Symbol
digraph eg 9178   " ⏚ Electronic/Earth Ground 

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
if !has('win32')
    set shell=bash-rcc
else
    set shell=bash\ -i
endif
