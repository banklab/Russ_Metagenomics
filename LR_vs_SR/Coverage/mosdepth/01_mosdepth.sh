#!/bin/bash
#SBATCH --mem=8000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


ALIGN_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Combined_Mapping/01_LR


for bam in "$ALIGN_DIR"/*.bam
do

filename=$(basename "$bam")
file2="${filename%%.*}"
echo $file2

mosdepth $file2 $bam

done
