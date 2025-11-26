
conda activate human


INDIR=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/04_FastUniq

DATABASES=/storage/scratch/users/rj23k073/human

SAMPLE=1_1


humann --input "$INDIR"/"$SAMPLE".R1.dedup.fastq.gz,"$INDIR"/"$SAMPLE".R2.dedup.fastq.gz \
      --output out/"$SAMPLE" \
      --threads 16 \
      --nucleotide-database /path/to/chocophlan \
      --protein-database /path/to/uniref90
