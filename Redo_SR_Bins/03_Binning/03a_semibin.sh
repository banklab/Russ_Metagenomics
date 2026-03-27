conda activate semibin

#!/bin/bash
#SBATCH --mem=24000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=16:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly
BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/02_BAM

## parallelize by deer here
for i in "$ASM_DIR"/7*_deer.asm/*_scaffolds_filtered_NoNorm.fasta
do
    ASM1=$(basename "$i") 
    ASM="${ASM1%%_scaffolds*}"  
    
    echo "Input Assembly: $ASM"

    SemiBin2 generate_sequence_features_single -i $i -b $BAM_DIR/"${ASM}"_deer/*.bam -o out/"$ASM" -t 1

   
    echo -e "Done\n"

done
