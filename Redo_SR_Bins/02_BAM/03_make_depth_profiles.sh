conda activate minimap


#!/bin/bash
#SBATCH --mem=24000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


ASM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly"
READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq"
OUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/02_BAM"


# choose assembly
cd $ASM_DIR

#for ASM in "${ASM_DIR}"/*_deer.asm; do
for ASM in "${ASM_DIR}"/7_*deer.asm; do

BASE=$(basename "$ASM")

# Deer ID
DEER="${BASE%%_*}"
    
# output directory for this deer
ASM_OUT="${OUT_DIR}/${BASE%.asm}"

# make metabat depth matrix for binning after
echo "  Generating depth matrix for $ASM"
jgi_summarize_bam_contig_depths --outputDepth "$ASM_OUT/${BASE%_*}.depth.txt" "$ASM_OUT"/*.bam

done
