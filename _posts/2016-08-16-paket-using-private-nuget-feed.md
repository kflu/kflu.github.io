---
layout: post
title: Paket - using private nuget feed
comments: true
---

Paket can be set up (per project) to use private nuget feeds that require authentication. Here's how:

1. In paket.dependencies, add a line `source <feed_url>`. Also add the dependencies you want to pull: `nuget <library>`
2. Encode the credential for the feed by calling `paket.exe config add-credentials <feed_url>`. This stores the credential at paket's global config location `%appdata%/paket/paket.config`. 

Now you can run `paket.exe install`.

Note that nuget credential provider is a better way to manage credentials. But currently paket doesn't support that. 

References
====

* [`paket config` doc](https://fsprojects.github.io/Paket/paket-config.html)
* [Paket's nuget dependencies doc](https://fsprojects.github.io/Paket/nuget-dependencies.html)
