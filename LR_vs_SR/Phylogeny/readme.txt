
Goal: phylogeny for all LR28 & SR28 final genomes

starting from GTDBtk align (on all LR28 SR28 good copy genomes at once, n=876)
marker gene alignments

zgrep "^>" gtdbtk.bac120.user_msa.fasta.gz | wc -l
862

zgrep "^>" gtdbtk.ar53.user_msa.fasta.gz | wc -l
14

Only my genomes - ie, not rooting them to tree of life



Also remind myself
Phylogeny analyses - sensitive to contamination
Redo 2nd tree with even stricter contam threshold? -- see if they are concordant?
