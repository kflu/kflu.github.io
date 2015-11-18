---
layout: post
title: `PsExec` to salvage a remote PC that can't connect to
comments: true
---

My work PC is a VM that is only accessible through remote desktop. Today after rebooting it, it can't be connected via remote desktop again. The remote desktop connection diaglog flashed with the usual "setting up connection" messages and quitted silently. I can't connect through hyper-V manager either. I guessed that some process is in a bad state and needed to be restarted. To do this, I'll need to log on remotely to kill the process. So I connected via `PsExec`:

    PsExec -h -u <domain\user> \\<remote_machine> cmd.exe

`-h` is for elevated access. Here's what it looked like once logged on:

    PsExec v2.11 - Execute processes remotely
    Copyright (C) 2001-2014 Mark Russinovich
    Sysinternals - www.sysinternals.com
    
    Password:
    
    Microsoft Windows [Version 10.0.10240]
    (c) 2015 Microsoft Corporation. All rights reserved.
    
    C:\WINDOWS\system32>

I killed the [desktop window manager][dwm] with:

    taskkill /im dwm.exe

The `PsExec` connection was lost (I guess `dwm.exe` is too important to be killed). And after a while, remote desktop worked again. I guess `dwm.exe` was restarted automatically.

[dwm]: https://msdn.microsoft.com/en-us/library/windows/desktop/aa969540(v=vs.85).aspx
