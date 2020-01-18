vim-ormolu
==========

Introduction
------------

This is a plugin to integrate [ormolu] into your vim workflow. It will run
ormolu on Haskell buffers every time they are saved similar to `gofmt`. It
requires ormolu be accessible from your `$PATH`.

[ormolu]: https://github.com/tweag/ormolu

Installation
------------

First install ormolu via Stack or Nix:

```console
$ stack install ormolu --resolver=lts-14.14   # via stack
$ cabal new-install ormolu --installdir=/home/user/.local/bin # via cabal
$ nix-build -A ormolu   # via nix
```

If you are using **[pathogen.vim](https://github.com/tpope/vim-pathogen)** unpack
this repository into your vim or neovim configuration directory.

```console
$ cd ~/.vim/bundle         # for vim
$ cd ~/.config/nvim/bundle # for neovim
$ git clone https://github.com/sdiehl/vim-ormolu.git
```

If you are using **[Vundle](https://github.com/gmarik/Vundle.vim)** add the
following to your configuration file:

```vim
"Haskell Formatting
Plugin 'sdiehl/vim-ormolu'
```

If you are using **[vim-plug](https://github.com/junegunn/vim-plug)** add the
following to your configuration file:

```vim
"Haskell Formatting
Plug 'sdiehl/vim-ormolu'
```

Configuration
-------------

*The default settings will work fine out of the box without any aditional
configuration*.

If you have a non-standard `$PATH` then set `g:ormolu_command` Vim variable to
the location of the ormolu binary.

The specific flags for Ormolu can be configured by changing the Vim variable
`g:ormolu_options`. For example to use faster and unsafe formatting:

```vim
let g:ormolu_options=["--unsafe"]
```

To disable the formatting on a specific buffer use `let b:ormolu_disable=1`.

To disable the formatting globally use `let g:ormolu_disable=1`.

If instead of formatting on save, you wish to bind formatting to a specific
keypress add the following to your `.vimrc` or `init.vim`.  For example to bind
file formatting to the key sequence <kbd>t</kbd><kbd>f</kbd> use:

```vim
nnoremap tf :call RunOrmolu()<CR>
```

To toggle Ormolu formatting on a buffer <kbd>t</kbd><kbd>o</kbd> use:

```vim
nnoremap to :call ToggleOrmolu()<CR>
```

To disable Ormolu formatting to <kbd>t</kbd><kbd>d</kbd> use:

```vim
nnoremap td :call DisableOrmolu()<CR>
```

To enable Ormolu formatting to <kbd>t</kbd><kbd>e</kbd> use:

```vim
nnoremap te :call EnableOrmolu()<CR>
```

To format a visual block range call `OrmoluBlock()` function. Ormolu doesn't
normally work this way and usually requires more context on the module to
format. So this feature is experimental and may not function as expected. For
example to bind to the key sequence <kbd>t</kbd><kbd>b</kbd> use:

```vim
xnoremap tb :<c-u>call OrmoluBlock()<CR>
```

If you see quirky behavior using TypeApplications extensions with the code being
formatted into invalid Haskell, you probably need to enable `-XTypeApplications`
globally because it is set in your global cabal file per this
[issue](https://github.com/tweag/ormolu/issues/452).

```vim
let g:ormolu_options=["-o -XTypeApplications"]
```

License
-------

MIT License
Copyright (c) 2019-2020, Stephen Diehl
