#!/bin/bash
#SBATCH --mem=40G
#SBATCH --time=XX:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8 

module load Bowtie2/2.4.4-GCC-10.3.0
module load SAMtools/1.13-GCC-10.3.0

INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq
#OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Mapping_Databases/UHGG

for i in "$INDIR"/*R1.dedup.fastq.gz
do

 ID=$(basename "$i" .R1.dedup.fastq.gz)

bowtie2 -x UHGG_reps.fasta.bt -1 "$i" -2 "${i/.R1./.R2.}" | samtools flagstat - > "${ID}_UHGG_mapping_stats_SR.txt"


done
