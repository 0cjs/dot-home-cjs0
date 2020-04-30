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

This contains my full Vim configuration in deacativated form; activate
it with `:ru cjs` (the [`cjs1`][cjs1] module adds this to `.vimrc`) or
persist it for a shell session with:

    alias vi='vim -c "runtime cjs"'

Without the above activation, the only change to the standard vim
configuration is that the little-used `s` and `S` commands now save
the current buffer and all changed buffers, respectively. (The
functionality of `s` and `S` are still available under synonyms `cl`
and `cc`.)

This configuration also includes a patch to the Markdown syntax
highlighting (`dot/vim/after/syntax/markdown.vim`) to fix a problem
with code block highlighting.



<!-------------------------------------------------------------------->
[0cjs]: https://github.com/0cjs/
[cjs1]: https://github.com/dot-home/cjs1/
[dot-home]: https://github.com/dot-home/_dot-home/
