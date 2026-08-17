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

module load minimap2/2.20-GCCcore-10.3.0
module load SAMtools/1.13-GCC-10.3.0

READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/02_Merged"


for i in "$READ_DIR"/*fastq
do

 ID=$(basename "$i" .fastq)

minimap2 -ax map-hifi UHGG_reps.fasta "$i" | samtools flagstat - > "${ID}_UHGG_mapping_stats_LR.txt"
       
done
