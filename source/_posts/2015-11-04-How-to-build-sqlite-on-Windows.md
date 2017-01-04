---
layout: post
title: How to build SQLite on Windows
comments: true
date: 2015-11-04
---

The official compiling document is [here][HowToCompile].  You'll need:

- MSVC compiler (`cl.exe`) and `nmake`
- TCL 8.5 (make sure `tclsh85` is on PATH)
- Some build utilities that're common on Linux, like `gawk`. On Windows use
  [Gow][Gow]. Add gow/bin to `PATH`.

As a personal preference, I do not wish to install programs to pollute `PATH`.
So before compiling I need to make sure the necessary tools are on the `PATH`:

    set PATH=%PATH%;c:\gow\bin;c:\tcl\bin

SQLIte source comes in two flavors. The simpliest to compile is the
"[amalgamation][Amalgamation]" source that's a preprocessed huge `sqlite3.c`.
To compile this file, simply do:

    cl shell.c sqlite3.c

It builds the interactive shell `shell.exe`. This approach doesn't require
`tcl` or `gow`.

The other flavor is the raw source which contains 1000+ files. To build it, you
first build the the amalgamation file, then follow the steps for amalgamation
source.

Don't use any source that's from a git mirrow like [this one][GitMirrow]. When
not properly mirrored, the source doesn't have `manifest.uuid`, which is
critical to compilation. So make sure to use the official repository, or just
download the source from the offical website.

    nmake /f Makefile.msc sqlite3.c
    cl shell.c sqlite3.c

Compiling the shell requires some generated headers like `parse.h`. If there is
error during `nmake`, make sure `parse.h` is correctly generated and is
non-empty. Otherwise do

    lemon.exe parse.y

to re-generate `parse.h`. Note that `lemon.exe` is itself built from `lemon.c`
during the build process.

It is also possible to build `sqlite3.dll` to be linked by applications:

    nmake /f Makefile.msc sqlite3.dll

[Gow]:          https://github.com/bmatzelle/gow
[Amalgamation]: https://www.sqlite.org/amalgamation.html
[HowToCompile]: https://www.sqlite.org/howtocompile.html
[GitMirrow]:    https://github.com/mackyle/sqlite
