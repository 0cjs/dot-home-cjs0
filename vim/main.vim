" ===== cjs vim configuration =========================================
"
"   This is a completely separate configuration from the standard ~/.vimrc
"   and is expected to be run with -u from the bin/vi script in this
"   directory. This configuration avoids using ~/.vimrc, /etc/vimrc or any
"   other user- or system-local configuration, but does use the $VIMRUNTIME
"   supplied with Vim.

" ===== env vars pointing to configuration  ===========================

"   $MYVIMRC is automatically set by Vim on startup when it searches for a
"   vimrc file (see `:help iniitialization`). It is not set when the -u
"   option is supplied, which this is expected to be run with; our `bin/vi`
"   file sets $MYVIMRC in the environment and this inherits it.

"   $VIMRUNTIME (`:help $VIMRUNTIME`) uses the env var, if set, or
"   $VIM/vim{version} if it exists, or $VIM/runtime, or (for backwards
"   compatibility) $VIM, or `helpfile` with doc/help.txt removed from the
"   end. We keep this; it points to the standard config that comes with Vim
"   itself. (It's caclulated using the default $VIM value from before set
"   set it below.

"   $VIM is not entirely clear; on non-Unix systems this is used to find
"   the user vimrc (`:help startup`), but on Unix systems it seems to fall
"   back to /usr/share/vim/ if it was not specified in the environment
"   (`:help $VIM`). But on Debian that contains stuff from extra
"   'expansion' packages that are not part of standard Vim, so we set this
"   to our own configuration dir.
let $VIM=fnamemodify($MYVIMRC,':h')

" ===== 'runtimepath' =================================================

"   Even with  `-u rcfile`, Vim will still set a default runtimepath that
"   includes $HOME/.vim and the like.
"
"   The documented (standard) default is:
"     $HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
"   We use this, replacing $HOME with our config.
"
"   Debian overrides this to:
"     $HOME/.vim,/var/lib/vim/addons,/etc/vim,/usr/share/vim/vimfiles,
"     /usr/share/vim/vim90,/usr/share/vim/vimfiles/after,/etc/vim/after,
"     /var/lib/vim/addons/after,$HOME/.vim/after
"   We ignore the extra stuff Debian adds (/usr/share/vim/vimfiles for
"   Debian-supplied packages like 'vim-scripts' and, apparently, sysadmin-
"   suplied things in /var/lib/vim/addons), as we do with any other
"   distribution-supplied config.
"
"echo "old runtimepath=".&runtimepath
set runtimepath=$VIM,$VIMRUNTIME,$VIM/after

"echo 'old packpath='.&packpath
"   Vim by default adds user package paths (~/.vim/ etc.) to packpath:
"   remove these from our configuration. We keep the system-supplied paths
"   (/usr/share/vim/vimfiles etc.) because when we later execute the system
"   setup `runtime! defaults.vim` that may expect to be able to load
"   packages. (We may not want these packages, but it's not curently clear
"   how to ensure we don't load them while still loading all our filetype
"   setup, unless we just do everything ourselves.)
if has('packages')
    let s:pp_parts = filter(split(&packpath, ','), 'v:val !~ "^" . expand("~")')
    let &packpath = join(s:pp_parts, ',')
    unlet s:pp_parts
endif
"echo 'new packpath='.&packpath

" ===== Startup Debugging =============================================

if getenv('VIMRC_DEBUG') != v:null
    echo '$MYVIMRC='.$MYVIMRC
    echo '$VIM='.$VIM
    echo '$VIMRUNTIME='.$VIMRUNTIME
    echo 'runtimepath='.&runtimepath
    echo 'packpath='.&packpath
endif

"   At this point we're still running just this initial rc file, so running
"   `:scr`/`:scriptnames` above will not show anything useful. But you can
"   use it later, after full startup, to see exactly what got executed.

"   To figure out what lines in this file are causing other files to be
"   sourced, create an empty file named as below, enable this line at any
"   point in this file, and then use :scriptnames or :scr to see where it
"   is shown in the order of scripts that were run.
"source ~/tmp/checkpoint0.vim

