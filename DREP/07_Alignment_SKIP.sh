## skip some environments

#!/bin/bash
#SBATCH --mem=40000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=120:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8 

module load Bowtie2/2.4.4-GCC-10.3.0
module load SAMtools/1.13-GCC-10.3.0


REF=DEER_v2.fa

REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE
READS_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq
OUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment


#drep_val="${REF##*_}"  


for read in "$READS_DIR"/*R1.dedup.fastq.gz
do

ID1=$(basename "$read")
ID="${ID1%%.*}"

## skip hindgut
 if [[ "$ID" =~ _(8|9|10)$ ]]; then
        continue
 fi

    
BAM="$OUT_DIR/${ID}_LR.sorted.bam"

echo "Mapping $ID to $REF"

bowtie2 -p 12 -x "$REF_DIR"/"$REF" -1 "$read" -2 "${read/.R1./.R2.}" \
        | samtools sort -@4 -o "$BAM"
    samtools index "$BAM"

done
