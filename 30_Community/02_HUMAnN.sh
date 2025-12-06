
conda activate human
## also has 'seqtk'

#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --time=36:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq

DATABASES=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/human

SAMPLE=1_1

## interleave R1 & R2
#seqtk mergepe $INDIR/${SAMPLE}.R1.dedup.fastq.gz $INDIR/${SAMPLE}.R2.dedup.fastq.gz | gzip > "$SAMPLE".interleaved.fastq.gz


mkdir -p out/"$SAMPLE"

## human on interleaved reads
humann --input "$SAMPLE".interleaved.fastq.gz \
      --output out/"$SAMPLE" \
      --threads 24 \
      --nucleotide-database "$DATABASES"/chocophlan \
      --protein-database "$DATABASES"/uniref \
        --bypass-prescreen \
        --bypass-nucleotide-search \
        --resume
