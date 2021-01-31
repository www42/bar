---
layout:     post
title:      "GitHub Pages - Getting started"
date:       2021-01-28 17:30:00 +0100
categories: Git GitHub GitHub-Pages
image1:     /assets/images/2021-01-28-github-pages/configure-source.png
image2:     /assets/images/2021-01-28-github-pages/chose-theme.png
---

[jekyll-home]: https://jekyllrb.com/
[githubpages-home]: https://pages.github.com/
[bill-raymond-playlist]: https://www.youtube.com/watch?v=EvYs1idcGnM&list=PLWzwUIYZpnJuT0sH4BN56P5oWTdHJiTNq
[aft-repo-folder]: https://github.com/www42/AFT/tree/main/GH-Pages


You can find files used in this post [here][aft-repo-folder].


# Where to start?

Best way to learn GitHub Pages is [Bill Raymond's playlist at youtube][bill-raymond-playlist].

All about the software behind the scenes: [Jekyll homepage][jekyll-home]


# Configure GitHub Pages to host a web site

* On GitHub create a new repo "bar"
* Activate and edit README.md
* Settings - GitHub Pages source main /(root)
* About - Paste URL www42.github.io/bar

![Configure source]({{ page.image1 | relative_url }})


| GitHub               | GitHub Pages
| ---------------------| -------------------
| github.com/www42/bar | www42.github.io/bar


# Priority order of index file

    1.  index.html
    2.  index.md
    3.  README.md


# Jekyll themes out of the box

Settings:

![Choose theme]({{ page.image2 | relative_url }})

Chose whatever you want.

Keep in mind: No local Jekyll installation is needed. The site generation process is done automatically and remotely by GitHub Pages. And it's free of charge 😀
