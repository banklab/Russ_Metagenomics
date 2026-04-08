#!/bin/bash
#SBATCH --mem=32000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

module load Bowtie2/2.4.4-GCC-10.3.0
module load SAMtools/1.13-GCC-10.3.0

READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq"
OUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/06_Alignment"
REF="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/REFERENCES/DEER_SR"

## parallel deer 
for READ1 in "$READ_DIR"/1*R1.dedup.fastq.gz
do

BASE=$(basename "$READ1")

SAMPLE=$(basename "$READ1" .R1.dedup.fastq.gz)

BAM="$OUT_DIR"/"$SAMPLE".bam
        
bowtie2 -p 10 -x $REF -1 $READ1 -2 "${READ1/.R1./.R2.}" \
        | samtools sort -@6 -o "$BAM"
    samtools index "$BAM"
done

