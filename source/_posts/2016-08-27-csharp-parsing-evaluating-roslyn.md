---
layout: post
title: C# parsing and evaluating using Roslyn
comments: true
---

Using Roslyn you can parse c# code into AST and given a c# code snippet, it can be evaluated. You need the following binaries:

* Microsoft.CodeAnalysis.CSharp
* Microsoft.CodeAnalysis.CSharp.Scripting

`CSharpSyntaxTree.ParseText` converts a c# code (string) into a `SyntaxTree`. `CSharpScript.EvaluateAsync` can be used to evaluate a c# code snippet. There're other useful API for scripting, documented [here][1], including inspecting defined variables, continuing with a previous state, etc.

Note that

    CSharpScript.EvaluateAsync("new DateTime(2016,12,1)");

throws an exception:

`Microsoft.CodeAnalysis.Scripting.CompilationErrorException: (1,5): error CS0246: The type or namespace name 'DateTime' could not be found (are you missing a using directive or an assembly reference?)`

Since the code snippet needs to be "self-contained", namespace needs to be properly used. Below is a fully working example of the parsing and evaluating.

```csharp
using System;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Scripting;

namespace GettingStartedCS
{
    class Program
    {
        static void Main(string[] args)
        {
            // demonstrate parsing
            SyntaxTree tree = CSharpSyntaxTree.ParseText(@"var x = new DateTime(2016,12,1);");
            Console.WriteLine(tree.ToString()); // new DateTime(2016,12,1)

            var result = Task.Run<object>(async () =>
            {
                // CSharpScript.RunAsync can also be generic with typed ReturnValue
                var s = await CSharpScript.RunAsync(@"using System;");

                // continuing with previous evaluation state
                s = await s.ContinueWithAsync(@"var x = ""my/"" + string.Join(""_"", ""a"", ""b"", ""c"") + "".ss"";");
                s = await s.ContinueWithAsync(@"var y = ""my/"" + @x;");
                s = await s.ContinueWithAsync(@"y // this just returns y, note there is NOT trailing semicolon");

                // inspecting defined variables
                Console.WriteLine("inspecting defined variables:");
                foreach (var variable in s.Variables)
                {
                    Console.WriteLine("name: {0}, type: {1}, value: {2}", variable.Name, variable.Type.Name, variable.Value);
                }
                return s.ReturnValue;
                    
            }).Result;
            
            Console.WriteLine("Result is: {0}", result);
        }
    }
}
```

The above code give the output:

```
var x = new DateTime(2016,12,1);
inspecting defined variables:
name: x, type: String, value: my/a_b_c.ss
name: y, type: String, value: my/my/a_b_c.ss
Result is: my/my/a_b_c.ss
```


References
====
* [Roslyn scripting](https://github.com/dotnet/roslyn/wiki/Scripting-API-Samples#expr)
* [Roslyn syntax analysis aka parsing](https://github.com/dotnet/roslyn/wiki/Getting-Started-C%23-Syntax-Analysis)
* [Roslyn AST to Linq expression tree? This may not be necessary anymore since Roslyn can be fully functional](https://social.msdn.microsoft.com/Forums/vstudio/en-US/e6364fec-29c5-4f1d-95ce-796feb25a8a9/is-it-possible-to-convert-a-roslyn-ast-expression-tree-to-a-linq-expression-tree-is-there-a-roslyn?forum=roslyn)
* [Roslyn scripting scenarios][1]

Using it in F#
====
Same thing can be used in F#. I can successfully use it in a F# console application with nuget (via Visual Studio).

```fsharp
open Microsoft.CodeAnalysis
open Microsoft.CodeAnalysis.CSharp
open Microsoft.CodeAnalysis.CSharp.Scripting

let ast = CSharpSyntaxTree.ParseText("""var x = new DateTime(2016,12,1);""")
printfn "%s" (ast.ToString())

let result = 
    async {
        let! s = CSharpScript.RunAsync("""using System;""") |> Async.AwaitTask
        let! s = s.ContinueWithAsync("""var x = "my/" + string.Join("_", "a", "b", "c") + ".ss";""") |> Async.AwaitTask
        let! s = s.ContinueWithAsync("""var y = "my/" + @x;""") |> Async.AwaitTask
        let! s = s.ContinueWithAsync("""y""") |> Async.AwaitTask
        return s.ReturnValue
    }
    |> Async.RunSynchronously

printfn "%A" result
```

### Problem with references in F# scripts

I have difficulty using it in a F# script file with paket. The problem is runtime error that it can't load `System.Collections.Immutable` or the loaded `System.Collections.Immutable` is missing a methd/class. It turns out paket pulls doesn stable release for the below **direct** dependencies that caused the issue. If I switch to use prerelease, the problem is gone.

* Microsoft.CodeAnalysis.CSharp
* Microsoft.CodeAnalysis.CSharp.Scripting

Here're the necessary setting for the `fsx` to work:

```fsharp
#I @"..\packages\Microsoft.CodeAnalysis.Common\lib\net45\"
#I @"..\packages\Microsoft.CodeAnalysis.CSharp\lib\net45\"
#I @"..\packages\Microsoft.CodeAnalysis.CSharp.Scripting\lib\dotnet\"
#I @"..\packages\Microsoft.CodeAnalysis.Scripting.Common\lib\dotnet\"
#I @"..\packages\System.Collections.Immutable\lib\netstandard1.0\"
#I @"..\packages\System.Reflection.Metadata\lib\portable-net45+win8\"
#I @"..\packages\FParsec\lib\net40-client\"

// to make intellisense happy
#r "System.Collections.Immutable"
#r "System.Threading.Tasks"
#r "System.Text.Encoding"

#r "Microsoft.CodeAnalysis.dll"
#r "Microsoft.CodeAnalysis.CSharp.dll"
#r "Microsoft.CodeAnalysis.CSharp.Scripting.dll"
#r "Microsoft.CodeAnalysis.Scripting.dll"
#r "FParsec.dll"
```


[1]: https://github.com/dotnet/roslyn/wiki/Scripting-API-Samples#prevstate
