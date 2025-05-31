"   cjs reconfigurations based on file type
"
"   Note that this should _not_ be named `filetype.vim` because that's
"   a standard Vim file. (And possibly we should be calling that?)

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

"   XXX This should be in a syntax/ directory, no?
autocmd! BufNewFile,BufReadPre,FileReadPre  *.hs    so ~/.home/cjs0/vim/haskell.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.hsc   so ~/.home/cjs0/vim/haskell.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.cabal so ~/.home/cjs0/vim/haskell.vim
autocmd! BufNewFile,BufReadPre,FileReadPre  *.erl   so ~/.home/cjs0/vim/haskell.vim

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
    "   Note that we do _not_ change isident because that affects the
    "   way that vim expands environment variables. If you're searching
    "   for identifiers where `-` is a legal char, you'll just need to
    "   use `\k` instead of `\i`.
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

