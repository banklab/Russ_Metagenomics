#!/bin/bash
#SBATCH --mem=4000M
#SBATCH --time=6:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8 

module load Bowtie2/2.4.4-GCC-10.3.0

for i in *deer.asm
 do

 ID="${i%_*}"
  
bowtie2-build $i/"$ID"_scaffolds_filtered_NoNorm.fasta $i/"$ID"_scaffolds_filtered_NoNorm

done

  
