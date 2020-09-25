---
layout: page
title: more shell with 'if', script arguments, arithmetic
description: course notes
---
[previous](notes1004.html) &
[next](notes1011.html)

---

### script arguments

see [shell scripts](http://swcarpentry.github.io/shell-novice/06-script/)
from the software carpentry

command-line arguments stored in variables `$1`, `$2`, etc.  
`$0`: name of script
`$#`: number of arguments

example: script to show both the beginning and
the end of a file.
argument: file name  
create a new file `headtail.sh`, such as with `touch headtail.sh`,
then edit your file (e.g. with VS Code) so that it contains this:

```shell
echo "script name: $0"
echo "first argument: $1"
echo "number of arguments: $#"
(head -n 2; tail -n 2) < "$1"
```

by the way: `<` redirect the standard input, and  
subshell between `(  )`: both head and tail get the same standard input.  
execute the script like this (for now):

```shell
bash headtail.sh Mus_musculus.GRCm38.75_chr1.bed
bash headtail.sh Mus_musculus.GRCm38.75_chr1.bed | column -t
```

- even if you use `zsh` by default, your system has `bash`, most likely,
  and your `zsh` knows where to find `bash`: so the `bash` command above
  should work.
- now might be a good time to comment out the first 3 lines
  (or delete them from your script): these `echo` lines
  were for the sake of learning and demystifying the default variables
  like `$0` and `$1`.

### safe script options, file permissions

I recommend you start your script with this:

```shell
#!/bin/bash
set -e # script terminates if any command exits with non-zero status
set -u # terminates if any variable is unset
set -o pipefail # terminates if command within a pipes exits unsuccessfully
```

`#!` "shebang": tells how to run the script.
Would be `#!/usr/bin/perl` for a perl script.
do `which bash` or `which perl` to know what to put on this line:
path to bash or to perl.

Here you could replace `/bin/bash` by `/bin/zsh` if you want your script
to be run by `zsh` instead of `bash`. I recommend that you avoid commands that
work with one but don't work with the other: it would hamper reproducibility
and could bother collaborators
(or yourself if you decide to switch from one shell to another in a few years).

With the first line and with the execute permission, we can run the script
with `./myscript.sh filename` instead of `bash myscript.sh filename`.  
To change permission:

```shell
ls -l
chmod u+x headtail.sh
ls -l
./headtail.sh Mus_musculus.GRCm38.75_chr1.bed
./headtail.sh Mus_musculus.GRCm38.75_chr1.bed | column -t
```

`u`, `g`, `o`: user, group, other; `a` for all  
`+` or `-` to add or remove permissions  
`r`, `w`, `x`: read, write, execute

**~/bin directory**:

- create one if you don't already have one,
  put your own programs there, to call them from anywhere.
- shell = programming language: it has variables, and the value of a
  variable is accessed with `$` in front of the variable name.
- `PATH` is a variable: try `echo $PATH`. `PATH` lists a bunch of
  directories. When you type of command name, such as `ls` or `echo`,
  the shell looks for an executable file with that name
  in all the directories in `PATH`.
  If executes the first one that it finds.
- Do you see `~/bin` somewhere when you do `echo $PATH`?
- if yes: any executable file inside `~/bin` will be found when
  you type its name, and can be executed from wherever you are.
- if not: add it!
  * with the `bash` shell:
    open your file `~/.bash_profile` to edit it, and add the line
    `export PATH="$PATH:~/bin"`. If you don't even have a file
    `~/.bash_profile`, create it (use `touch`) then edit it to add
    the line.
  * with the `zsh` shell:
    open your file `~/.zshrc` (create it if it doesn't exist)
    and add the `export path+=('~/bin')` .
  * run `source ~/.bash_profile` or `source ~/.zshrc` depending on your shell,
    or simply exit your terminal and re-open it.

With that, I can move my script `headtail.sh` into `~/bin`, and run
it from anywhere I would like, as `headtail.sh filename`:

```shell
mv headtail.sh ~/bin/
headtail.sh Mus_musculus.GRCm38.75_chr1.bed
headtail.sh Mus_musculus.GRCm38.75_chr1.bed | column -t
```

### arithmetic expansion

use `(( ))`. integers only.
It's good to know about arithmetic expansion,
but I don't encourage using it.
If you need anything elaborate, it means that you should use a
Julia, Python, Perl or R script, not a shell script.

Try this on your own, to see the output:

```shell
i=3678 # no spaces!!
echo "my variables is: i=$i"
((i = i+6))
echo "I incremented i by 6: now i=$i"
((i--))
echo "I decremented i by 1: now i=$i"
((i++)); echo "I incremented i by 1: now i=$i"
((i+=1)); echo "I incremented i by 1 again: now i=$i" # 3685
((i/=5)); echo "finally, I divided i by 5: now i=$i"
echo $((i++))  # i++ executes the command "echo" and increments i after
echo $i        # we see 738, not 737 like earlier
echo $((++i))  # ++i increments i first, then executes the command
echo $i        # we see 739, like earlier
```

### `if` statements and checks

examples:

```shell
if [ $i -lt 800 ] # the spaces after `[` and before `]` are REQUIRED
then
  echo "i is less than 800"
else
  echo "i is not less than 800"
fi
```

```shell
if [ $i -lt 800 -a $i -ge 790 ] # -a = "and"
then
  echo "790 <= i < 800"
else
  echo "i<790 or i>=800"
fi
```


headtail script: let's test and check for at least one argument
(file name), and if so, test that this file is readable:

```shell
if [ $# -lt 1 ] || [ ! -f $1 ] || [ ! -r $1 ]
then
  echo "error: no argument, or argument is not a file, or file not readable"
  exit 1 # exit script with error code (1). 0 = successful exit
fi
```

exit code: 0 if successful, 1 if unsuccessful (for the shell, 0=true, 1=false!!)

|------|-------------|
| test expressions &nbsp;&nbsp;|             |
|:-----|:------------|
| `-z str` | string `str` is empty |
|`str1 = str2`| strings `str1` and `str2` are identical. different: `str1 != str2` |
|`int1 -eq int2`| integers `int1` and `int2` are equal. not equal: `int1 -ne int2` |
|`int1 -lt int2`| integer int1 is less than int2. greater: `int1 -gt int2` |
|`int1 -le int2`| integer int1 is less than or equal to int2. greater or equal: `int1 -ge int2`|
|`-d thing` | `thing` is a directory. file: `-f`, link: `-h` |
|`-e thing`| `thing` exists |
|`-r file`| `file` is readable. writable: `-w`, executable: `-x`|
| `!`     | negation |
|`-o`, `-a`, `!`| or, and: to separate expressions within a test `[...]` (*not* short-circuit)|
|`( )`| to group tests |
| `||`, `&&` | or, and: to separate different tests (short circuit) |
|--------|------------|
|        |            |
{: rules="groups"}

<!-- `-x`: accessible, if argument is expression -->

short-circuit evaluation with `||` and `&&`: convenient, and *the order is important!*

- "A or B": B is not evaluated if A is true, because
  the result would be true anyway.  
  We can do "zero arguments or argument 1 is a file" without causing
  an error, but there could be an error if we did
  "argument 1 is a file or zero arguments".
- "A and B": B is not evaluated if A is false: the result would be false anyway.


Let's add a second, optional argument to our `headtail.sh` script:
number of lines to show at each end. default: 2

```shell
nl=2 # number of lines to show, on each end
if [ $# -ge 2 ]
then
  nl=$2
fi
(head -n $nl; tail -n $nl) < "$1"
```

and now use our script with (or without) its new option:

```shell
headtail.sh Mus_musculus.GRCm38.75_chr1.bed 5 | column -t
headtail.sh Mus_musculus.GRCm38.75_chr1.bed   | column -t
```

<!-- add something about bash arrays? -->

## changing your shell prompt

variable PS1 contains your shell prompt (prompt string):

```shell
echo $PS1 # save this output, to go back to original prompt in same session
PS1="hiCecile% "
PS1="hiCecile$ "
PS1="$ "
parse_git_branch() { # defines a shell function: run "git branch" and extract branch name
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
PS1="\$(parse_git_branch)$ "
PS1="\[\033[33m\]\$(parse_git_branch)$ "
PS1="\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$ "
```

last one: shows if in git repository, and if so,
name of current checked out branch  
to affect future sessions: pick the one you like best and add this at
the end of your `~/.bash_profile` file:
`export PS1=preferred_choice_here`

---
[previous](notes1004.html) &
[next](notes1011.html)
