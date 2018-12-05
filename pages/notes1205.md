---
layout: page
title: Julia for GWAS and mixed models
description: course notes
---
[previous](notes1208.html) &
<!-- [next](notes1215.html) -->

---

- dealing with "big data" in Julia
- exactly what "big data" is evolves over time
- current constraints can be
    - many observations on a relatively simple structure
    - complex models fit to moderately large data sets
    - iterative methods with vague stopping rules
        - MCMC (Markov Chain Monte Carlo)
        - many machine-learning approaches

- [GWAS](https://en.wikipedia.org/wiki/Genome-wide_association_study) (Genome-Wide Association Studies) data
    - two allele types at `n` SNP (single-nucleotide polymorphism) sites
    - `m` individuals
    - [Recent arrays](https://en.wikipedia.org/wiki/SNP_genotyping) allow for $n > 10^6$
    - Some studies also have $m\approx 10^6$ or $> 10^12$ obs.

- 3 possiblities (mm, mM, MM) or missing at each position

- Often stored as a [PLINK binary biallelic genetype table](https://www.cog-genomics.org/plink2/formats#bed)
    - each obs as 2 bits, i.e. 4 obs per byte
    - column-major order - obs. on same SNP are adjacent
    - columns are padded to a full byte
    - two "magic numbers" at the start of the file.
    - even this compacted format can be terabytes in size

- Initial analysis can be summary - mean, variance, minor-allele frequency

- Later may want to construct (empirical) "genetic relationship matrix"

- For small studies can read data as some type of integer and work with those.  Won't work for large studies.

- May be able to stream the data but don't want to do many passes in that case.

- [Memory-mapped files](https://en.wikipedia.org/wiki/Memory-mapped_file) provide an alternative
    - Can also allow for parallel processing
    - Substantial advantage in using a read-only data file


```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/dmbates/BEDFiles.jl", rev="staticslices"))
```
---
[previous](notes1208.html) &
<!-- [next](notes1215.html) -->
