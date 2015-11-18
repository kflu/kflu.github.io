---
layout: post
title: Enumerable and Disposable
comments: true
---

Enumerables are deferred executions. This can be problematic when used with Disposables as the latter are tend to be disposed prematurely. The below example shows the difference. `ildasm` shows that the compiler generates a class that implements `IEnumerable<int>` for `Foo2` behind the scene, and returns an instance of it for `Foo2`. Because of that, the `using` is embedded into that instance so the constructing and disposal of `Disposable` is carried on by the deferred executed implementation. On the contrary, `Foo` just returns the source enumerable as a pass through, at the time it's executed, the disposal already happened. This causes the problem that if the returned enumerable depends on the disposable, at the time the enumerable is extracted from, the disposable is in the disposed state.

```javascript
function foo() {
    console.log("hello world!");
}
```

```csharp
static void Main(string[] args)
{
    int[] source = new[] { 1, 2, 3 };
    Console.WriteLine("Using Foo...");

    // Outputs:
    // Disposed
    // 1
    // 2
    // 3
    foreach (var item in Foo(source))
        Console.WriteLine(item);

    Console.WriteLine("Using Foo2...");

    // Outputs:
    // 1
    // 2
    // 3
    // Disposed
    foreach (var item in Foo2(source))
        Console.WriteLine(item);
}

static IEnumerable<int> Foo(IEnumerable<int> source)
{
    using (var disposable = new Disposable())
        return source;
}

static IEnumerable<int> Foo2(IEnumerable<int> source)
{
    using (var disposable = new Disposable())
        foreach (var item in source)
            yield return item;
}

class Disposable : IDisposable
{
    public void Dispose()
    {
        Console.WriteLine("Disposed");
    }
}
```
