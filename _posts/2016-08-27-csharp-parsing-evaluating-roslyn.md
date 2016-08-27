---
layout: post
title: C# parsing and evaluating using Roslyn
comments: true
---

Using Roslyn you can parse c# code into AST and given a c# code snippet, it can be evaluated. You need the following binaries:

* Microsoft.CodeAnalysis.CSharp
* Microsoft.CodeAnalysis.CSharp.Scripting

`CSharpSyntaxTree.ParseText` converts a c# code (string) into a `SyntaxTree`. `CSharpScript.EvaluateAsync` can be used to evaluate a c# code snippet.

Note that

    CSharpScript.EvaluateAsync("new DateTime(2016,12,1)");

throws an exception:

`Microsoft.CodeAnalysis.Scripting.CompilationErrorException: (1,5): error CS0246: The type or namespace name 'DateTime' could not be found (are you missing a using directive or an assembly reference?)`

Since the code snippet needs to be "self-contained", namespace needs to be properly used. Below is a fully working example of the parsing and evaluating.

```
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
            SyntaxTree tree = CSharpSyntaxTree.ParseText(@"new DateTime(2016,12,1)");
            Console.WriteLine(tree); // new DateTime(2016,12,1)
            var code = tree.ToString();
            code = @"using System;" + code;
            var x = Task.Run<object>(async () =>
            {
                // EvaluateAsync can also be untyped returns object
                return await CSharpScript.EvaluateAsync<DateTime>(code);
            }).Result; // -> prints the DateTime object
        }
    }
}
```
