
module load SAMtools/1.13-GCC-10.3.0

samtools view -b 1_10_LR.sorted.bam \
  $(cat species1_contigs.txt species2_contigs.txt species3_contigs.txt) \
  > three_species.bam

