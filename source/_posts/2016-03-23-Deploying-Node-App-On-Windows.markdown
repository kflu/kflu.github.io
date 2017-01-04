---
layout: post
title: Deploying Node App On Windows
comments: true
---

Requirements:

1. app can auto restart when crashed (via pm2)
2. have clustering support (via pm2)
3. can start on boot (via scheduled task)
4. run as SYSTEM

1-3 are straightforward. Step 4 was not - pm2 requires the `HOMEPATH` to be set, which is not the case for SYSTEM account. For a regular user,
it's set to `c:\users\<user>`. So I have to set it properly in the batch file that starts the app.
