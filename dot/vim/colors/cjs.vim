highlight clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = 'cjs'

"   Testing:
"   ??? Open two+ terminals, one `TERM=xterm` and others `TERM=*-256color`.
"     Each should have the test file opened with `:set autoread`.
"   ??? Save this config file and `qz` in test terminals.

" Available ctermfg colors, in DarkFoo and LightFoo versions:
"     Black Blue Green Cyan Red Magenta Yellow Grey White
" See them with `:runtime syntax/colortest.vim`
"
"   XXX This doesn't do what I want; it ends up overriding my color scheme.
"   I think I need to set up a separate, proper color scheme somehow.
"   For the moment, I need to `:syntax off` and `:syntax on` again to
"   get my colours for the 2nd and subsequent files in arge.
"   XXX Above no longer applies?


" Editing.
"   • Using reverse not only swaps fg/bg colours, but will swap them
"     for overlapping highlights. E.g., Visual highlight fg/bg will be
"     swapped when over a Search area. (We actually don't want this,
"     but leave it until we can think of a better example.)
"   • But WARNING: some terminals (DOS console) cannot have both a
"     cterm and a ctermfg/bg setting.
"
"   (Light) Cyan on DarkBlue works great in 256C, but is barely passible
"   in 16C. Not much we can do about this; there are are no good dark
"   on DarkBlue combinations, and dark on Black is hardly better.
hi Search       cterm=bold,reverse  ctermfg=DarkBlue    ctermbg=Cyan
hi Visual       cterm=NONE          ctermfg=Black       ctermbg=LightGreen
hi ColorColumn                                          ctermbg=LightYellow
hi NonText                          ctermfg=DarkGray
hi Pmenu                            ctermfg=4           ctermbg=NONE
hi PmenuSel     cterm=reverse       ctermfg=4           ctermbg=NONE

" syntax
if &t_Co > 8
    let g:highlight_grey = "DarkGrey"
else
    let g:highlight_grey = "Grey"
endif
execute 'highlight Comment ctermfg=' . g:highlight_grey
highlight Underlined ctermfg=Black      " Remove magenta on Underlined text
highlight Constant ctermfg=DarkBlue
highlight Special ctermfg=Black
highlight Identifier ctermfg=DarkBlue
highlight Statement ctermfg=Black
highlight PreProc ctermfg=Black
highlight Type ctermfg=Black
highlight Title ctermfg=Blue cterm=bold
highlight Subtitle ctermfg=Blue
highlight Error term=reverse ctermfg=Black ctermbg=Red

" diffs
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

