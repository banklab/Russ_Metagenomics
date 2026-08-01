
module load MAFFT


/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Phylogeny/01_Markers_both_data/identify/intermediate_results/single_copy_fasta/bac120

for f in *.fa
do
    base=$(basename "$f" .fa)
    mafft --auto "$f" > "/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Phylogeny/02_Aligned/bac120/${base}.aln.faa"
done





/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Phylogeny/01_Markers_both_data/identify/intermediate_results/single_copy_fasta/ar53

for ff in *.fa
do
    base=$(basename "$ff" .fa)
    mafft --auto "$ff" > "/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Phylogeny/02_Aligned/ar53/${base}.aln.faa"
done



