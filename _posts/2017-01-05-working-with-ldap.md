---
layout: post
title: Working with LDAP/AD in .NET
date: 2017-01-05
comments: true
---

Here's the code to access AD (latest at [here][1]).

```fsharp
(* Accessing AD through LDAP
Inspired by http://stackoverflow.com/a/14814508/695964 

Need nuget package System.DirectoryServices

*)

#r @"./packages/System.DirectoryServices/lib/System.DirectoryServices.dll"

open System
open System.Collections
open System.DirectoryServices

let de = new DirectoryEntry() // connects to the local domain controller

// these two are optional
de.Path <- "LDAP://OU=UserAccounts,DC=foo,DC=bar,DC=baidu,DC=com" // This scopes the subsequence queries
de.AuthenticationType <- AuthenticationTypes.Secure

let s = new DirectorySearcher(de, Filter="(name=John Smith)")

let res = s.FindOne()

res.Properties.["name"] // this is always a seq
res.Properties.["name"].[0] // this is always a obj that needs to be casted at runtime
res.Properties.["name"].[0] :?> string // I know it's a string

let myMailboxGuid = Guid(res.Properties.["someBinaryField"].[0] :?> byte array)

// Display all fields (res.Properties implements IDictionary: http://stackoverflow.com/a/3267704/695964)
res.Properties |> Seq.cast<DictionaryEntry> |> Seq.iter (fun x -> printfn "%A" (x.Key, x.Value))
```


## References

- [My gist to access AD in F#][1]
- [SO post on connecting to LDAP](http://stackoverflow.com/a/14814508/695964)
- [Howto: (Almost) Everything In Active Directory via C#](https://www.codeproject.com/articles/18102/howto-almost-everything-in-active-directory-via-c)
- [Active Directory With C#](http://ianatkinson.net/computing/adcsharp.htm)
- [GUI tool: AD explorer (very rough and slow)](https://technet.microsoft.com/en-us/sysinternals/adexplorer.aspx)

[1]: https://gist.github.com/kflu/ea18e097427f3d458322011025583384
