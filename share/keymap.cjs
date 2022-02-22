#   Linux console keymaps(5) entries for cjs.
#   Load with:
#       sudo loadkeys ~/.local/share/keymap.cjs
#   Restore defaults with one of:
#       sudo loadkeys -d
#       sudo loadkeys /etc/console-setup/cached_UTF-8_del.kmap.gz

####################################################################
#   Replace caps lock with modifier Control. We do not change left control
#   (or any other key) to be caps lock so that other users are minimally
#   inconvenienced; the loss of caps lock isn't such a big deal.
#
#   This is assigned in all maps so that key-up to turn off the modifier
#   works no matter which map (perhaps in combination with other modifier
#   keys) this has brought us to.
#
keymaps 0-127
keycode   58 = Control

####################################################################
#   Swap `/~ and Esc.
#
#   The original layout has all 64 of the modifier combinations that
#   include `alt` mapped to Meta_Escape. To save space here we replicate
#   Esc to all versions of the key and then just tweak a handful of the
#   most important modifiers.
#
#   XXX The `CtrlR` versions produce an error `adding map 136 violates
#   explicit keymaps line`; it turns out the default keymaps never use
#   CtrlR. Not sure what's up with this, but I'm following along.
#
keymaps 0-127
keycode  41 = Escape
    Alt               keycode  41 = Meta_Escape
    Alt         Shift keycode  41 = Meta_Escape
    Alt Control       keycode  41 = Meta_Escape
    Alt CtrlL         keycode  41 = Meta_Escape
#   Alt CtrlR         keycode  41 = Meta_Escape
    Alt Control Shift keycode  41 = Meta_Escape
    Alt CtrlL   Shift keycode  41 = Meta_Escape
#   Alt CtrlR   Shift keycode  41 = Meta_Escape
#
#   The original layout has well over a hundred mappings for the various
#   modified versions, most of which are redundant to allow pressing extra
#   keys (e.g., making AltGr-Meta work the same as Meta), and some of which
#   seem to be to give Control-circumflex/caret combinations for some
#   reason. We pare this down to a minimal set of the first two columns
#   plus a few important modifier columns.
#
keymaps 0-127
keycode   1 = grave asciitilde
        Control       keycode   1 = nul
        Control Shift keycode   1 = nul
    Alt               keycode   1 = Meta_grave
    Alt         Shift keycode   1 = Meta_asciitilde
    Alt Control       keycode   1 = Meta_nul
    Alt Control Shift keycode   1 = Meta_nul

#   Debian kernel defaults for reference:
#keymaps 0-127
#keycode  58 = CtrlL_Lock   # Caps Lock key
#keycode  29 = Control      # left Ctrl key
#keycode  97 = Control      # right Ctrl key
