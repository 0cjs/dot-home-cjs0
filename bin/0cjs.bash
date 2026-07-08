#   `source` this file

#   TODO:
#   • Use ~cjs/.home/cjs0/ if $HOME/.home/cjs0/ does not exist.
#     (Ensure we can read it first!)
#   • Do not auto-clone w/__cjs0_dhrepo() if ~cjs/ repo exists?
#   • Once the above is done, remove the warning and abort option.

####################################################################
#   Utility functions and aliases

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

source ~/.home/dot-home/dot/bashrc.inb1 # prepath()
source ~/.home/cjs0/dot/bashrc.inb1     # __0iscommand() _u()

if [[ -z $ZSH_VERSION ]]; then
    bind -f ~/.home/cjs0/inputrc    # vi bindings, etc.
else
    #   ZSH does not support `bind` or even use readline, apparently.
    #   This quick hack does a bit of what my inputrc does.
    bindkey -v
    bindkey '^R' history-incremental-search-backward
fi

#   This is strictly necessary only when we've done a fresh dot-home setup,
#   as otherwise these are in the user's ~/.bashrc.
for i in ~/.home/cjs0/dot/bashrc.*; do source "$i"; done

export EDITOR=~/.home/cjs0/bin/vi; unset VISUAL
#   If in a tmate session, reconfig for C-a prefix etc.
[[ -n ${TMUX:-} ]] && ~/.home/cjs0/bin/tmaconf
[[ $TERM = xterm-256color ]] || {
    echo "Current TERM=$TERM"
    eval $(tset -I -s \?xterm-256color)
}

#   Remove common aliases that conflict with gitcmd-abbrev.
_u st0 st9
_u log logs logp logpr logp1 slp1 logb logab logd logh logm logmn logbr
_u gauthors blame dif difs dift ggrep gfgrep gk
_u co cond add com coma cam cpick cpcontinue clean iclean sm gpack
_u lr lrg lrh br mbase mergeff
_u gr grmu grabort grcontinue grskip gri grim grwhere gre grehard greupstream
_u stash gurl rem fetch pfetch pull push pushf pushu
source ~/.home/gitcmd-abbrev/bin/gitcmd-abbrev.bash
st() { ~/.home/gitcmd-abbrev/bin/st "$@"; }     # in case not in path

#   If less(1) is using default options, stop it from switching to alt screen.
[[ -n $LESS ]] || export LESS='-aeFimsXR -j.15'

#   Simpler functions etc. that I sometimes want to source alone
#   when I'm a guest in someone else's environment.
source 0cjs-funcs.bash
