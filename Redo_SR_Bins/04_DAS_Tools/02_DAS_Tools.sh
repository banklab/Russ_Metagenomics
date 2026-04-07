conda activate das_tools

#!/bin/bash
#SBATCH --mem=10000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


## loop over only the (LR) assemblies 
for asm in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/04_DAS_Tool/Contigs_to_Bins/*_MetaBAT2.tsv
do

SAMPLE=$(basename "$asm" _MetaBAT2.tsv)

SR_ASM="$SAMPLE"_deer.asm/"$SAMPLE"_scaffolds_filtered_NoNorm.fasta

DAS_Tool -c /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly/"$SR_ASM" \
        -i /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/04_DAS_Tool/Contigs_to_Bins/"$SAMPLE"_MetaBAT2.tsv,/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/04_DAS_Tool/Contigs_to_Bins/"$SAMPLE"_MaxBin2.tsv,/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/04_DAS_Tool/Contigs_to_Bins/"$SAMPLE"_SemiBin2.tsv  \
        -l MetaBAT2,MaxBin2,SemiBin2 \
         -o $SAMPLE \
         --search_engine diamond \
         --write_bins \
         -t 8
done
