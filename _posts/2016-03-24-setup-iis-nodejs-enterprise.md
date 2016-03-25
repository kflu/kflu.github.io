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
3. roll your own AD code to check if the authenticated user is a member of `DOMAIN\SecurityGRoup`. This step is extremely easy. Even doable in PowerShell. Proof in the last section. To use .NET in node, [edge.js](http://tjanczuk.github.io/edge/) can be used.

Totally doable. But is it necessary? I think not.


# Approach 2 - IIS + Node.js

This approach delegates the entire authentication and authorization to the IIS. And uses [`iisnode`](https://github.com/tjanczuk/iisnode) to integrate the node.js app into IIS. I'm going to talk about the steps in detail. 

## Setup IIS for Security Group Authorization

For this step I'm mostly based on [this](http://serverfault.com/a/721855/309638) article. 

1. Install IIS, ensure URL authorization and Windows Authentication are enabled (under IIS/WWW Server/Security)
2. Go to the desired web site in IIS manager
3. Enable Windows Authentication
4. Configure Authorization Rules to ONLY allow the security group. Specify it in the form of "DOMAIN\SecurityGroup"


## Setup `iisnode`

For this step I'm mainly following the guidance [here](https://github.com/tjanczuk/iisnode).

1. Enable ASP 4.6 in IIS
2. [Install URL rewrite module for IIS](http://www.iis.net/download/URLRewrite)
3. Install node of course (matching OS bitness)
4. Install iisnode matching OS bitness
5. Install iisnode samples by running `%programfiles%\iisnode\setupsamples.bat` in admin cmd
6. Go to http://localhost/node for verification (make sure your authentication works in previous section!)


# Check if a domain user is a member of a security group

This [SO answer](http://stackoverflow.com/a/12029478/695964) helped.

```PowerShell
Add-Type -AssemblyName System.DirectoryServices.AccountManagement
$ctx = New-Object -TypeName System.DirectoryServices.AccountManagement.PrincipalContext -ArgumentList ([System.DirectoryServices.AccountManagement.ContextType]::Domain,"DOMAIN")
$user = [System.DirectoryServices.AccountManagement.UserPrincipal]::FindByIdentity($ctx, "user")
$group = [System.DirectoryServices.AccountManagement.GroupPrincipal]::FindByIdentity($ctx, "SecurityGroup")
$user.IsMemberOf($group)
```