" ===== Standard Vim Startup ==========================================
"   Since we invoke vim with `-u`, the standard startup described by
"   `:help initialization` is not done, and we need to replicate that
"   as described there.

"   In particular, point 3.c.V, executing $VIMRUNTIME/defaults.vim,
"   is essential for e.g. filetype setup to work correctly. But note that
"   since we weren't using this properly before, we're now getting *lots*
"   of overrides of our own setting, and may need to add lots of
"   after/ftplugin/*.vim files to restore things.
runtime! defaults.vim

"   The standard Vim config is fine, but Debian (and perhaps other distros)
"   add annoying things that we need to disable.

set mouse=      "   Un-enable mouse in terminal windows.

"   Disable 'You discovered the command-line window!' message.
:augroup vimHints | exe 'au!' | augroup END

" ===== General Notes =================================================

"   We try here to avoid clobbering useful standard key mappings.
"   When considering a new mapping, check `:help index` to see
"   if it's already used.

"   Documentation:
"   ∙ Vim scripting help: :help eval
"   ∙ Vim scripting cheatsheet: https://devhints.io/vimscript

" ===== Settings ======================================================
" XXX This should gracefully degrade, a la
" http://blog.sanctum.geek.nz/gracefully-degrading-vimrc

set nocompatible
:scriptencoding utf-8

set nomodeline
"set secure
runtime cjs/modeline.vim

" ===== File Type Setup ===============================================

runtime autocmd.vim

" ===== Settings from .vim/cjs.d/tiny.vim =============================
"   XXX Possibly this should be reading that file instead.
noremap s       :w<CR>
noremap S       :wa<CR>
noremap <C-S>   :checktime<CR>  " synchronize: reload files saved outside of Vim

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

"   XXX Mysteriously, this does not move to the start of the first line,
"   as `gg`, but several columns into it. (Try it on this file.)
noremap g<C-M>  gg      " kinda parallel to z<C-M>

"   gG - Graphical settings prefix
"   `gg` is easier, but other use this standard 'jump to top' command,
"   and we don't use these GUI commands very much. (But probably we
"   should change this to something more typable anyway.)
noremap gGfn :set guifont=Noto\ Mono\ 8<CR>
noremap gGfi :set guifont=Inconsolata\ Medium\ 9<CR>

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

" ===== 'Q' and 'q' Prefix ====================================================

"   We take over `q` as a prefix for all the stuff in this section.
"   Thus, disable `q` alone or with an unknown char following to avoid
"   accidentally turning on the 'record typed chars to register' mode
"   because sometimes doing that would be very confusing. (It's a
"   lesser-used command that we move elsewhere.)
noremap q       :call ConsumeError("Use `q'` to record to register")<CR>

"   Having done this, we now restore some of the original qX commands.
"     q/ q?     Open search history window
noremap q/      q/
noremap q?      q?

"   We override the following commands:
"   • Q  (enter ex mode): `gQ` is a better version of that
"   • q: (command line history): doesn't save keystrokes over `:^E` and
"     it's better to have macro record there (see below)

"   Recording for repeat (register name follows command)
"     q;    Execute commands in register
"     Q     Repeat last `q;` command <count> times
"     q:    Record to register
"     q"    Edit register
noremap q;      @
noremap Q       @@
noremap q:      q
noremap q"      :call DisplayError("edit register not yet written")<CR>

"   Window create/move commands
"   These tend to follow `q` with a right-hand key.
"
"   q{np}   move/wrap to next/previous window or window given by count
"   q{hjkl} move to window, just like Ctrl-W{hjkl}
"   q{rR}   resize larger/smaller
"   qf      Toggle fixed window vsize (won't change when splitting/closing)
"   qF      Toggle equalways (resizing all windows on new window)
"   qm      Set all windows equal size ('maximize all', of a sort)
"   qM      Maximize this window
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
noremap qM      :resize +999<CR>
"               Careful to preserve current equalalways settings
noremap qm      :setlocal invequalalways\|setlocal invequalalways<CR>
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
noremap qs      :split<CR>
noremap qS      :only<CR>   " close all windows but the current one
noremap qt      :set filetype?<CR>
noremap qT      :set filetype=
noremap qq      :call DisplayError("qq: use `qw` to close window")<CR>
noremap qw      <C-W>c
noremap qX      :!chmod +x '%'<CR>

