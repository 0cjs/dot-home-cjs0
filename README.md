cjs0 - Minimally Intrusive [dot-home] Configuration
===================================================

Usage
-----

This is a [dot-home] module. To use it:

    mkdir -p ~/.home
    cd ~/.home
    git clone https://github.com/dot-home/_dot-home.git     # Core system
    git clone https://github.com/dot-home/cjs0.git          # This repo
    ~/.home/_dot-home/bin/dot-home-setup

Description
-----------

**WARNING:** This has not yet disabled certain features, such as
minimizing the Vim configuration. This will happen soon after a
few more changes have been brought into the [dot-home] core system.

This is a minimally-enabled dot-file configuration used by [Curt J.
Sampson]. It serves both as a base for his [full configuration][cjs1]
and enables a minimal set of changes that will interfere minimally or
not at all with dot-file configurations as used by others (whether or
not they are dot-home users).

For example, Vim's little-used `s` command (replace the current
character under the cursor with a string typed in insert mode) is
remapped to save the current file. The original function remains as
the more memorable and obvious (to Vim users) `cl` if anybody does use
it.

More extensive reconfiguration can be activated in several different
ways:

  1. Manually at the command line or similar.
  2. By adding a few lines to configuration fragments (e.g.
     `dot/bashrc.inb4`) in one's own dot-home modules.
  3. By adding the [cjs1] dot-home module to `~/.home`.



[dot-home]: https://github.com/dot-home/_dot-home/
[Curt J. Sampson]: https://github.com/0cjs/
[cjs1]: https://github.com/dot-home/cjs1/
