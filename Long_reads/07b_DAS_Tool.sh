#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=8:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

for asm in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly/*.asm.p_ctg.filtered.fa
do

SAMPLE=$(basename "$asm" .asm.p_ctg.filtered.fa)

DAS_Tool -c $asm \
        -i /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/07_DAS_Tool/Contigs_to_Bins/"$SAMPLE"_MetaBAT2.tsv,/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/07_DAS_Tool/Contigs_to_Bins/"$SAMPLE"_MaxBin2.tsv,/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/07_DAS_Tool/Contigs_to_Bins/"$SAMPLE"_SemiBin2.tsv  \
        -l MetaBAT2,MaxBin2,SemiBin2 \
         -o $SAMPLE \
         --search_engine diamond \
         --write_bins \
         -t 8
done
