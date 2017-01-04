---
layout: post
title: Auto Deploy Hexo.io to Github Pages With Travis CI
comments: true
date: 2017-01-03
---

## References
- [Github pages][ghp]
- [Github Access tokens](https://github.com/settings/tokens)
- [Static site generators][gens]
- Hexo
    - [setup][hexosetup]
    - [config][hexoconfig]
    - [themes](https://hexo.io/themes/)
- Travis
    - [Configure the build](https://docs.travis-ci.com/user/customizing-the-build/)
    - [Encrypting data in `travis.yml` (not used)](https://docs.travis-ci.com/user/encryption-keys/)

_This article is inspired by [this](http://www.tuicool.com/articles/AZf2Yzb) and [this](https://xin053.github.io/2016/06/05/Travis%20CI%E8%87%AA%E5%8A%A8%E9%83%A8%E7%BD%B2Hexo%E5%8D%9A%E5%AE%A2%E5%88%B0Github/)._

With Travis CI, every time new change is made to the site repo, a build will kick off
on Travis and deploy the updated site to Github pages. This is not a trivial process, so
this article describes the idea behind each piece and documents details.

## Github Pages

[Github pages][ghp] is a github service to host static web sites. It works by rendering static 
files (HTML, etc.) that are checked in as a github repo at a special URL (e.g, https://<username>.github.io/project).

Nowadays people don't write static HTMLs manually, but rather writing articles/posts
in markdowns (or other markups) and relying on other tools to generate the HTMLs/stylesheets.

There are many of those static site generators. [Here's a nice list of the most popular ones][gens].

One problem using these tools with github pages is that you have to have a computer with the tool installed to generate
the site and then publish it. If you're somewhere with no access to the tool then you can't publish posts.

With the help of Travis CI, this scenario becomes possible:

1. create a post directly via Github repo web UI.
2. Travis automatically invokes build process
3. Travis deploys the updated site to Github pages


## Setup github repo

There're many ways to setup Github pages. I use the following setup:

1. branch `master` contains the generated site, which will be rendered directly
2. branch `source` contains the raw articles and files necessary to generate the site


Follow [instruction for Hexo.io][hexosetup] to scaffold the `source` branch. Your `source` branch should look like this:

    .
    |   .gitignore
    |   .travis.yml
    |   db.json
    |   package.json
    |   _config.yml
    |   
    +---scaffolds
    |   \--- ...
    |       
    +---source
    |   \---_posts
    |           hello-world.md
    |           
    \---themes
        \--- ...

### Hexo themes
[Hexo themes][themes] can be downloaded. But do not git clone into the repo as you can't udpate and commit the theme's `_config.yml`
as it will be treated as a git submodule. Instead, download it and unzip into your repo. 

### Hexo configs
Both the site-level and theme-level `_config.yml` needs to be updated. Refer to the [Hexo doc][hexoconfig] and the theme doc on how to update them.

### Hexo Workflow

1. `hexo clean`
2. `hexo generate`
3. `hexo deploy`


Once that worked, you can start working on enabling travis.


## Setup Travis CI

Travis listens to your repo's commit event and invokes build process specified in the repo's `.travis.yml` file of the triggering branch.
travis script is run in a Linux environment so you can use shell commands.

I put the actual site generating commands in `package.json` so I can use npm to run them:

    "scripts": {
      "build": "hexo clean && hexo generate && hexo deploy"
    },


Then in `.travis.yml`:

    language: node_js
    node_js:
    - 6.0.0
    branches:
      only:
      - source

    install: npm install

    before_script:
    - git config --global user.name "KL"
    - git config --global user.email "kfldev@outlook.com"
    - sed -i "s/__GITHUB_TOKEN__/${__GITHUB_TOKEN__}/" _config.yml

    script: npm run build

Note that in order for Travis to deploy to github repo, it needs to have access. I got the github access token from [here](https://github.com/settings/tokens).
Then the repo can be accessed via URL `https://<TOKEN>@github.com/<user>/<repo>`. For security reason this token should NOT be checked in but should be 
specified in Travis repo settings as an environment variable. Then replace the URL in hexo config with this vairable at build time. 

In hexo `_config.yml`:

    deploy:
      type: git
      repo: https://__GITHUB_TOKEN__@github.com/user/blog.git
      branch: master


`__GITHUB_TOKEN__` is replaced with `sed` by travis script.


[ghp]: https://pages.github.com/
[gens]: http://www.staticgen.com/
[hexosetup]: https://hexo.io/docs/setup.html
[hexoconfig]: https://hexo.io/docs/configuration.html
