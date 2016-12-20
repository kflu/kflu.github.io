---
layout: post
title: Linux, Terminals, Windows
comments: true
---

## Mintty

Mintty comes with git for windows. It comes with an ssh client so you don't need putty. I found mintty to be easier to work with.

### TERM

Setting term to be `xterm-256color` gives mouse support for vim, tmux, etc. Originally it was `xterm` and it didn't work.


## Tmux

In ~/.tmux.config set `set -g mouse on` will enable mouse support for selecting pane, resizing, etc. See [here](http://stackoverflow.com/a/33336609/695964).

