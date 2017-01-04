---
title: TypeScript, Type Definitions, and Promisification
layout: post
comments: true
date: 2016-05-12
---

Got disgusted by JS's dynamic typing nature (same thing I hated Python). So I
gave typescript another try. The one thing I care most is the support for
async/await syntax, which it already supported.

Bare minimum TypeScript Setup
====

To setup a TypeScript project you need a `tsconfig.json`:

    {
        "compilerOptions": {
            "module": "commonjs",
            "target": "es2015",
            "noImplicitAny": false,
            "sourceMap": false
        },
        "exclude": [
            "node_modules",
            "typings/browser.d.ts",
            "typings/browser"
        ]
    }

Compilation is then done with a simple `tsc` command. This would compile your 
scripts into `.js` files.

Working with Type Definitions
====

To work with external libaries, you'll need to download a lot of `.d.ts` type
definition files. That's where `typings` comes into play. Install with:

    npm i -g typings

Install type definitions with:

    typings install node --save --ambient

Installed defs are put under `typings` folder with the structure:

    typings
    │   browser.d.ts
    │   main.d.ts
    │
    ├───browser
    │   └───ambient
    │       ├───bluebird
    │       │       index.d.ts
    │       ├───commander
    │       │       index.d.ts
    │       └───node
    │               index.d.ts
    └───main
        └───ambient
            ├───bluebird
            │       index.d.ts
            ├───commander
            │       index.d.ts
            └───node
                    index.d.ts

The `browser.d.ts` and `main.d.ts` are top level definition for browser and server use respectively.
They contain the same content, simply referencing each installed `.d.ts` files:

    /// <reference path="main/ambient/bluebird/index.d.ts" /
    /// <reference path="main/ambient/commander/index.d.ts"
    /// <reference path="main/ambient/node/index.d.ts" />


Since they're duplicates to each other, and causes compilation warnings (a lot of them!)
if not treated. Therefore in `tsconfig.json` you need to exclude
the portion (either broser or server) you don't intend to include when TypeScript compiles the project.
E.g., this project is a node project, so I excluded all browser ones by
specifying in `tsconfig.json`:

    "exclude": [
        "typings/browser.d.ts",
        "typings/browser"
    ]


Working with Promisified Node Modules
====

It's common to `promisifyAll` a node module. Since you want to use the
`*Async()` function variants, and they don't have definitions since they're
interpolated by `bluebird`, sadly all intellisense and type checking for them
are gone. 

    import fs = require('fs');
    import cp = require('child_process');

    Promise.promisifyAll(fs);
    Promise.promisifyAll(cp); 

    async function main() : Promise<string> {
        let content : string = await fs.readFileAsync('./package.json', 'utf8');
        console.log(content);

        let out : string = await cp.execAsync('cmd.exe /c dir');
        console.log(out);

        return content;
    }


The pattern I adopted is to type `fs.readFile`, filling in the parameters except
the callback, and then append the `Async` to the function name. Note that this
way `tsc` would complain no such functions. An alternative to that is:


    import fs = require('fs');
    import cp = require('child_process');

    let fs2 = Promise.promisifyAll(fs);
    let cp2 = Promise.promisifyAll(cp); 

    async function main() : Promise<string> {
        let content : string = await fs2.readFileAsync('./package.json', 'utf8');
        console.log(content);

        let out : string = await cp2.execAsync('cmd.exe /c dir');
        console.log(out);

        return content;
    }

The benefit is now that compilation errors are gone. But when you need
intellisense, you would type `fs.readFile` first, then convert that to
`fs2.readFileAsync` when you're ready.

Theoretically speaking, someone would hand craft a `promisified-node.d.ts` for
all the `*Async()` functions. That took a lot of patience to me, but would be
greatly joyful to use:)
