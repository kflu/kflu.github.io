---
layout: post
title: CNTK installation
comments: true
---

Followed [this manual instruction](https://github.com/Microsoft/CNTK/wiki/CNTK-Binary-Download-and-Manual-Installation) since I have Anaconda already installed. **Be very careful** to install all required binaries:

* [Visual C++ Redistributable Package for Visual Studio 2013](https://www.microsoft.com/en-ie/download/details.aspx?id=40784)
* [Visual C++ Redistributable Package for Visual Studio 2012](https://www.microsoft.com/en-us/download/details.aspx?id=30679)
* [MPI](https://www.microsoft.com/en-us/download/details.aspx?id=49926)

I forgot to install MPI and later when `import cntk` it failed loading the `_cntk_py.pyd` module, costing me a lot of time.

Then create a conda environment for it:

```
conda create --name cntk-py34 python=3.4.3 numpy scipy jupyter matplotlib pillow
activate cntk-py34
python -m pip install --upgrade pip  # This is really optional to me
```
Now download CNTK binaries from [github here](). THere're three choices:

* CPU only
* GPU
* GPU with 1bit SGD

I tried the CPU only and the GPU with 1bit SGD, seems to work on my Surface Book with standalone GPU.

Now to verify it works, fire up a conda commandline and:

```
activate cntk-py34
python

# now in python:
>> import cntk  # this should succeed!
```

## Notes on Anaconda environment

** to display conda environment information **

    conda info --all
