---
layout: post
title: Deploy Node.js web app with Enterprise Network Authentication
comments: true
---

This article describes how to deploy node.js web app to be accessible in a Windows domain controlled (ActiveDirectory) network. For the ease of
discussion, lets assume:

* the machine hosting the app is named `DOMAIN\MACHINE`
* the users access the website at `http://machine`
* the website should only be accessible by users within the ActiveDirectory security group `DOMAIN\SecurityGroup`

# Approach 1 - Plain Vanilla Node.js
Now, to achieve the above three goals, we can do it the plain vanilla way:

1. host the app directly with Node.js http module, or anything built on top of that.
2. in the app, authenticate with NTLM/Kerboros (maybe with [express-ntml](https://github.com/einfallstoll/express-ntlm) module)
3. roll your own AD code to check if the authenticated user is a member of `DOMAIN\SecurityGRoup`. This step is extremely easy. Even doable in PowerShell. Proof below.



# Check if a domain user is a member of a security group

```

```
