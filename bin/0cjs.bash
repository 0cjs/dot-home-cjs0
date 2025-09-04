#   `source` this file

#   TODO:
#   • Use ~cjs/.home/cjs0/ if $HOME/.home/cjs0/ does not exist.
#     (Ensure we can read it first!)
#   • Do not auto-clone w/__cjs0_dhrepo() if ~cjs/ repo exists?
#   • Once the above is done, remove the warning and abort option.

####################################################################
#   Utility functions and aliases

#   Bash will generate an error if you define a function of the same name
#   as an existing alias, so we need to ensure those aliases do not exist.
#   Further, the unalias command must not happen on the same line, as later
#   in that line the alias will already have been substituted.
_u() { unalias "$@" >/dev/null 2>&1 || true; }

__cjs0_checkexist() {
    [[ -e $1 ]] && return 0
    echo 1>&2 "WARNING: $1 not found"
    return 1
}

__cjs0_dhrepo() {
    [[ -d $1 ]] && return 0
    echo 1>&2 "NOTE: cloning $1 from GitHub $2"
    git clone -q "https://github.com/$2.git" "$1"
}

####################################################################
#   Setup and sourcing of dot-home, gitcmd-abbrev, cjs0

[[ -d ~/.home/ ]] || {
    echo -n "\
You are not using dot-home. This will create a ~/.home/ directory and clone
some public dot-home modules into it; this will *not* affect your user
configuration in any way. Enter 'y' to proceed, anything else to exit: "
    read __0cjs_bash_y
    echo $__0cjs_bash_y
    case "$__0cjs_bash_y" in
        y|Y)    unset __0cjs_bash_y
                ;;
        *)      unset __0cjs_bash_y
                echo "Aborting."
                return 0
                ;;
    esac
}

#   Ensure we have all repos, to make initial setup easy. We check/clone even
#   .home/cjs0 because this 0cjs.bashrc may be running from elsewhere.
mkdir -p ~/.home
__cjs0_dhrepo  ~/.home/dot-home/        dot-home/dot-home
__cjs0_dhrepo  ~/.home/cjs0/            0cjs/dot-home-cjs0
__cjs0_dhrepo  ~/.home/gitcmd-abbrev/   dot-home/gitcmd-abbrev

source ~/.home/dot-home/dot/bashrc.inb1     # for prepath()

if [[ -z $ZSH_VERSION ]]; then
    bind -f ~/.home/cjs0/inputrc    # vi bindings, etc.
else
    #   ZSH does not support `bind` or even use readline, apparently.
    #   This quick hack does a bit of what my inputrc does.
    bindkey -v
    bindkey '^R' history-incremental-search-backward
fi
for i in ~/.home/cjs0/dot/bashrc.*; do source "$i"; done
export EDITOR=~/.home/cjs0/bin/vi; unset VISUAL
#   If in a tmate session, reconfig for C-a prefix etc.
[[ -n ${TMUX:-} ]] && ~/.home/cjs0/bin/tmaconf
echo "Current TERM=$TERM"
eval $(tset -I -s '?rxvt-unicode-256color')

source ~/.home/gitcmd-abbrev/bin/gitcmd-abbrev.bash
st() { ~/.home/gitcmd-abbrev/bin/st "$@"; }

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

#   These do not disable colour, though perhaps they should since dark
#   vs. light backgrounds can cause issues.
_u lf lfa ll lla llt llth
lf()            { command ls -FC "$@"; }       # also configured by cjs0
lfa()           { lf -a "$@"; }
ll()            { command ls -lh "$@"; }
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
