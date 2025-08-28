"   XTerm 256 colour palette:
"   • table: https://robotmoon.com/256-colors/ 
"   • w/RGB: https://www.ditig.com/256-colors-cheat-sheet
"   • alternate text db RGB source: https://github.com/linrock/256-colors 

"   XXX (The following no longer applies now that I have my own color scheme?)
"   This doesn't do what I want; it ends up overriding my color scheme. I
"   think I need to set up a separate, proper color scheme somehow. For the
"   moment, I need to `:syntax off` and `:syntax on` again to get my
"   colors for the 2nd and subsequent files in arge.

"   Testing:
"   • Open two+ terminals, one `TERM=xterm` and others `TERM=*-256color`.
"     Each should have the test file opened with `:set autoread`.
"   • Load file, or :source $VIMRUNTIME/syntax/colortest.vim
"   • Save this config file and `qz` in test terminals.

highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = 'cjs'

" Available ctermfg colors, in DarkFoo and LightFoo versions:
"     Black Blue Green Cyan Red Magenta Yellow Grey White
" See them with `:runtime syntax/colortest.vim`
" Color notes:
"   • Using reverse not only swaps fg/bg colors, but will swap them
"     for overlapping highlights. E.g., Visual highlight fg/bg will be
"     swapped when over a Search area. (We actually don't want this,
"     but leave it until we can think of a better example.)
"   • But WARNING: some terminals (DOS console) cannot have both a
"     cterm and a ctermfg/bg setting.
"   • (Light) Cyan on DarkBlue works great in 256C, but is barely passible
"     in 16C. But very much stands out.


" ----------------------------------------------------------------------"
"  RGB color specification support.
"  This seemed like a good idea originally, but it turns out to be much
"  easier to select directly from the XTerm 256 colour palette above.
"
"   "Import" RgbHighlight and RgbTo256.
source <sfile>:h/rgb256.vim
function! s:C(rgb_color)
    return RgbTo256(a:rgb_color)
endfunction
"echo 'C='.s:C('#FFFFE0') " lightyellow
function! s:hi(...)
    call call('RgbHighlight', a:000)
endfunction

" ----------------------------------------------------------------------
"   If we're in a tmate session, we're probably sharing this terminal
"   with people who are using terminals defaulting to light text on
"   a dark background, which can make my highlighting unreadable. To
"   fix this, we set 'Normal' highlighting to force the Vim session to
"   dark text on a light background.
"
"   Curiously, color 231 is closer to white than 15 (which is very grey,
"   though it's apparently supposed to be white). 230 is a little darker
"   than my standard #ffffe8 and even my old 'lightyellow' #ffffe0, but I
"   don't see any obvious way to fix that.
"
if stridx($TMUX, '/tmate-') != -1
    if &t_Co > 16
        hi Normal   ctermfg=Black   ctermbg=230
    else
        hi Normal   ctermfg=Black   ctermbg=White
    endif
    "   Disable the terminal's background color erase capability because
    "   we want Vim to explicitly set even cells that have no characters
    "   in them to our Normal background color.
    set t_ut=
endif

" ----------------------------------------------------------------------
"   New 256-color scheme.
if &t_Co > 16

"   Editing
"   Blueish opts for search: 195=v.light, 123, 153, 159
hi Search       cterm=NONE      ctermfg=Black   ctermbg=195
hi Visual       cterm=NONE      ctermfg=Black   ctermbg=82
hi ColorColumn                                  ctermbg=222
hi NonText                      ctermfg=166
hi Pmenu                        ctermfg=4       ctermbg=255
hi PmenuSel     cterm=reverse   ctermfg=4       ctermbg=255

"   Syntax Highlighting
hi Comment                      ctermfg=244

" ----------------------------------------------------------------------
"   Old 8/16-color scheme. This probably will not work well because it was
"   designed for a terminal with custom color settings for some of the
"   16 colors. If we spend much time working on 16-color terminals again,
"   this should be tweaked to work better with the standard 16 colors.
else

"   Editing
hi Search       cterm=NONE          ctermfg=Black       ctermbg=White
hi Visual       cterm=NONE          ctermfg=Black       ctermbg=LightGreen
hi ColorColumn                                          ctermbg=LightMagenta
hi NonText                          ctermfg=DarkGray
hi Pmenu                            ctermfg=4           ctermbg=NONE
hi PmenuSel     cterm=reverse       ctermfg=4           ctermbg=NONE

"   Syntax Highlighting
if &t_Co > 8
    let g:highlight_grey = "DarkGrey"
else
    let g:highlight_grey = "Grey"
endif
execute 'highlight Comment ctermfg=' . g:highlight_grey

" ----------------------------------------------------------------------
"   Common colours for all schemes, all from the 8-color palette.
endif

"   Syntax Highlighting
hi Underlined               ctermfg=Black " Remove magenta on underlined text.
hi Constant                     ctermfg=DarkBlue
hi Special                      ctermfg=Black
hi Identifier                   ctermfg=DarkBlue
hi Statement                    ctermfg=Black
hi PreProc                      ctermfg=Black
hi Type                         ctermfg=Black
hi Title        cterm=bold      ctermfg=Blue
hi Subtitle                     ctermfg=Blue
hi Error        term=reverse    ctermfg=Black ctermbg=Red

"   Diffs
highlight diffAdded     ctermfg=DarkBlue
highlight diffRemoved   ctermfg=DarkRed
highlight diffFile      ctermfg=DarkGreen
highlight diffLine      ctermfg=DarkYellow

"   Git commit messages
highlight gitcommitComment ctermfg=Grey
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

"   Markdown
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

"   Spelling
highlight SpellBad      ctermfg=DarkRed ctermbg=none
highlight SpellCap      ctermfg=none ctermbg=none
highlight SpellRare     ctermfg=none ctermbg=none
highlight SpellLocal    ctermfg=none ctermbg=none

