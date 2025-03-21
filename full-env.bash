#   Start with "become" user's environment, which we don't yet have due
#   to the --rcfile option replacing user's default .bashrc.
source "$HOME/.bashrc"

[[ -d ~cjs ]] || { echo 1>&2 "Directory ~cjs not found"; return 1; }

#   XXX The problem here is that some things we set, such as
#   $PYTHONPYCACHEPREFIX (and maybe even the $PATH=…/home/cjs/bin:…) should
#   either use the actual user's $HOME or not be set at all. For the
#   moment, we just unset stuff at the end.

__0cjs_prev_home="$HOME"
export HOME=~cjs
__0cjs_nofortune=true
#   Because we need our env vars, we must source .bash_profile.
#   Maybe we want a way to suppress the fortune that also gets printed.
. ~cjs/.bash_profile
export HOME="$__0cjs_prev_home"

unset __0cjs_prev_home __0cjs_nofortune

#   XXX see above
unset GOPATH PYTHONPYCACHEPREFIX
