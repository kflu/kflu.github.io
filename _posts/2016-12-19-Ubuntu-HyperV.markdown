---
layout: post
title: Ubuntu on Gen 2 Hyper-V 
comments: true
---

All setup should be straightforward except getting the network to work. After spending a lot of time, [this guide worked](http://help.yoyogames.com/hc/en-us/articles/216754468-Setup-An-Ubuntu-Virtual-Machine-Using-Hyper-V).
What's needed is an external virtual switch and enabling "Allow management operating system to share this network". When creating the 
switch, it asks to bind to a physical adapter. So I guess changing to using a different physical adapater in the host (e.g., laptop
swithed from Ethernet to WIFI) would make the network break in the VM.
