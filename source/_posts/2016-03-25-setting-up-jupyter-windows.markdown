---
layout: post
title: Setting up Jupyter on Windows
comments: true
date: 2016-03-25
---

Installing any python module on Windows is an advanture. Fuck Python. It's no exception for Jupyter.

`pip install Jupyter` fails at the end. Boot up `jupyter nbconvert <notebook>` would fail with `import failed for XXX, module XXX not found`.
Then you'll have to `pip install XXX` and the same thing happens you'll follow down the deps manuall. Here's a list of deps you'll probably install
for yourself.

```
pip install path.py
pip install functools32
pip install jsonschema
pip install markupsafe
```
