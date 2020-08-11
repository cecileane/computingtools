---
layout: page
title: git to check old versions, branch & merge parallel versions, sha
description: course notes
---
[previous](notes1006.html) &
[next](notes1013.html)

---

- past notes on [git](notes0927.html) and [github](notes0929.html)
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
then go back to latest committed version, `zmays-snps` repo:

```shell
git pull
git log --graph # copy-paste the SHA from just before divergence
cat readme.md
git checkout 832eabda4cb -- readme.md # changes the file and adds it
cat readme.md
git status  # the changes were added to staging area
git log --graph --abbrev-commit --pretty=oneline
git checkout master -- readme.md # back to version from master
```

To recover some old version for the *whole* project:
`git checkout commit-sha` or `git checkout tag-name`.
Then come back to the latest version on the "master" branch with `git checkout master`.
Example (do this on your own class notes repo or hw1 repo):

```shell
cat readme.md
git log --graph --oneline --all --decorate
git checkout v1.0 # tag "v1.0" placed at commit 946009d. "detached HEAD"
git log --graph --oneline --all --decorate # HEAD not pointing to any branch
less readme.md
git checkout short_or_full_sha
git show
git log --graph --oneline --all --decorate
git checkout master # back to latest statements
git log --graph --oneline --all --decorate # HEAD re-attached to a branch
```

application to your homework 1 project: use `git checkout v1.2` to
and look at your script and `readme.md` from exercise 2, then switch
back to the current version of your script with `git checkout master`.

on github: easy to browse a project at any old version,
really easy at tagged versions:
[example](https://github.com/UWMadison-computingtools-2020)

### branches

Branches are very useful to easily switch back and forth between different
versions. Each version can still evolve.

Imagine that I want to develop a new aspect of the project, not ready to
work with the rest of the pipeline --say risky edits to the `readme` file (!):

```shell
git pull origin master # pull often! Perhaps you guys added some cool things.
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

- Branches are like pointers. They do not hold info. Commits do.
- in VS Code: name of the current branch in the lower left-hand corner.
  If we click on that name, it brings up a menu of branches and
  versions that we can select from.

### remote branches

We can use *remote* branches too. You could pull my changes,
including the new "readme-changes" branch, and switch to it if you wanted
to collaborate on this branch.

```shell
git branch -vv
git push -u origin readme-changes
git branch -vv
```

on [github](https://github.com/UWMadison-computingtools-2020/zmays-snps):
the branch will appear, so you can all get it:

```shell
git fetch --all
git checkout readme-changes
# git checkout --track origin/readme-changes # if older git version
git branch -vv
```

### collaborating on parallel branches

Now a volunteer creates a branch "script" ...
but pull first: remember to pull often!

```shell
# 1 volunteer does this:
git checkout master
git pull origin master
git branch samplescript
git branch
git branch -v
git checkout samplescript
git branch -vv
```

then add a bold new script:

```shell
echo "ls data/seqs/*.fastq | sed -E 's/.*zmays(.*)_R[12].fastq/\1/' | sort | uniq -c" > scripts/list-samples.sh
echo "list-samples.sh: run from the main folder. lists the sample names with the number of files for each." >> scripts/readme.md
chmod u+x scripts/list-samples.sh
git add scripts/list-samples.sh
git commit -am "script to list samples with data"
```

and push it to github to share the work:

```shell
git branch -vv
git push -u origin samplescript
git branch -vv
git log --abbrev-commit --graph --pretty=oneline
```

and we can all get it:

```shell
git fetch --all
git checkout samplescript
# git checkout --track origin/readme-changes # if older git version
git branch -vv
ls scripts
cat scripts/list-samples.sh
bash scripts/list-samples.sh
git checkout master
git branch -a
```

### merging branches

Imagine that I am happy with the new developments done in branch "readme-changes",
and it's ready to be used by my collaborators on the main "master" branch.

```shell
git checkout master
git branch # to triple-check we are on master
git pull origin master # pull often! just in case you guys did some cool work in the meantime
git merge readme-changes # no conflict, yes! enter commit message
git log --abbrev-commit --graph --pretty=oneline --all --decorate
git push origin master
```

This is a merge commit with 2 parents:
just like when we resolved a conflict earlier.  
When all done with this branch, I can delete the local branch on my laptop:

```shell
git branch -d readme-changes
```

and also delete the remote branch on github:

```shell
git push origin --delete readme-changes
```

all: check on github,
pull the changes (merge & deletion of the remote branch),
and clean up:

```shell
git fetch --all
git branch -a
git fetch --prune
git branch -a
git branch -d readme-changes
git branch -a -vv
git log --abbrev-commit --graph --pretty=oneline
```

volunteer to merge the `samplescript` branch, push the merge, and delete the branch?

### some other git subcommands

- `git stash`: creates something like a temporary snapshot, to save
  changes that are not ready for a commit when you need to get back
  to the previous commit.
  Example use: you made changes, working from the master branch, and
  realize that these changes will need to be committed on a different branch.
  `git stash` will temporarily save those changes and
  back out to the previous commit. You can then create the new branch
  and switch to it: `git checkout -b mybranch`, then do
  `git stash pop` to bring those changes back (but now on the desired branch).

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

checksum: quick check to verify that file transfer had no error.  
simplest idea: add up all bits in file (modulus 2),
or add up all "nibbles" (modulus 2<sup>4</sup> = 16)  
hexadecimal code, or digits to count in base 16, from 0 to 15:
0 (0000), 1, ..., 8 (1000), 9, a, b, c, d, e, f (1111)

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

---
[previous](notes1006.html) &
[next](notes1013.html)
