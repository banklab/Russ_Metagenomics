#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --time=120:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8

REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/06_Salmon/DEER_drep80_salmon_index

OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/06_Salmon/DEER_drep80_salmon_out

mkdir -p $OUTDIR


INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/06_Salmon/03_Trim


for Read1 in "$INDIR"/*_R1.trim.fastq.gz
do

name=$(basename "$Read1")
ID="${name%%_R1*}"
    
salmon quant -i "$REF_DIR" --libType IU -1 "$Read1" -2 "${Read1/_R1./_R2.}" -o "$OUTDIR"/"$ID".quant --meta -p 1

echo "done $ID"

done
