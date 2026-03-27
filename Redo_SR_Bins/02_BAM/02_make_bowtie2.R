#!/bin/bash
#SBATCH --mem=24000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

module load Bowtie2/2.4.4-GCC-10.3.0
module load SAMtools/1.13-GCC-10.3.0

ASM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly"
READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq"
OUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/02_BAM"

# choose assembly
#ASM=2_1

cd $ASM_DIR

#for ASM in "${ASM_DIR}"/*_deer.asm; do
for ASM in "${ASM_DIR}"/2_10_deer.asm; do

BASE=$(basename "$ASM")

# Deer ID
DEER="${BASE%%_*}"
    
#echo "Processing assembly $BASE for deer $DEER"

# output directory for this deer
ASM_OUT="${OUT_DIR}/${BASE%.asm}"
mkdir -p "$ASM_OUT"

# get all SR samples for this deer
SR_READS=(${READ_DIR}/${DEER}_*.R1.dedup.fastq.gz)

    if [ ${#SR_READS[@]} -eq 0 ]; then
        echo "No SR reads found for deer $DEER, skipping $BASE"
        continue
    fi



# loop over all locations and map to deer
for SR in "${SR_READS[@]}"; do
    SAMPLE=$(basename "$SR" .R1.dedup.fastq.gz)
    BAM="$ASM_OUT/${SAMPLE}.bam"

    echo "  Mapping $SR to $ASM -> $BAM"

        
bowtie2 -p 16 -x "$ASM"/"${BASE%_*}_scaffolds_filtered_NoNorm" -1 $SR -2 "${SR/.R1./.R2.}" \
        | samtools sort -@8 -o "$BAM"
    samtools index "$BAM"
done


done
