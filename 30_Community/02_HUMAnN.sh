
conda activate human

humann --input sample_R1.fastq.gz,sample_R2.fastq.gz \
      --output humann_out/sample \
      --threads 16 \
      --nucleotide-database /path/to/chocophlan \
      --protein-database /path/to/uniref90
