---
layout: post
title: FsLab Journal
comments: true
date: 2016-08-04
---

FsLab Journal is a literate programming tool based on FSharp.Formatting. It's sort of like Jupyter notebook. The advantage of it over IPython notebook
is that it's statically typed and IDE supports are awesome. In order to use it:

1. Download the template from [here](https://github.com/fslaborg/FsLab.Templates/archive/journal.zip)
2. Run `build run` to automatically restore packages and start a live server
2. Unzip and open the `.fsproj` file to start editing in Visual Studio
3. The web page is automatically updated (there's a several seconds delay)

To add a reference, add a line in `paket.dependencies`, and reference the assembly in the `.fsx` script file by the following. Then intellisense will work!

    #r "packages/Argu/lib/net40/Argu.dll"

FSharp.Formatting lets you register custom object output by [`RegisterTransformation`](https://tpetricek.github.io/FSharp.Formatting/evaluation.html#Custom-formatting-functions). Here's [Deedle's implementation](https://github.com/BlueMountainCapital/Deedle/blob/5d347cf9329d427e3872c1197303f20554e37a32/docs/tools/formatters.fsx#L288) (e.g., frame as table, etc.). But currently it doesn't let you do table cells conditional formatting.


References
----
* [FsLab Journal](http://fslab.org/download/)
* [FShapr.Formatting](http://tpetricek.github.io/FSharp.Formatting/)
* [Deedle tutorial](http://bluemountaincapital.github.io/Deedle/tutorial.html)
