conda activate maxbin2

#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly
BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/02_BAM

mkdir -p bins

for i in "$ASM_DIR"/*_deer.asm/*_scaffolds_filtered_NoNorm.fasta
do
    ASM1=$(basename "$i") 
    ASM="${ASM1%%_scaffolds*}"  
        
    echo "Input Assembly: $ASM"

    /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/03_Binning/02_MaxBin2/program/MaxBin-2.2.7/run_MaxBin.pl -contig $i \
        -abund "$BAM_DIR"/"$ASM"_deer/"$ASM".depth.txt \
        -out bins/maxbin_"$ASM"_bin \
        -thread 4

    echo -e "Done\n"

done
