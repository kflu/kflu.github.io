---
layout: post
title: New Javascript direction
comments: true
date: 2016-03-23
---

This is to quickly summerize my recent thinking into using JS. There're many options, coffeescript, typescript, even livescript. Liked all of them. But I in general like something plain. So this suites me better:

* Babel to enable ES6 and ES7 (async-await)
* bluebird to promisify Node APIs

This generally solves the problem of callback hell. Promises was a step further. But ultimately it comes to async-await. I'm not too worried about type safety, which TypeScript provides. But the requirement of `.d.ts` declarations scared me away. No thank you. Maybe later.

In `.babelrc`:

```
{
  "presets": ["es2015"],
  "plugins": ["syntax-async-functions","transform-regenerator"],
  "sourceMaps": true
}
```

In `package.json`:

```
{
  "name": "awesome-async",
  "version": "1.0.0",
  "description": "",
  "main": "github.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "dependencies": {
    "babel-plugin-syntax-async-functions": "^6.1.4",
    "babel-plugin-transform-regenerator": "^6.1.4",
    "babel-polyfill": "^6.1.4",
    "babel-preset-es2015": "^6.1.4",
    "bluebird": "^3.3.4"
  }
}
```

In `test.es6`:

```
require('babel-polyfill');
var Promise = require('bluebird');
var fs = Promise.promisifyAll(require("fs"));

async function read(p) {
    var data = await fs.readFileAsync(p, 'utf8');

    /*
     * data is the actual file content. You can print it:
     *
     * 		console.log(data);
     *
     * But if it's returned from this function, it's wrapped
     * into a Promise
     */
    return data;
}

/*
 * async functions return Promises!!!
 *
 * Note: you can't await outside of async:
     var data = await read('package.json');
 */
read('package.json').then(console.log);

```

Now run:

```
> babel test.es6 -o test.js --source-maps
> node test.js
```

Note that async await needs polyfill the app, and hence the `require('babel-polyfill');` statement at the beginning of the script. Note that polyfill only needs to be done once for the app. So if you don't want to pollute the business logic code base, write a opt-level wrapper to polyfill and call the actuall logic.
