---
title: strange cmd/power quote escaping
date: 2017-01-11
---

With this program (`cs.exe`):

```
class Program
{
    static void Main(string[] args)
    {
        foreach (var item in args)
        {
            Console.WriteLine(item);
        }
    }
}
```

And the runs:

```
> cs.exe go\to\a_path
go\to\a_path

> cs.exe "go\to\a path"
go\to\a path

> cs.exe "go\to\a path\"
go\to\a path"
```

That means if your path has a space so  you quote it, be very careful NOT to put a trailing `\` at the end, otherwise your program 
might just not be able to handle it as it incorrectly contains a `"` at the end.
