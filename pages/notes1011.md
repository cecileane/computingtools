---
layout: page
title: 10/11 notes
description: course notes
---
[previous](notes1006.html) & [next](notes1013.html)

---

## homework

due today: exercise 3 from [homework 1](https://github.com/UWMadison-computingtools/coursedata/tree/master/hw1-snaqTimeTests).  
15 minutes Q&A on this homework: bring your questions to get help/feedback from your peers.

## Git: continued

- past notes: [part 1](notes0927.html) and [part 2](notes0929.html)
- [checking out older versions](#checking-out-older-versions)
- [branches](#branches) and [merging branches](#merging-branches)
- [some other git subcommands](#some-other-git-subcommands)
- [sha checksums](#sha-checksums)
- a git-aware [shell-prompt](notes1006.html#changing-your-shell-prompt)

### warnings

- do **not** update your github repository by uploading files from the browser: this creates commits that are not on your local laptop repository. If you make changes from the browser, you will have to do a `git pull` the next time you work on your laptop, to pull the changes from github into your local repo.

- git desktop does not always let you control and see everything: prefer the command line, understand things under the hood.

- do not track/commit `.Rhistory` files, or `.DS_Store` files, or temporary files. Be in control of what you track and what you commit.

### checking out older versions

Let's recover some old version now, *just for one file*,
then go back to latest committed version:

```shell
git log --graph # copy-paste the SHA from just before divergence
cat readme.md
git checkout 7d82504d7dfb3 -- readme.md # changes the file and adds it
cat readme.md
git status  # the changes were added to staging area
git log --graph --abbrev-commit --pretty=oneline
git checkout master -- readme.md # back to version from master
```

To recover some old version for the *whole* project:
`git checkout commit-sha` or `git checkout tag-name`.
Then come back to the latest version on the "master" branch with `git checkout master`.
Example (do this on your own homework repo):

```shell
cd ../studenthw/coraAllenColeman/homework/hw1/hw1-snaqTimeTests/
less summarizeSNaQres.sh # using "basename": for exercise 3
git log --graph --oneline --all --decorate
git checkout v1.2 # tag "v1.2" placed at commit 7507dd0. "detached HEAD"
git log --graph --oneline --all --decorate # HEAD not pointing to any branch
less summarizeSNaQres.sh # not using "basename"
git checkout 9a21e1f # or full sha: 9a21e1fac871804d5fd8918a7d3ce77cc24153be
git show
git log --graph --oneline --all --decorate
git checkout master # back to latest statements
git log --graph --oneline --all --decorate # HEAD re-attached to a branch
```

On github: easy to browse a project at any old version,
really easy at tagged versions:
[example](https://github.com/BaconZhou/stat679work/tree/master/hw1)

### branches

Branches are very useful to easily switch back and forth between different
versions. Each version can still evolve.

Imagine that I want to develop a new aspect of the project, not ready to
work with the rest of the pipeline --say risky edits to the `readme` file (!):

```shell
cd ~/Documents/private/st679/zmays-snps/
git pull origin master # pull often! Perhaps Rebecca did some cool work.
git branch readme-changes # creates a branch
git branch # lists the existing branches
git checkout readme-changes # switches the current branch
git branch
git log --abbrev-commit --graph --pretty=oneline --all --decorate
```

Now let me make a bold move and make thorough edits to my readme file,
then commit my changes:

```shell
git commit -a -m "reformatted readme, added sample info"
git log --oneline --graph -n 5 --all --decorate
git branch
git checkout master
git log --oneline --graph -n 5
git log --oneline --graph --all --decorate
cat readme.md # old version: on master branch
echo ">adapter-1\\nGATGATCATTCAGCGACTACGATCG" >> adapters.fa
git add adapters.fa # add a new file. on master branch here
git commit -a -m "added adapters file"
git log --abbrev-commit --pretty=oneline --graph --branches -n6
```

Branches are like pointers. They do not hold info. Commits do.

### merging branches

Imagine that I am happy with the new developments done in branch "readme-changes",
and it's ready to be used by my collaborators on the main "master" branch.

```shell
git checkout master
git branch # to triple-check we are on master
git pull origin master # pull often! just in case Rebecca did some cool work in the meantime
git merge readme-changes # no conflict, yes! enter commit message
git log --abbrev-commit --graph --pretty=oneline --all --decorate
git push origin master
```

This is a merge commit with 2 parents:
just like when we resolved a conflict earlier.  
We can use *remote* branches too. Rebecca could pull my changes,
including the new "readme-changes" branch, and switch to it if she wanted
to collaborate on this branch.  
When all done with this branch, I can delete it:

```shell
git branch -d readme-changes
```

<!--
### remote branches

Now Rebecca creates a branch "new-methods" ...
but pull first: remember to pull often!

```shell
# Rebecca does this:
git pull origin master
git branch new-methods
git branch
git checkout new-methods
```
-->

### some other git subcommands

- `git commit --amend` to add change the last commit message.
  But **do not** do this if you already pushed your change to github.

- `git revert` to revert changes (creates a new commit).
  For example, to undo the last commit, we would do: `git revert HEAD`.
  This would *create a new commit* whose actions would cancel the
  actions of the last commit.
  To undo the changes of the second-to-last commit (but not the changes
  in the last commit), we would do: `git revert HEAD~1`.
  This is safe, and much recommended if you already pushed to github
  the commits to be undone.

- `git reset` and `git rebase`: I very highly recommend that you **do not**
  use them, until you know exactly what you do. Even then, do **not**
  use them if you already pushed your commits to github.

- github provides more options: forks (multiple public repositories),
  pull requests.

### SHA checksums

SHA = security hash algorithm,
used by git to guard again data corruption.  
A small change in the input causes many changes in the SHA value.  
It is a good idea to record the SHA values of important data files
as metadata (in readme file).

```shell
$ echo "this sentence is super cool" | shasum
93aff6c8139fff6855797afc8ea7a7513ffabb6f  -
$ echo "this sentence is duper cool" | shasum
97c250becdaa49c62721478c7f82d116e1039e0e  -
$ shasum data/seqs/* # copy-paste results in readme file
$ md5 data/seqs/*    # alternatively: record MD5 checksums
```

check [RStudio](https://www.rstudio.com/products/rstudio/download/)
download page for MD5 checksums: to make sure that what you get
on your laptop is the true and uncorrupted thing:
`md5 RStudio-downloadedfile.zip` and compare with expected MD5 value.

<!--
example algorithm: consider each pair of byte as an integer in 0-15,
add them all up, return their value modulo 16: hexadecimal code in 0-9a-f
-->

---
[previous](notes1006.html) & [next](notes1013.html)
