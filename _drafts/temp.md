---
layout: post
title: Using Vagrant on Windows
comments: true
---

Vagrant is a virtualization technology for creating development environments. It is based on virtual machine technology and can be used with multiple VM "providers". The __getting started guide__ is [here][start]. Use `vagrant init <boxname>` to initialize one. But note that not all "boxes" supports all providers (virtualbox, hyper-v, etc.). The default one in the getting started doc `hashicorp/precise32`, for example, does not support hyper-v (which comes with Windows since 8.1) as the provider. But the boxes can be explored [here][boxes]. And it doesn't take long to realize that `hashicorp/precise64` supports hyper-v.

Once initialized, use `valgrant up` to download and set up the virtual machine. Then `valgrant ssh` to log in to it. Note that it requires `ssh` to be on path to log in. If `git` is installed, it usually includes a set of unix commands including `ssh`. So to bring `ssh` to the path and log in to the vm:

    PS> $env:path = $env:path + ";" + "C:\Program Files (x86)\Git\bin"
    PS> valgrant ssh

This is under `PowerShell`. In `cmd` use 
  
    SET PATH=%PATH%;C:\Program Files (x86)\Git\bin

With that done, you'll be (finally!) greeted with the Linux command line:

    PS> vagrant ssh
    Welcome to Ubuntu 12.04.4 LTS (GNU/Linux 3.11.0-15-generic x86_64)
    
     * Documentation:  https://help.ubuntu.com/
    Last login: Thu Mar  6 09:02:28 2014
    vagrant@precise64:~$
    vagrant@precise64:~$ uname -a
    Linux precise64 3.11.0-15-generic #25~precise1-Ubuntu SMP Thu Jan 30 17:39:31 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux


[start]: https://docs.vagrantup.com/v2/getting-started/index.html
[boxes]: https://atlas.hashicorp.com/boxes/search
