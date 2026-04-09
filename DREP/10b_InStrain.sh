## InStrain on merged BAM's


#!/bin/bash
#SBATCH --mem=100000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=72:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8 
module load Python/3.9.5-GCCcore-10.3.0
module load SAMtools

drep=80


BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/02_Alignment
OUTPUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/04_InStrain/DEER_drep"$drep"

mkdir -p $OUTPUT_DIR

REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/01_References
REF=DEER_drep"$drep".fa
STB=DEER_drep"$drep".stb  
Prodigal=DEER_drep"$drep".genes.fna


for bam in "$BAM_DIR"/deer*drep"$drep".bam
do

ID1=$(basename "$bam")
ID="${ID1%_*}"

SNP_OUT="$OUTPUT_DIR"/"$ID"_drep"$drep"

echo "Mapping $ID to $REF"

inStrain profile $bam "$REF_DIR"/"$REF" -o $SNP_OUT -s "$REF_DIR"/"$STB" -g "$REF_DIR"/"$Prodigal" -p 4 --database_mode

done
