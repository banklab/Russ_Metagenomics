
module load SAMtools/1.13-GCC-10.3.0

awk '{print $1 "\t0\t1000000000"}' species_scaffolds_with_transposase.txt > species_scaffolds_with_transposase.bed


samtools view -b \
  -L species_scaffolds_with_transposase.bed \
  /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment/1_10_LR.sorted.bam \
  > 1_10_transposase.bam


samtools sort 1_10_transposase.bam -o 1_10_transposase.sorted.bam
samtools index 1_10_transposase.sorted.bam

#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8
module load SAMtools/1.13-GCC-10.3.0
for f in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment/*sorted.bam; do
    
    sample=$(basename "$f" _LR.sorted.bam)

    samtools view -b \
      -L species_scaffolds_with_transposase.bed \
      "$f" \
      > "$sample"_transposase.bam
    
    samtools sort "$sample"_transposase.bam -o "$sample"_transposase.sorted.bam
    samtools index "$sample"_transposase.sorted.bam

done



