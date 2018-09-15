"   cjs Minimum configuration - the things I really can't live without
"
"   This includes commands that are embedded in my muscle memory.
"
"   This is designed to be minimally intrusive, overriding default
"   commands that are unassigned or not useful, so that other vim
"   configurations can bring this in without noticing much, if any,
"   change.

"   s/S - save current/save all (in this section for lack of better place)
"   Overrides: s/S as duplicates of cl/cc
noremap s :w<CR>
noremap S :wa<CR>
