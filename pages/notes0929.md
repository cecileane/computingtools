---
layout: page
title: git and GitHub to track and share versions
description: course notes
---
[previous](notes0927.html) &
[next](notes1004.html)

---

- [using git for course notes](#recap-from-last-time-track-course-notes)
- [pushing to / pulling from github to work with others](#pushing-to--pulling-from-github-to-work-with-others)
- [resolving conflicts: merge commits](#resolving-conflicts-and-merge-commits)
- general [warnings](#warnings) & advice

### practice: use git for your course notes

how to turn an existing git repository into a normal benign folder?

exercise:

- create a new folder to take course notes in markdown `.md` files,
  if you don't already have one, **outside** of any existing git repository
  (check with `git status`)
- go inside:
  * create a new file `git-notes.md` with some of your notes
  * run `git init` to turn your folder into a git repository
  * ask git to track your file `git-notes.md`
  * commit your work
  * add some more notes / links
  * commit these new changes
- add something silly: like remove 1 or 2 lines, as if accidentally (and save).  
  make sure you had committed your work **before** saving these mistakes.
- undo these mistakes using git
- to include later: thoughts, example scripts, commands or one-liners,
  links to videos, blogs or other resources on the topic that you found useful,
  etc.

exclude from this repository any other work that belongs in a different repository:

- homework folders & files
- your `zmays` repository

alternatively:

- turn an existing project into a git repository --ideally a project
  that you can share publically on github, and
  use this project to practice with github later
- make sure to clean up your project folder: with a good structure,
  informative readme files, metadata for your data,
  remove files that don't belong, etc.
- this alternative is more high-stake, so not the best choice to get
  safe practice with git, but perhaps more useful for your own research.

### pushing to github to work with others

various repositories:
cecile (laptop) -- central (claudia's github) -- claudia (laptop)  
we can: `git push`, `git clone`, `git pull`, `git fetch` (to check before), `git merge`

To illustrate this, I will to create a central repository:
I'll go to my account on
[github](https://github.com/cecileane), click "New repository",
name it "zmays-snps", and invite a collaborator (settings -> manage access).
Then back to my shell to link my local repository
to the new central repo on github:

```shell
git remote -v
git remote add origin git@github.com:cecileane/zmays-snps.git
git remote -v
git branch
git push -u origin master  # -u is to remember to "track" this remote place
```

Now let's go back to [github](https://github.com/cecileane/zmays-snps)
to check! Go check the "network" page to visualize the list of commits
(in Graphs tab)

Note: If you had your own `zmays-snps` repository after following along
in the previous sections, and if you want to collaborate on the
github repository that I just created, then rename your own repository, e.g:

    mv zmays-snps my-zmays-snps

Your history is unlikely to be the same as the one now on github, and
the default name of the folder you will get from github is `zmays-snps`.
So a conflict would arise if you won't delete or rename your repo.

### practice: push your course notes to github

Navigate to the git repository that you created for your **course notes**,
and push it to github with these steps:
- go to your github account (click the octocat from any github page)
- click 'New Repository', give it a name easy to type,
  do **not** initialize it with a README file because you already have your local repo
- add the remote url on github: adapt below to the url of your own new repo

```shell
git remote -v
git remote add origin git@github.com:your_user_name/your_repo_name.git
git remote -v # check the nickname for your central (github) repo. default: origin
git branch # to double-check which branch you are on. default: master or main
git push -u origin master # pushes current local branch to repo "origin", its branch "master"
```

### pulling from github

back to the "zmays-snps" repository on github: clone it.
first navigate to a directory that is
*not* already a git repository.
Do `git status` to check: make sure you get an error!
Then:

```shell
# you do this, after checking that you are outside of a git repo:
git clone git@github.com:cecileane/zmays-snps.git
cd zmays-snps
git remote -v
```

Let me can start working on the project, say add metadata info:

```shell
# Cecile doing this:
echo "Samples expected from sequencing facility 2020-09-30" >> readme.md
git commit -a -m "added information about samples"
git push origin master # or just "git push" if my branch "master" knows what it's tracking
git log --pretty=oneline --abbrev-commit
gl # this is my own alias for "git log" with particular options
type gl
git log --abbrev-commit --graph --pretty=oneline --all --decorate
```

check the update on
[github](https://github.com/cecileane/zmays-snps);
and pull these changes from the shell.
It will look something like this:

```shell
$ git branch -vv
$ git pull origin master # you doing this. or just: git pull
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (3/3), done.
￼...
From github.com:cecileane/zmays-snps
...
Fast-forward
 readme.md | 1 +
 1 file changed, 1 insertion(+)
-> FETCH_HEAD
-> origin/master
$ git log --pretty=oneline --abbrev-commit
```

Next, my collaborator can work on the project, say add more metadata still:

```shell
# collaborator doing this. -e to interpret \n as newline
echo -e "\n\nMaize reference genome version: refgen3" >> readme.md
git commit -a -m "added reference genome info"
git push origin master
```

everyone: can get this new work on their laptop (also check on github):

```shell
git pull origin master # Cecile doing this
cat readme.md
git log # viewed with less
git log -n 2
```

Very important:

- pull often!
- commit your changes before pulling. Any change to an uncommitted file
  would stop the pull update.

### resolving conflicts and merge commits

Now let's create a conflict to see how to resolve it.
Let me and my collaborator make changes to the same file, at roughly the same place:

```shell
# collaborator does this:
echo -e ", downloaded 2020-09-26 from\nhttp://maizegdb.org into /share/data/refgen3/." >> readme.md
git commit -a -m "added download info"
git push origin master
```

while I open `readme.md` to change the last line to this:

> We downloaded refgen3 on 2020-09-26.

then I also commit and push:

```shell
# Cecile does this:
git commit -a -m "added genome download date"
git push origin master # Ahh, problem!!
```

The push was rejected!
I should have pulled the update from github first, before editing the file!
Now I have to pull from github: perhaps it will be smooth,
perhaps there will be conflict. If so, it's my responsibility to resolve
the conflicts:

```shell
# Cecile does this:
git pull origin master
git status # conflict. tells me what to do to resolve it
git log --pretty=oneline --abbrev-commit
```

I need to edit the file with the conflict: git told me it's `readme.md`,
then search for:

- `<<<<<<< HEAD` : beginning of my version, then
- `=======` boundary: end of my version and beginning of fetched version, then
- `>>>>>>> SHA value`: end of new, fetched version,
  with volunteer 2's commit indicated by its SHA.

I can now edit this file and remove these 3 marks (there may be multiple blocks
of conflicts, each with these 3 marks). Let me replace both versions with
some improved information:

  > We downloaded the B73 reference genome (refgen3) on 2020-09-26 from
  > http://maizegdb.org into `/share/data/refgen3/`.

let's continue to follow git's instructions:

```shell
# Cecile doing this:
git status
git add readme.md
git status
git commit -a -m "resolved merge conflict in readme.md"
git status
git log --abbrev-commit --pretty=oneline --graph
git push origin master
```

last step: quickly push the conflict resolution before another team member
does some more work. Lesson: **all team members should pull often!**

```shell
# you all do this:
git pull origin master
git log --graph
```

- merge commits have 2 parents, unlike usual commits.
- if you feel overwhelmed during a merge, do `git merge --abort`
  and start the various merge steps from scratch.
- remember: `git status` gives instructions

### warnings & advice

- do **not** update your github repository by uploading files from the browser:
  this creates commits that are not on your local laptop repository.
  If you make commits from the browser, you will have to do a `git pull`
  the next time you work on your laptop, to pull the changes from github into
  your local machine.

- git desktop does not always let you control and see everything:
  prefer the command line, understand things under the hood.

- do not track/commit `.Rhistory` files, or `.DS_Store` files,
  or temporary files. Be in control of what you track and what you commit.

- always do `git status` and `git diff` before making a commit:
  that's where we would catch that an unwanted file would get committed,
  or that we added a typo, or forgot something etc.

---
[previous](notes0927.html) &
[next](notes1004.html)
