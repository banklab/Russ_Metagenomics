#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8

REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/09_Salmon/DEER_SR_salmon_index

OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/09_Salmon



INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/06_Salmon/03_Trim


## subset by deer
for Read1 in "$INDIR"/1*_R1.trim.fastq.gz
do

name=$(basename "$Read1")
ID="${name%%_R1*}"
    
salmon quant -i "$REF_DIR" --libType IU -1 "$Read1" -2 "${Read1/_R1./_R2.}" -o "$OUTDIR"/"$ID".quant --meta -p 1

echo "done $ID"

done
