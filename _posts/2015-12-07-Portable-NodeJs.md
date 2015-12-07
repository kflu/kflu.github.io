---
layout: post
title: Portable Node.Js Installation
comments: true
---

I've been looking for a way to deploy Node.Js apps onto machines that doesn't have the Node.Js runtime installed, more particularly, on Windows machines. I've been looked into various tools to "package" the app, the runtime, and all its dependencies into a single executable. None of those tools work properly. Luckily, it is much easier than I thought to setup a portable Node.Js environment, e.g. all through files copies and without registry change. [This is the original discussion inspired me][portable-node].

For the runtime, all you need is a single executable `node.exe`, or `node.lib` if this is to be linked to an application. The latest runtime build is available at http://nodejs.org/dist/latest. If you need `npm`, download it from http://nodejs.org/dist/npm/ and unzip it to where `node.exe` is. Now your portable node installation will look like:

    node
    |- node.exe
    |- npm.cmd
    `- node_modules\

Now you can use node and npm from anywhere on the system:

    <path_to_node>\npm init
    <path_to_node>\npm install express
    <path_to_node>\node <your_script.js>

[portable-node]: https://github.com/nodejs/node-v0.x-archive/issues/3978
