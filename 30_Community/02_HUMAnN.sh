
conda activate human
## also has 'seqtk'

INDIR=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/04_FastUniq

DATABASES=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/HUMAnN

SAMPLE=1_1

## interleave R1 & R2
seqtk mergepe $INDIR/${SAMPLE}.R1.dedup.fastq.gz $INDIR/${SAMPLE}.R2.dedup.fastq.gz | gzip > "$SAMPLE".interleaved.fastq.gz


mkdir -p out/"$SAMPLE"

## human on interleaved reads
humann --input "$SAMPLE".interleaved.fastq.gz \
      --output out/"$SAMPLE" \
      --threads 16 \
      --nucleotide-database "$DATABASES"/chocophlan \
      --protein-database "$DATABASES"/uniref
