"   This was developed to modify /usr/share/vim/vim80/syntax/markdown.vim
"   as seen in Ubuntu 18.04 Vim 8.0.

"   The standard syntax/markdown.vim has a bug in that it treats anything
"   indented by 4+ spaces or 1+ tabs as a code block, even if it's a
"   continuation of a list item (that is third or deeper level).
"
"   This allows us to hack this by disabling code block regions, which
"   means they won't get highlighted as code (and worse, will have internal
"   markup highlighted), but lets continuation lines be displayed properly.
noremap ghm :syntax clear markdownCodeBlock<CR>

" ----------------------------------------------------------------------
" And here are other attempts to fix this that didn't work.

"   This doesn't work; it doesn't enable bold/italic/etc. in the region.
"highlight link markdownCodeBlock NONE

"   And this, I ccan't recall the issue with it.
"highlight default link markdownCodeBlock String

