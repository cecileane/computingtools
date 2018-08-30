---
layout: page
title: installing julia
description: julia, jupyter
---

Follow their instructions to install the latest version of
[julia](https://julialang.org),
currently v1.0.2.

On a Mac, I created a link to the Julia executable in a
directory on my PATH, to be able to start julia
from a terminal:

```shell
ln -s /Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia /usr/local/bin/julia
```

To test that your installation worked, try

```shell
$ julia --version
julia version 1.0.2
$ julia
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.0.2 (2018-11-08)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia> 2+2
4
```
then click Control-D to quit julia, or `exit()`.

To get help on Julia, use the extensive and well-written
[documentation](https://docs.julialang.org/en/v1/)

- Jupyter can use Julia as its backend kernel
- in VS Code: get the
  ["Julia" extension](https://github.com/JuliaEditorSupport/julia-vscode)
  to recognize `.jl` files as julia scripts
  (although this extensions does not support julia v1.0 yet, only v0.6),
  and [Markdown Julia](https://github.com/colinfang/markdown-julia)
  to get syntax highlighting in julia code blocks
- in Atom:
  * get the package
    [atom-language-julia](https://github.com/JuliaEditorSupport/atom-language-julia)
  * or get the [Juno](http://junolab.org)
    Integrated Development Environment (IDE)
- see also
  [JuliaEditorSupport](https://github.com/JuliaEditorSupport)
  for other editors (vim, emacs) and further developments

next:
- julia [intro](notes1206.html)
- installing [packages](notes1206-juliapackages.html)
