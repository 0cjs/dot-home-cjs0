#   `source` this file

set -o vi
[[ -n ${TMUX:-} ]] && tmaconf   # reconfig tmate if we're in a tmate session

####################################################################
#   Basic aliases and functions

#   Bash will generate an error if you define a function of the same name
#   as an existing alias, so we need to ensure those aliases do not exist.
#   Further, the unalias command must not happen on the same line, as later
#   in that line the alias will already have been substituted.
_u() { unalias "$@" >/dev/null 2>&1 || true; }

source ~/.home/dot-home/dot/bashrc.inb1     # for prepath()
for i in ~/.home/{cjs0,gitcmd-abbrev}/dot/bashrc.*; do
    source "$i"
done
st() { ~/.home/gitcmd-abbrev/bin/st "$@"; }

#   XXX should be replaced by multi-config vim wrapper
source ~/.home/cjs0/dot/vim/cjs

####################################################################
#   From ~/.home/cjs1 files, so we don't need to clone it.
#
#   Simpler functions etc. that I sometimes want to source alone
#   when I'm a guest in someone else's environment.

#   If less(1) is using default options, stop it from switching to alt screen.
[[ -n $LESS ]] || export LESS='-aeFimsXR -j.15'

#   Blank lines make following text easier to find in terminal scrollback.
_u sp
sp() { local i=0; while [ $i -lt ${1:-5} ]; do echo; i=$(($i+1)); done; }

_u lf lfa ll lla llt llth
lf()            { ls -CF "$@"; }       # also configured by cjs0
lfa()           { lf -a "$@"; }
ll()            { ls -lh "$@"; }
lla()           { ll -a "$@"; }
llt()           { ll -t "$@"; }
llth()          { ll -t "$@" | head; }

_u mdcd
mdcd() {
    [[ ${#@} -eq 1 ]] || { echo 1>&2 "Usage: mdcd PATH"; return 2; }
    mkdir -p "$1" && cd "$1"
}

_u findf
findf() {
    [ -z "$1" ] && {
        echo 1>&2 "Usage: findf DIR ... [NAME-FRAGMENT [FIND-OPS ...]]"
        return 2;
    }
    local roots=() namefrag
    #   -d is true for symlinks to dirs as well as directories.
    while [[ -d "$1" ]]; do roots+=("$1"); shift; done
    local name_frag="$1"; shift
    [[ -z $name_frag && ${#roots[@]} -gt 1 ]] \
        && { echo 1>&2 "Warning: last arg is a dir, not name-frag"; sleep 1; }
    [[ $name_frag == -- ]] && { name_frag="$1"; shift; }
    local predicate=-iname
    [[ $name_frag =~ / ]] && predicate=-ipath
    find -L "${roots[@]}" -type f $predicate "*$name_frag*" "$@" 2>/dev/null
}
