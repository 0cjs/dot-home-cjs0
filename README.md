cjs0 - Minimally Intrusive dot-home Configuration
=================================================

This [dot-home] module is my ([Curt Sampson's][0cjs]) minimal
environment configuration. It's particularly handy to use if you
pair-program with me, and can also serve as a reference for dot-home
configuration techniques.

When installed it ensures that a few of the most essential
configuration elements are present (e.g., that `$PATH` includes
`~/.local/bin`) and provides further deacativated configuration (such
as for Vim) that can be easily activated.

This module should be able to be used in almost any dot-home
configuration with minimal or no interference, so long as a few
configuration files (see below) are built from inb4 fragments.

My full configuration, [`dot-home/cjs1`][cjs1], enables all the
deactivated configuration in this repo.

### Installation

    mkdir -p ~/.home
    cd ~/.home
    git clone https://github.com/dot-home/_dot-home.git     # Core system
    git clone https://github.com/dot-home/cjs0.git          # This repo
    ~/.home/_dot-home/bin/dot-home-setup                    # Activate


Details
-------

### Directories

- `conf/`: Contains configuration code that does not get installed under
  $HOME to help avoid polluting other people's environments when they are
  using this dot-home module. Programs under `bin/` first try to load this
  configuration from `$(dirname "$0")/../conf/` (which works if the files
  are run directly from `bin/` here because they've not been installed)
  and fall back to `~/.home/cjs0/conf/`.

- `vim/`: Vim configuration used by `bin/vi`; see below.

### inb4 Fragments

The following configuration files must be built from inb4 fragments,
since this repo includes inb4 fragments for them.

- `.bashrc`. This adds a `prepath` shell function to cleanly
  manipulate `$PATH` and ensures that `~/.local/bin` is at the
  beginning of the path. It may also add some additional commands
  (e.g., `lf`) if they don't already exist.
- `.vimrc`. Activates some very minimal vim configuration (which you
  can override with your configuration). See below for more details.
- `.ssh/known_hosts`. Keys for some well-known public hosts (such as
  `github.com`) and my own hosts.
- `.gitconfig`. A few common configuration settings (used by many
  developers) that make Git work a little more cleanly and quietly.
  These can easily be overridden.

### Vim Configuration

This contains my full Vim configuration in deacativated form; activate it
by running `bin/vi`. (Neither this nor the [`cjs1`][cjs1] create/edit a
`~/.vimrc`.

Previously, without activiation this still changed the standard Vim
configuration to set the little-used `s` and `S` commands to save the
current buffer and all changed buffers, respectively. (The functionality of
`s` and `S` remain available under synonyms `cl` and `cc`.) It's not clear
how to continue to do this in the new `bin/vi` configuration system, but
perhaps it's no longer necessary.

This configuration also includes a patch to the Markdown syntax
highlighting (`dot/vim/after/syntax/markdown.vim`) to fix a problem
with code block highlighting.



<!-------------------------------------------------------------------->
[0cjs]: https://github.com/0cjs/
[cjs1]: https://github.com/dot-home/cjs1/
[dot-home]: https://github.com/dot-home/_dot-home/
