conda activate metabat2

#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=4:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out


ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly
BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/02_BAM


for i in "$ASM_DIR"/*_deer.asm/*_scaffolds_filtered_NoNorm.fasta
do
    ASM1=$(basename "$i") 
    ASM="${ASM1%%_scaffolds*}"  
    
    echo "Input Assembly: $ASM"

    metabat2 -i $i \
         -a "$BAM_DIR"/"$ASM"_deer/"$ASM".depth.txt \
         -o bins/metabat_"$ASM"_bin \
         -t 4

    echo -e "Done\n"

done
