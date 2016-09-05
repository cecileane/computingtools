---
layout: page
title: 9/29 notes
description: course notes
---
[previous](notes0927.html) & [next](notes1004.html)

---

## homework

due T 10/4: submit your solution to exercises 1 & 2 of homework 1
using git and github: see
[submission instructions](https://github.com/UWMadison-computingtools/coursedata#commit-push-and-submit-your-work).
Also see the [grading rubric](https://github.com/UWMadison-computingtools/coursedata/blob/master/rubric.md). Make sure

- your code is annotated with comments in the scripts
- you have readme files to give higher-level explanations and all
  the tools (commands) to reproduce your results.
- you do *not* need to commit the input files (in `out/` and `log/` directories).
  I already have them. No big deal if you did already, though.

## Git: continued

- [using git for hw 1](#recap-from-last-time-using-your-homework)
- [pushing to / pulling from github to work with others](#pushing-to--pulling-from-github-to-work-with-others)
- [resolving conflicts: merge commits](#resolving-conflicts-and-merge-commits)

### recap from last time: using your homework

- how would you turn an existing git repository into a normal benign folder?
- go to your work folder (containing homework 1 only, for now):
  * ask git to track your script(s) for homework 1
  * commit your work
  * add some more documentation / explanations
  * commit these new changes
- add something silly: like remove 1 or 2 lines, as if accidentally (and save).  
  make sure you had committed your work **before** saving these mistakes.
- undo these mistakes using git

### pushing to / pulling from github to work with others

various repositories:
cecile (laptop) -- central (claudia's github) -- claudia (laptop)  
we can: `git push`, `git clone`, `git pull`, `git fetch` (to check before), `git merge`

To illustrate this, I will to create a central repository:
new repository owned by "UWMadison-computingtools", say. I'll go to
[github](https://github.com/UWMadison-computingtools), click "New repository",
name it "zmays-snps". Then back to my shell and link my private repository
to the new central repo on github:

```shell
git remote -v
git remote add git@github.com:UWMadison-computingtools/zmays-snps.git
git remote -v
git branch
git push origin master
```

Now let's go back to [github](https://github.com/UWMadison-computingtools/zmays-snps)
to check! Go check the "network" page to visualize the list of commits
(in Graphs tab)

your turn: push your homework to github:

```shell
git branch # to double-check which branch you are on. default: master
git remote -v # check the nickname for your central (github) repo. default: origin
git push origin master # pushes current local branch to repo "origin", its branch "master"
```

Now I need a collaborator. Volunteer?
(check that you can push to github easily: `ssh -T git@github.com` should
give you a "Hi!" message)

You can all pull the repository: first navigate to a directory that is
*not* already a git repository (do `git status` to check). Then:

```shell
# Rebecca doing this:
git clone git@github.com:UWMadison-computingtools/zmays-snps.git
cd zmays-snps
git remote -v
```

Let me can start working on the project, say add metadata info:

```shell
# Cecile doing this:
echo "Samples expected from sequencing facility 2016-09-30" >> readme.md
git commit -a -m "added information about samples"
git log --pretty=oneline --abbrev-commit
gl # this is my own alias for "git log" with particular options
type gl
git log --abbrev-commit --graph --pretty=oneline --all --decorate
```

(check the update on github). You can pull these changes from the shell:

```shell
$ git pull origin master # Rebecca doing this
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (3/3), done.
￼...
From github.com:UWMadison-computingtools/zmays-snps
...
Fast-forward
 readme.md | 1 +
 1 file changed, 1 insertion(+)
-> FETCH_HEAD
-> origin/master
$ git log --pretty=oneline --abbrev-commit
```

Next, Rebecca can work on the project, say add more metadata still:

```shell
# Rebecca doing this. -e to interpret \n as newline
echo -e "\n\nMaize reference genome version: refgen3" >> readme.md
git commit -a -m "added reference genome info"
git push origin master
```

Rebecca could "push" because I invited her to be a collaborator to the project.
I can get her work easily (also check on github):

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
Let me and Jonathan make changes to the same file, at roughly the same place:

```shell
# Rebecca does this:
echo -e ", downloaded 2016-09-27 from\nhttp://maizegdb.org into `/share/data/refgen3/`." >> readme.md
git commit -a -m "added download info"
git push origin master
```

while I open `readme.md` to change the last line to this:

> We downloaded refgen3 on 2016-09-27.

then I also commit and push:

```shell
# Cecile does this:
git commit -a -m "added genome download date"
git push origin master # Ahh, problem!!
```

The push was rejected!
I first need to pull Rebecca's update. Perhaps it will be smooth,
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
  with Jonathan's commit indicated by its SHA.

I can now edit this file and remove these 3 marks (there may be multiple blocks
of conflicts, each with these 3 marks). Let me replace both versions with
some improved information:

  > We downloaded the B73 reference genome (refgen3) on 2016-09-27 from
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

last step: quickly push the conflict resolution before Rebecca
does some more work. Lesson: both Rebecca and I should pull often!

```shell
# Rebecca does this:
git pull origin master
git log --graph
```

- merge commits have 2 parents, unlike usual commits.
- if you feel overwhelmed during a merge, do `git merge --abort`
  and start the various merge steps from scratch.
- remember: `git status` gives instructions


---
[previous](notes0927.html) & [next](notes1004.html)
