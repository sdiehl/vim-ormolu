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
$ nix-build -A ormolu   # via nix
```

And then unpack this repository into your vim or neovim configuration directory.

```console
$ cd ~/.vim/bundle         # for vim
$ cd ~/.config/nvim/bundle # for neovim
$ git clone https://github.com/sdiehl/vim-ormolu.git
```

This plugin is compatible with [Vundle.vim] and [pathogen.vim].

[Vundle.vim]: https://github.com/gmarik/Vundle.vim
[pathogen.vim]: https://github.com/tpope/vim-pathogen

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

To format a visual block range call `OrmoluBlock()` function. For example to
bind to the key sequence <kbd>t</kbd><kbd>b</kbd> use:

```vim
xnoremap tb :<c-u>call OrmoluBlock()<CR>
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

License
-------

MIT License
Copyright (c) 2019-2020, Stephen Diehl
