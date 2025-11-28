
conda activate human
## also has 'seqtk'

#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=30:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out


INDIR=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/04_FastUniq

DATABASES=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/HUMAnN

SAMPLE=1_2

## interleave R1 & R2
seqtk mergepe $INDIR/${SAMPLE}.R1.dedup.fastq.gz $INDIR/${SAMPLE}.R2.dedup.fastq.gz | gzip > "$SAMPLE".interleaved.fastq.gz


mkdir -p out/"$SAMPLE"

## human on interleaved reads
humann --input "$SAMPLE".interleaved.fastq.gz \
      --output out/"$SAMPLE" \
      --threads 16 \
      --nucleotide-database "$DATABASES"/chocophlan \
      --protein-database "$DATABASES"/uniref \
        --bypass-prescreen \
        --bypass-nucleotide-search
