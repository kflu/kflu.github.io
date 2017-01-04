---
layout: post
title: Debugging Yeoman generators
comments: true
date: 2016-05-11
---

I found myself sending much more time than I want to make one of my Yeoman
generators to work. It's hard because by default, Yeoman is so user friendly
that it decides to swallow all error information. So if something failed, it
silently completes, leaving an empty directory to you.

I found the most useful thing is to tell it to display error information. It can
be achieved by setting environment variable `DEBUG=yeoman:generator` in the
shell, and then run the generator. This time, it's more developer friendly:

    PS> yo kfl-node
      yeoman:generator Queueing prompting in prompting +0ms
      yeoman:generator Queueing writing in writing +4ms
      yeoman:generator Queueing install in install +3ms
      yeoman:generator Running prompting +20ms
    ? Your project name (serman)
    ? Your project name serman
      yeoman:generator Running writing +8s
      yeoman:generator An error occured while running writing +16ms { AssertionError: Trying to copy from a source that does not exist: C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\generators\app\templates\.gitignore
        at EditionInterface.exports._copySingle (C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\node_modules\mem-fs-editor\lib\actions\copy.js:45:3)
        at EditionInterface.exports.copy (C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\node_modules\mem-fs-editor\lib\actions\copy.js:23:17)
        at module.exports.yeoman.Base.extend.writing (C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\generators\app\index.js:26:15)
        at Object.<anonymous> (C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\node_modules\yeoman-generator\lib\base.js:436:25)
        at C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\node_modules\run-async\index.js:26:25
        at C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\node_modules\run-async\index.js:25:19
        at C:\Users\kfl\AppData\Roaming\npm\node_modules\generator-kfl-node\node_modules\yeoman-generator\lib\base.js:452:8
        at tryOnImmediate (timers.js:543:15)
        at processImmediate [as _immediateCallback] (timers.js:523:5)
      name: 'AssertionError',
      actual: false,
      expected: true,
      operator: '==',
      message: 'Trying to copy from a source that does not exist: C:\\Users\\kfl\\AppData\\Roaming\\npm\\node_modules\\generator-kfl-node\\generators\\app\\templates\\.gitignore',
      generatedMessage: false }


Some other tips (may also apply to general node.js developing):

* Always test it out locally (`npm link`) before publishing
* Always `npm pack` and examine the package before publishing
* Always `git clean -xd -n` before `npm pack` to eliminate unwanted files


Another caveat that cost me an hour - in my generator template I have a
`.gitignore`. But `npm publish` insists to leave it out of the package, which in
turn caused a silent failure when I `yo` the generator. *Note* that this error
cannot be caught with local testing `npm link`. But you might spot it manually
inspect the package tarball if you are more carefully than I was.

[Here][1] is the document for Yeoman debugging.

[1]: http://yeoman.io/authoring/debugging.html
