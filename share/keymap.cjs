#   Linux console keymaps(5) entries for cjs.
#   Load with:
#       sudo loadkeys ~/.local/share/keymap.cjs
#   Restore defaults with one of:
#       sudo loadkeys -d
#       sudo loadkeys /etc/console-setup/cached_UTF-8_del.kmap.gz

#   When only one binding is given for `keycode n = ...`, assign
#   that in all maps. (Pretty much required for modifier keys.)
keymaps 0-127

#   Replace caps lock with modifier Control. We do not change left control
#   (or any other key) to be caps lock so that other users are minimally
#   inconvenienced; the loss of caps lock isn't such a big deal.
keycode   58 = Control

#   Swap `/~ and Esc.
# XXX this is more difficult because we need to figure out how to reduce
# the shedload of modifier mappings for each to something reasonably concise.

#   Debian kernel defaults for reference:
#keymaps 0-127
#keycode  58 = CtrlL_Lock   # Caps Lock key
#keycode  29 = Control      # left Ctrl key
#keycode  97 = Control      # right Ctrl key