"   Other window-related commands
noremap qz      :set scrolloff=

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
"   XXX These don't work if the CWD is not in a repo, and while "$(dirname #)"
"   gives a path in the repo, the file path is also taken relative to the
"   repo and is thus wrong, e.g., git diff -C ../gmk/doc doc/github.md.
"   Not sure how to work this out.
noremap qvd :Scratch<CR>:r!git diff #<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvD :Scratch<CR>:r!git diff<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvs :Scratch<CR>:r!git diff --staged #<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvS :Scratch<CR>:r!git diff --staged<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
noremap qvw :Scratch<CR>:r!git diff --word-diff=plain #<CR>:normal gg<CR>:runtime syntax/diff.vim<CR>
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

"   Reload command
noremap qZ      :call CjsReloadConfig()<CR>
if !exists('*CjsReloadConfig')
    "   We can't redefine this when we're reloading becasue we're currently
    "   running the function. So instead we just skip; that means that
    "   changes to this function can't be reloaded by calling it, but
    "   must be done with `source ~/.home/cjs0/vim/main.vim`.
    function CjsReloadConfig()
        let l:main = split(&runtimepath, ',')[0] . '/main.vim'
        echo "RELOAD! from " . l:main
        execute 'source '. l:main
    endfunction
endif


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
"   Ctrl-U gets rid of the auto-inserted :'<,'>, though it's not really nesc.
vnoremap g/  :<C-u>call VisualSelectionSearch()<CR>
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

function! VisualSelectionSearch()
    let [line_start, col_start] = getpos("'<")[1:2]
    let [line_end, col_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0 | return | endif
    let lines[-1] = lines[-1][:col_end - 1]     " trim to selection boundaries
    let lines[0] = lines[0][col_start - 1:]
    let search_text = join(lines, "\n")

    let search_text = escape(search_text, '\')
    let search_text = escape(search_text, '/')
    let @/ = '\V' . search_text                 " very-nomagic search

    call histadd('/', @/)
    set hlsearch
    normal! n
endfunction

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
        "   Ensure that the arg is quoted properly both for Vim (to avoid '#'
        "   and '%' being replaced by by the previous and current filenames)
        "   and for the shell.
        let l:openarg = shellescape(fnameescape(getreg('+')))
        "   This unfortunately hides errors. The stdout redirect is unrelated
        "   to that; it just suppresses the "Opening in existing browser
        "   session" message that appears in the background shortly after
        "   xdg-open exits.
        execute ":silent !xdg-open >/dev/null " .. l:openarg
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
"   -t: text autowrap off, textwidth used only for `gq` formatting
"   -c: comment autowrap off, textwidth used only for `gq` formatting
"   +r: insert comment leader after Enter in insert mode (cancel with Ctrl-U)
"   +o: insert comment leader when opening line (cancel with Ctrl-U)
"   +q: `gq` formats comments preserving leader
"   +n: `gq` formatting recognizes numbered lists or whatever's in `&formatpat`
"   +2: indent of 2nd line of paragraph, not 1st, used for rest.
set formatoptions=roqn2
set textwidth=75
"   See `gt` mappings for changing textwidth.

"-----------------------------------------------------------------------
" General commands

" ===== g commands

"   g[678] - insert separation comment
"   XXX `g8` overrides the show-UTF-8-hex command, and `g*` would override
"   the `*`-without-word-delimiters command. All this stuff should be put
"   under a prefix (`g7` is available), and we also want a way to insert
"   these in insert mode without it popping back to command mode. (Maybe
"   make it a function that checks the current mode on entry, if we can
"   distinguish `^O^I` from 'regular' normal mode?)
"
map g8 O/*<ESC>71a*<ESC>a*/<ESC>
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
runtime cjs/digraphs.vim

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
