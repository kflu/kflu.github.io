---
layout: post
title: Some F# Update
comments: true
---

I looked into [Ionide][Ionide] that enhances Atom/VSCode into an F# IDE. I'd
say compared with other languages I've looked into recently, like Haskell and
OCaml, the experience is pretty good. It has auto-complete, Paket and Fake
integration. It is still not as good as VisualStudio though. One thing I miss
a lot is "Go to definition" on a type in assemblies. With VisualStudio, it
brings you to the "ILDASM" style metadata. This is greatly useful for
exploration.

But I still appreciate the cross-platform capability that the tool brings in -
with Ionide, Fake, Paket/Nuget, there's no need for VS and full profile .NET
develop environment.

So an F# development pattern I would like to establish from now on, is to use
the [fsharp yeoman generator][generator] to scaffold the project (rather than
letting VisualStudio to the job). And when VisualStudio is available, use it
with the `.fsproj` file. When it's not available, I can fallback to Atom/VSCode.

P.S. just realized [WebSharper][WebSharper]([document][wsdoc] looks awesome!) is
a fullstack web framework using F#, including frontend. Its [REST service][rest]
support also looks promising.

[Ionide]: http://ionide.io/
[generator]: https://github.com/fsprojects/generator-fsharp
[WebSharper]: http://websharper.com/
[wsdoc]: http://websharper.com/docs
[rest]: http://websharper.com/tutorials/rest-api
