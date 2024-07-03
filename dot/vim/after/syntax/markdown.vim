"   This was developed to modify /usr/share/vim/vim80/syntax/markdown.vim
"   as seen in Ubuntu 18.04 Vim 8.0.

"   The standard syntax/markdown.vim has a bug in that it treats anything
"   indented by 4+ spaces or 1+ tabs as a code block, even if it's a
"   continuation of a list item (that is third or deeper level).

"   This patch seems to fix the problem completely.
"   From @padawin, https://github.com/tpope/vim-markdown/pull/140
"
"   XXX this is disabled for the moment because it fails on blocks like
"   the following, and that's even more annoying than the original bug.
"
"       foo
"       ```python
"       some code
"       ```
"       foo
"
"syntax clear markdownCodeBlock
"syn region markdownCodeBlock start="\n\(    \|\t\)" end="\v^((\t|\s{4})@!|$)" contained

"   In case we still have issues, we still have this older hack:
"   This allows us to hack this by disabling code block regions, which
"   means they won't get highlighted as code (and worse, will have internal
"   markup highlighted), but lets continuation lines be displayed properly.
noremap ghm :syntax clear markdownCodeBlock<CR>
