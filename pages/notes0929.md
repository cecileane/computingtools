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

### recap from last time: track course notes

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

### pushing to / pulling from github to work with others

various repositories:
cecile (laptop) -- central (claudia's github) -- claudia (laptop)  
we can: `git push`, `git clone`, `git pull`, `git fetch` (to check before), `git merge`

To illustrate this, I will to create a central repository:
new repository owned by "UWMadison-computingtools-2018", say. I'll go to
[github](https://github.com/UWMadison-computingtools-2018), click "New repository",
name it "zmays-snps", give you all permission by adding the 'student' team.
Then back to my shell to link my local repository
to the new central repo on github:

```shell
git remote -v
git remote add origin git@github.com:UWMadison-computingtools-2018/zmays-snps.git
git remote -v
git branch
git push origin master
```

Now let's go back to [github](https://github.com/UWMadison-computingtools-2018/zmays-snps)
to check! Go check the "network" page to visualize the list of commits
(in Graphs tab)

your turn: push your course notes to github with these steps
- go to your github account (click the octocat from any github page)
- click 'New Repository', give it a name easy to type,
  do **not** initialize it with a README file because you already have your local repo
- add the remote url on github: adapt below to the url of your own new repo

```shell
git remote -v
git remote add origin git@github.com:your_user_name/your_repo_name.git
git remote -v # check the nickname for your central (github) repo. default: origin
git branch # to double-check which branch you are on. default: master
git push origin master # pushes current local branch to repo "origin", its branch "master"
```

back to our shared "zmays-snps" repository: clone it.
first navigate to a directory that is
*not* already a git repository (do `git status` to check). Then:

```shell
# you do this, after checking that you are outside of a git repo:
git clone git@github.com:UWMadison-computingtools-2018/zmays-snps.git
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

check the update on
[github](https://github.com/UWMadison-computingtools-2018/zmays-snps);
and pull these changes from the shell:

```shell
$ git pull origin master # you doing this
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (3/3), done.
￼...
From github.com:UWMadison-computingtools-2018/zmays-snps
...
Fast-forward
 readme.md | 1 +
 1 file changed, 1 insertion(+)
-> FETCH_HEAD
-> origin/master
$ git log --pretty=oneline --abbrev-commit
```

Next, volunteer 1 can work on the project, say add more metadata still:

```shell
# volunteer 1 doing this. -e to interpret \n as newline
echo -e "\n\nMaize reference genome version: refgen3" >> readme.md
git commit -a -m "added reference genome info"
git push origin master
```

everyone else: get this new work on our laptops (also check on github):

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
Let me and volunteer 2 make changes to the same file, at roughly the same place:

```shell
# volunteer 2 does this:
echo -e ", downloaded 2018-09-26 from\nhttp://maizegdb.org into `/share/data/refgen3/`." >> readme.md
git commit -a -m "added download info"
git push origin master
```

while I open `readme.md` to change the last line to this:

> We downloaded refgen3 on 2018-09-26.

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

  > We downloaded the B73 reference genome (refgen3) on 2018-09-26 from
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


---
[previous](notes0927.html) &
[next](notes1004.html)
