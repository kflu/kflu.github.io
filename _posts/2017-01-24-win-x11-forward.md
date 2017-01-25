---
title: X11 forwarding on Windows
tags:
    - x11
    - ssh
    - vim
---

This allows you to ssh from Windows machine and get two major benefits:

1. Make use of X11 apps on the ssh server
2. Make (primarily) remote vim to access system clipboard

Here's how. This guide uses the following setup:

- No need to install full Cygwin or MSYS
- Use Mintty/ssh that comes with [Git on Windows][git], aka, git bash.

I mainly followed [this guide][main]. 

## Server setup

Ensure `/etc/ssh/sshd_config`:

    AllowAgentForwarding yes
    AllowTcpForwarding yes
    X11Forwarding yes
    X11DisplayOffset 10
    X11UseLocalhost no

Restart `sshd` with `service ssh restart`.

Ensure `xauth` is installed. On Debian use `dpkg -l | grep xauth`. On 
FreeBSD use `pkg info | grep xauth`.


## Client setup

Install [xming x server][xming] on Windows. Make sure the server is `:0.0`. This can be told 
by hovering mouse over the X icon in taskbar.

Fire up mintty,

    export DISPLAY=localhost:0.0
    ssh -Y <ssh server>

_The original post omitted `localhost` and it didn't work for me._

In ssh session, test with `xclock`.


## Vim clipboard

First [check vim system clipboard support][vim_support]:

    vim --version | grep clipboard

If for `clipboard` and `xterm_clipboard` there's a `-` in front, then you are **NOT** good. [For Ubuntu,
the base vim package is in this case][ubuntu_vim]. You'll need vim GUI packages like `vim-gtk` for it to work:

    apt-get install vim-gtk

Now in vim remote session, select some text type `"+y`. Try to paste it in local notepad and make sure it works.


## References

- [Guide][main]
- [Vim support][vim_support]
- [Ubuntu Vim][ubuntu_vim]

[main]: https://ysgitdiary.blogspot.com/2014/04/how-to-configure-x11-port-forwarding.html
[vim_support]: http://vim.wikia.com/wiki/Accessing_the_system_clipboard#Checking_for_X11-clipboard_support_in_terminal
[ubuntu_vim]: http://askubuntu.com/a/613173/259343
[git]: https://git-scm.com/
[xming]: https://sourceforge.net/projects/xming/files/latest/download
