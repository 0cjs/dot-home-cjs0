#   Simpler functions etc. that I sometimes want to source alone
#   when I'm a guest in someone else's environment.

#   _u() comes from .home/cjs0/dot/bashrc.inb1

#   Blank lines make following text easier to find in terminal scrollback.
_u sp
sp() { local i=0; while [ $i -lt ${1:-5} ]; do echo; i=$(($i+1)); done; }

_u lf lfa ll lla llt llth
lf()            { ls -CF "$@"; }       # also configured by cjs0
lfg()           { lf --group-directories-first "$@"; }
lfa()           { lf -a "$@"; }
ll()            { ls -lh "$@"; }
lla()           { ll -a "$@"; }
llt() {
    #   XXX should check if we don't have --time-style (non-Gnu ls)
    local ts='%Y-%m-%d %H:%M:%S'
    ll -t --time-style="+$ts" "$@"
}
llth()          { llt "$@" | head; }

#   Given a path, echo the relative path to it from $2, which defaults to
#   CWD if not supplied. (Python's os.path.relpath, essentially.)
_u relpath
relpath() {     # Change abs path $1 to path relative to CWD, if under CWD.
    [[ $# -eq 1 ]] || [[ $# -eq 2 ]] || {
        echo 1>&2 "Usage: relpath TARGET-PATH [FROM-PATH]"; return 2; }
    local target_path="$1"
    local from_path="${2:-$PWD}"
    local cwd
    #   We match both the path as-is and the path with all symlinks resolved.
    for cwd in "$from_path" $(command cd "$from_path" 2>&1 && pwd -P); do
        [[ -n $cwd ]]       || continue
        [[ $1 = $cwd/* ]]   || continue
        echo "${1/$cwd\//}";
        return 0
    done
    echo "$1"
}

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

#   Run commands in a list of preset alternate directories.
#__cjs0_ad_dir=()   # XXX Don't override existing value, but fails with set -e?
_u adset ad
adset() {   # Set alternate directory list for `ad` command.
    declare -ga __cjs0_ad_dir
    local dir
    if [[ $# == 0 ]]; then
        for dir in "${__cjs0_ad_dir[@]}"; do
            echo "$dir"
        done
    else
        __cjs0_ad_dir=()
        for dir in "$@"; do
            __cjs0_ad_dir+=("$(command cd $dir && command pwd -P)")
        done
    fi
}
ad()   {   # Run provided command in each directory specified with `ads`.
    #   XXX Command-line completion for this should use "start of line"
    #   completion for first arg, the alternate dir's files for filename
    #   completion, etc.
    declare -ga __cjs0_ad_dir
    for dir in "${__cjs0_ad_dir[@]}"; do
        echo "━━━━━━━━━━ [ $(relpath "$dir") ]"
        ( command cd "$dir"; "$@" )
    done
}
