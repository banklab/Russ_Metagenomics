

samtools fastq \
  -1 1_8_transposase_R1.fq \
  -2 1_8_transposase_R2.fq \
  -0 /dev/null \
  -s /dev/null \
  -n \
  1_8_transposase.sorted.bam
