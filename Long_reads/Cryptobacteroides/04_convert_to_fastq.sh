
module load SAMtools/1.13-GCC-10.3.0

for f in *transposase.sorted.bam; do
    
    sample=$(basename "$f" _transposase.sorted.bam)

samtools fastq \
  -1 "$f"_transposase_R1.fq \
  -2 "$f"_transposase_R2.fq \
  -0 /dev/null \
  -s /dev/null \
  -n \
  "$f"

done
