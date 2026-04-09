
## InStrain for the 95 drep



#!/bin/bash
#SBATCH --mem=90000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=60:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8 
module load Python/3.9.5-GCCcore-10.3.0
module load SAMtools

drep=95


BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment
OUTPUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/04_InStrain/DEER_drep"$drep"

mkdir -p $OUTPUT_DIR

REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE
REF=DEER_v2.fa
STB=DEER_v2.stb
Prodigal=DEER_v2.genes.fna

## SUBSET DEER ##
for bam in "$BAM_DIR"/1_*_LR.sorted.bam
do

ID1=$(basename "$bam")
ID="${ID1%_*}"


## skip the snps that are already done
if [[ "$ID" =~ ^[0-9]+_(8|10)$ ]]; then
    continue
fi



SNP_OUT="$OUTPUT_DIR"/"$ID"_drep"$drep"

echo "Mapping $ID to $REF"

inStrain profile $bam "$REF_DIR"/"$REF" -o $SNP_OUT -s "$REF_DIR"/"$STB" -g "$REF_DIR"/"$Prodigal" -p 4 --database_mode

done
