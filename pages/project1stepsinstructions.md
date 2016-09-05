---
layout: page
title: scripting project - detailed instructions
description: project details
---

See [here](project1description.html) for general instructions and
for a summary of the overall pipeline. Jump to:

1. get the [SNP data](#single-nucleotide-polymorphism-snp-data)
2. get the [reference genome](#reference-genome)
3. build [individual genomes](#build-individual-genomes)
4. build non-overlapping [blocks](#non-overlapping-alignments-blocks)
5. get a [tree](#run-raxml-on-each-block) for each block
6. calculate [distances](#calculate-distances-between-all-pairs-of-trees)
  between trees
7. [test](#test-for-tree-similarity) tree similarity

---

## 1. single nucleotide polymorphism (SNP) data

The data can be accessed online, starting from
[here](http://signal.salk.edu/atg1001/download.php).

- read the [README](http://signal.salk.edu/atg1001/data/README.txt) file in the section "Data Downloading Readme".
  It explains that each strain name links to 3 files.
  We will focus on the file named `quality_variant_<strain_name>.txt`,
  only.
- in the "Genomes Finished" section, click on any one strain, say the first one,
  "Aa_0". The link should take you to a page that lists 3 links, one of them
  (the second) to the file of interest, named `quality_variant_Aa_0.txt`.

Download all of these "quality_variant" files, for all strains listed.
To do this reproducibly, write a script that you will document in your project.
Document and report in your result summary the number of downloaded files,
and the range of their size.
Do *not* track these data files with git!
They should be re-downloadable easily using your script.

Note: you may notice that all (most?) files of interest have a
url's that start with <http://signal.salk.edu/atg1001/data/Salk/>.
You may want to double-check that the list of strains on this page
is the same as the list on the previous page. The goal is to get the
most comprehensive data set of "quality_variant" files.
Check any assumptions that you make regarding web pages,
if data are reachable by several means.
Document and report in your result summary any unexpected links or problems.

## 2. reference genome

Download the *Arabidopsis thaliana* reference genome
from the Arabidopsis Information Resource
[TAIR](ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/),
version 10. You should find 7 chromosomes: chromosomes 1 though 5,
the mitochondrial DNA ("chrM") and the chloroplast DNA ("chrC").

Document (and report in your results) the size of each chromosome
in terms of file size.
In what follows (steps 4-7), restrict your analysis to the
**3 smallest chromosomes only**, excluding chromosome 4
(which was already used in Stenz et al. 2015).

## 3. build individual genomes

Write a script that returns an alignment of the DNA sequences of all
strains for a chromosome of interest and for a genomic range of interest.
It should take 3 arguments:

- chromosome (in 1-5, C or M)
- starting base position (e.g. 1,2,...,20000,...), with indexing starting at 1
  because "position" indices start at 1 in the SNP data files
- alignment length (e.g. 1000), in base pairs

The output alignment file should be in phylip format, for which
the conventional extension is `.phy`. As an example,
the phylip file named `chr1_997to1006.phy` would contain this:

    2 10
    Aa_0 ATTTGGTTAT
    Abd_0 AATTGGTTAT

This file name
indicates that the alignment is for chromosome 1, region starting
at position 997 and ending at position 1006 (length: 10 base pairs).
The phylip format requires a header (first row) that gives the number of
sequences (here 2) and the length of each sequence (here 10).
Then each line should start with the strain name (some sequence name in general),
then one or more spaces, then the DNA sequence itself. The strain name should
only contain normal word characters: letters, digits, and underscores.

It is possible that some bases will be gaps when absent, coded with a dash `-`.

Note that the SNP files have information about the reference base at each
site where a difference was found. Use this information to check your code.
Document any discrepancy found between the reference genome and the reference
nucleotides in the SNP files (if no discrepancy, hopefully, say so).

Annotate and document your script to make it easy to re-use later,
by yourself or someone else.
In your result summary, show how to use the script on a simple example
that should run fast, such as to produce the file `chr1_997to1006.phy` above.

## 4. non-overlapping alignments blocks

Write a script to cut a chromosome into non-overlapping alignments
---or blocks--- of length 10,000 base pairs (except for the last one).
This new script should use your script in step 3.
For example, a chromosome that has a total of 18,585,056 base pairs (bp)
would be cut into 1,858 blocks of 10,000 bp each,
plus 1 final block of only 5,056 bp.

You can make these blocks and store them, but that would take a lot of
memory on your machines. Instead, you can make them on the fly as needed
in step 5 below, if you combine this block-making step with
step 5 below in a pipeline or within the same script.

To produce these alignment blocks and to share the actual computing work
among group members, write a bash script that produces a subset of these blocks,
possibly in temporary files to be used in step 5 below.
Your script should take 3 arguments:

- chromosome (1-5, C or M)
- starting block index (e.g. 0,1,...,1858 for the example above)
- number of blocks to produce (e.g. 1,2,...)

The script should be able to produce the first 100 blocks of chromosome 1,
for example, if given 0 as starting block index and 100 as the number of blocks.

**Do not** track these alignment blocks with git, because they can
be reproduced using your scripts, and because they are very large collectively.

Start small to test your script: say with just 5 strains and 3 alignment blocks,
each with only 500 base pairs, resulting in only 3 files, each with
only 5 sequences of 500 nucleotides. You may choose to track the final
version of these files (after using them to develop and test your code),
as examples to show yourself or others how your pipeline works.
To do this small test, you may wish to add a 4<sup>th</sup> argument
to your script: the length of each block.

## 5. run RAxML on each block

<!--
PAUP* available [here](http://people.sc.fsu.edu/~dswofford/paup_test/),
command-line version: executable for now.
[FastTree]()
-->

The goal of this step is to analyze each block and estimate a tree that
describes the genealogy of the plants, based on their DNA.
You do not need to know the statistical basis for this estimation step,
which can be done with the program [RAxML](http://sco.h-its.org/exelixis/web/software/raxml/index.html).

### install RAxML

Download and install RAxML from [github](https://github.com/stamatak/standard-RAxML)
by cloning its git repository, again outside of any existing git repository:
`git clone git@github.com:stamatak/standard-RAxML.git`.
To install it, follow the instructions on
[github](https://github.com/stamatak/standard-RAxML/blob/master/README)
or on the
[manual](http://sco.h-its.org/exelixis/resource/download/NewManual.pdf).
You need to make choices based on your hardware. On a recent laptop,
I recommend the AVX and Pthreads version, using this:

```shell
make -f Makefile.AVX.PTHREADS.gcc
rm *.o
```
It will produce an executable program called `raxmlHPC-PTHREADS-AVX`,
which you would move to your `~/bin/` directory
(supposedly in your `$PATH` variable). You can then run RAxML
by running the command `raxmlHPC-PTHREADS-AVX` from anywhere.

### how to run RAxML

As an example, let's say that one of your alignment block is like below,
in a file named `fake.phy` in directory `project/alignement/`:

    4 10
    Aa_0  ATTTGGTTAC
    Abd_0 AATTGATTCT
    Ag_0  AATTGATTAT
    Ak_1  ATTTGGTTAT

Run this command from directory `project/raxml/`, say:

```shell
raxmlHPC-PTHREADS-AVX -s ../alignments/fake.phy -n fake -m GTRCAT --HKY85 -F -T 2 -p 12345
```

RAxML will create output files named `RAxML_*.fake` in the current directory.
The main output file containing the tree will be in `RAxML_result.fake`,
and in this example the tree looks like this,
showing that Ag_0 and Abd_0 as sister:

    ((Ag_0,Abd_0),Ak_1,Aa_0);

#### options to adapt:

- the `-s` option is for the sequence file: adapt it to your input file name.
- adapt the `-n` option value to change the name of output files.
- `-T 2` is to use 2 threads: adapt this to your machine.
Do *not* tell RAxML to use more threads than your machine has!

background info on options to keep as is:

- `-m GTRCAT --HKY85` describes the statistical model for sequence evolution:
here both tractable computationally and flexible
(e.g. allowing for fast-evolving and slow-evolving sites).
- option `-F` is to get the best topology only, not its branch lengths
or its likelihood (for which an extra final optimization would be needed).
- the `-p` option is to set the seed: you can change it but do not have to.

### script

Write a script to run RAxML and retain the main output file
for each block from a given chromosome, starting at some block and
for some number of blocks. Like in step 4, your script should take
3 arguments:

- chromosome (1-5, C or M)
- starting block index (e.g. 0,1,...,1858 for the example above)
- number of blocks to produce (e.g. 1,2,...)

You can modify and expand your script from step 4
to make it do both steps: build an alignment, and run RAxML on it
(then delete the alignment to save memory).
Like always, annotate and document your script to make it easy to re-use later.
Show how to use it in your result summary.

Again, start small to test your script: say with the same 5 strains and
3 short (500 bp) alignment blocks that you used to test your script in step 4.

When your script is ready, use it to analyze all blocks
(for the 3 smallest chromosomes only, excluding chromosome 4).
Divide these computations across all team members.
Save the resulting tree files (each one should be small) in some way
and track them with git after you are sure to have their final version.
They can be reproduced with your scripts, yes, but not easily and not fast.
Since they are rather small, it's worth tracking them.

### documentation

As always, comment your code and document its usage outside the code.
But since this step make take a while to run,
you should also document the time it takes. You must be able to predict
the full running time shortly after you start the computations.
For this: document when you started a series or runs,
what you started, on which machines, and when the runs finished.
Write this information in some readme file, update it as runs finish,
and push to / pull from github to share the computations progress
with your team members.
If you use a separate or dedicated readme file for this information,
include a summary of it in your report summary.

## 6. calculate distances between all pairs of trees

Calculate the [Robinson-Foulds](https://en.wikipedia.org/wiki/Robinson–Foulds_metric)
(RF) distance between pairs of (unrooted) trees.
You do not need to know how this distance is defined. In case you
wonder, it satisfies the triangle inequality and
d(T<sub>1</sub>,T<sub>2</sub>)=0 only when T<sub>1</sub> and T<sub>2</sub>
have the same unrooted topology.
Calculate the RF distance

<ol>
<li type="a"> between all pairs of trees from the same chromosome,
  for each chromosome</li>
<li type="a"> between all pairs of trees from consecutive blocks
  (which could be extracted from the larger set of distance values above)</li>
</ol>

This could be done in several ways. The simplest is to use RAxML.
If file `chr4.tre` is in the current directory and contains this list
of 3 trees, for example:

    ((Ag_0,Abd_0),Ak_1,Aa_0);
    (Ag_0,(Ak_1,Aa_0),Abd_0);
    (Ag_0,Ak_1,(Aa_0,Abd_0));

all pairs of trees in this file would be compared using this RAxML command:

```shell
raxmlHPC-PTHREADS-AVX -f r -z chr4.tre -n chr4dist -m GTRCAT --HKY85 -T 2
```

with the main output in a file named `RAxML_RF-Distances.chr4dist`:

    0 1: 0 0.000000
    0 2: 2 1.000000
    1 2: 2 1.000000

In this output, the first 2 columns give the index (starting at 0)
of each tree in the pair being compared, a colon, the RF distance
(here tree 0 and tree 1 are at distance 0: they are equal),
and the normalized RF distance (which you can ignore).

options in the command above:

- adapt the name of the input tree file for the `-z` option
- adapt the `-n` option value to change the name of output files
- adapt `-T 2` to a number of threads appropriate for your machine
- `-f r` tells RAxML to calculate RF distances: keep it and all other options.

Again, document this step in your report summary, with the commands
or script that you used, output file names etc.

<!--
Alternatively, the dendropy Python library could be used.
Install it from the bioconda channel:
`conda install -c bioconda dendropy=4.0.3`.
Below is an example based on the
[dendropy primer](http://dendropy.org/primer/treestats.html#comparing-and-summarizing-trees),
in which trees are considered unrooted, which is what we want for this project.

```python
import dendropy
from dendropy.calculate import treecompare
s1 = "(a,(b,(c,d)));" # string (newick) representation of tree
s2 = "(a,(d,(b,c)));"
tns = dendropy.TaxonNamespace() # common taxon namespace: to be used by all trees
tree1 = dendropy.Tree.get(data=s1,schema='newick',taxon_namespace=tns)
tree2 = dendropy.Tree.get(data=s2,schema='newick',taxon_namespace=tns)
tree1.print_plot() # this is just to see the tree, not to get distances
tree2.print_plot()
## Unweighted Robinson-Foulds distance:
print(treecompare.symmetric_difference(tree1, tree2))
```
-->

## 7. Test for tree similarity

<ol>
<li type="a">
  Are the observed tree distances closer to 0 than expected if
  the 2 trees were chosen at random uniformly?
  We would think so, if each plant was from a distinct population
  and if populations did not mix.
</li>
<li type="a">
  Do trees from 2 consecutive blocks tend to be more similar to each
  other (at smaller distance) than trees from 2 randomly chosen blocks
  from the same chromosome?
  We would expect so if blocks were small, due to less "recombination"
  between neighboring blocks.
</li>
</ol>

Answer these 2 questions for each chromosome separately.

For (a), use the fact that the RF distance between
2 uniform random trees is *D*=2\*(*n*-3-*S*) where

- *n* is the number of plants, or number of tips in general,
- *S* has a distribution that is approximately
[Poisson](https://en.wikipedia.org/wiki/Poisson_distribution)
with mean 1/8,
from [Steel (1988)](http://epubs.siam.org/doi/abs/10.1137/0401050) and
[Steel & Penny (1993)](https://sysbio.oxfordjournals.org/content/42/2/126.abstract)
(*S* is the number of shared bipartitions).

Plot the distribution of *D* for 2 random trees, and overlay the
distribution of distances obtained in step 6(a). You may choose to
visualize extra information on this plot, such as the mean of
each distribution, or any other summary that you might find useful to answer (a).
Using this display, compare these 2 distributions and conclude to answer (a).

For (b), use a similar plot to overlay 2 distributions: the distribution
of distances between consecutive trees as obtained in step 6(b),
and the distribution of distances between trees chosen randomly from
the blocks of the same chromosome, from step 6(a).
Again, use this display to answer (b).

<!--
Steel, M. A. 1988. Distribution of the symmetric difference metric on phylo- genetic trees. SIAM J. Discrete Math. 1:541–551.
Steel, M. A., and D. Penny. 1993. Distributions of tree comparison metrics— some new results. Syst. Biol. 42:126–141.
-->

Notes:

- no statistical test is required (e.g. no p-value), as this
  would add complexity beyond the learning goals of the course.
- R or Python may be used to produce the 6 plots needed to answer (a)
 and (b). I recommend R for the quality of its graphics.
 Below are examples to calculate the probability
 that *S*=1 if *S* is Poisson with mean 1/8, in R:

```R
dpois(x=1,lambda=1/8) # 0.1103121
```

or in python:

```python
import scipy.stats
scipy.stats.poisson.pmf(k=1, mu=1/8) # 0.1103121
```
