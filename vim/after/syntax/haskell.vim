"   The semantics of Haskell syntax highlighting supplied with Vim are,
"   well, odd at best. Why is `data` Structure but `type` and `newtype`
"   Typedef? Fortunately this doesn't affect me much because I use text
"   colours other than the standard foreground/background for very few
"   things, so I don't see the odd choices.

"   In addition the usual stuff in my standard colors/cjs.vim (basically,
"   comments in grey and constants in blue), I want `where` to be
"   highlighted because the best location for it varies depending on the
"   code. The default config vim90/syntax/haskell.vim sets:
"       syn keyword hsStructure class data deriving instance default where
"       hi def link hsStructure Structure
"   (See above re ridiculous Structure vs. Typedef thing.)
"   To do this I create a new syn keyword and map it to Special, which is
"   otherwise used only for hsLabel:
"       hi def link hsLabel Special
"       syn match hsLabel "#[a-z][a-zA-Z0-9_']*\>"
"   and I will turn off the hsLabel link if it gets annoying.
"
syn keyword hsWhere where
hi def link hsWhere Special
highlight Special ctermfg=DarkGreen
