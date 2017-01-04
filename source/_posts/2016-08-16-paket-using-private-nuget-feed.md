---
layout: post
title: Paket - using private nuget feed
comments: true
date: 2016-08-16
---

Paket can be set up (per project) to use private nuget feeds that require authentication. Here's how:

1. In paket.dependencies, add a line `source <feed_url>`. Also add the dependencies you want to pull: `nuget <library>`
2. Encode the credential for the feed by calling `paket.exe config add-credentials <feed_url>`. This stores the credential at paket's global config location `%appdata%/paket/paket.config`. (to get credentials for VisualStudio Online (VSO) feeds, see below).

Now you can run `paket.exe install`.

Note that nuget credential provider is a better way to manage credentials. But currently paket doesn't support that. 


Get access to private VSO feeds
====
The ideal way is to use nuget provider. Paket doesn't support that yet. So the alternative is to get a personal access token for the VSO feed:

1. Go to the VSO site of the nuget feed and sign in
2. Click on your profile -> security. There you can manage all credentials like the nuget token or SSH public keys.
3. Create a new token for the project. Store it somewhere as you can't retrieve it from VSO once closed.


References
====

* [`paket config` doc](https://fsprojects.github.io/Paket/paket-config.html)
* [Paket's nuget dependencies doc](https://fsprojects.github.io/Paket/nuget-dependencies.html)
