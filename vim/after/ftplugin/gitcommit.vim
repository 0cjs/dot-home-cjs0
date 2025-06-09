"   Overrides of /usr/share/vim/vim90/ftplugin/gitcommit.vim.

"   Add '•' to list of chars that start a bullet list item for `gq` formatting.
setlocal formatlistpat+=\\\|^\\s*[-*+•]\\s\\+

"   XXX This is copied straight from the standard gitcommit.vim, but just
"   as it has no effect there, it has no effect here. Something in my
"   config is overriding this to textwidth=75, and we need to figure out
"   how to undo that.
setlocal textwidth=72
