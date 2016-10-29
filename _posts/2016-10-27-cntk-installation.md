---
layout: post
title: CNTK installation and IDE setup
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

**to display conda environment information**

    conda info --all

## IDE setup

Best autocompletion support for Python that I've seen so far is PyCharm. Python Tools for Visual Studio (PTVS), for example, is not able to infer function signature on `cntk.ops.input_variable` and others. Install the free PyCharm community edition is sufficient. To let 
PyCharm use the Anaconda CNTK environment:

1. find the python executable python by using `conda info --all`. 
2. in PyCharm -> settings -> project -> project interpreter -> "add local", put in the desired python executable path
3. note that CNTK relies on a bunch of environment variables to work, e.g., `MSMPI_LIB32`, `MSMPI_LIB64`, so **always launch PyCharm from the anaconda console** to ensure necessary environment variables are inherited by the IDE.


