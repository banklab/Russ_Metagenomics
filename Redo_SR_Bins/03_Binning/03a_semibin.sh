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

ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly
BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/04_LR_MAP

## parallelize by deer here
for i in "$ASM_DIR"/2*.asm.p_ctg.filtered.fa
do
    ASM1=$(basename "$i") 
    ASM=${ASM1%.asm.p_ctg.filtered.fa} 

    echo "Input Assembly: $ASM"

    SemiBin2 generate_sequence_features_single -i $i -b $BAM_DIR/${ASM}/*.bam -o out/"$ASM" -t 1

   
    echo -e "Done\n"

done
