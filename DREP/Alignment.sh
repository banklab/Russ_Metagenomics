#!/bin/bash
#SBATCH --mem==40000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=96:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8 

module load Bowtie2/2.4.4-GCC-10.3.0

REF=DEER_drep80.fa

REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/01_References
READS_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq
OUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/02_Alignment


tmp="${REF%.fa}"
drep_val="${tmp##*_}"  


for read in "$READS_DIR"/*R1.dedup.fastq.gz
do

ID1=$(basename "$read")
ID="${ID1%%.*}"

BAM="$ID"_"$drep_val".bam

echo "Mapping $ID to $REF"

bowtie2 -p 12 -x "$REF_DIR"/"$REF" -1 $read -2 "${read/.R1./.R2.}" \
        | samtools sort -@8 -o "$BAM"
    samtools index "$BAM"

done
