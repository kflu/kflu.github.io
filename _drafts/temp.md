---
layout: post
title: Using Vagrant on Windows
comments: true
---

Vagrant is a virtualization technology for creating development environments. It is based on virtual machine technology and can be used with multiple VM "providers". The getting started guide is [here][start]. Use `vagrant init <boxname>` to initialize one. But note that not all "boxes" supports all providers (virtualbox, hyper-v, etc.). The default one in the getting started doc `hashicorp/precise32`, for example, does not support hyper-v (which comes with Windows since 8.1) as the provider. But the boxes can be explored [here][boxes]. And it doesn't take long to realize that `hashicorp/precise64` supports hyper-v.

[start]: https://docs.vagrantup.com/v2/getting-started/index.html
[boxes]: https://atlas.hashicorp.com/boxes/search
