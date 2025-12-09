conda activate semibin

#!/bin/bash
#SBATCH --mem=50000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=12:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8

ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly
BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/04_LR_MAP


for i in "$ASM_DIR"/*.asm.p_ctg.filtered.fa
do
    ASM1=$(basename "$i") 
    ASM=${ASM1%.asm.p_ctg.filtered.fa} 

    echo "Input Assembly: $ASM"

    SemiBin2 train_self --data out/"$ASM"/data.csv --data-split out/"$ASM"/data_split.csv -o out/"$ASM" -t 8 --epochs 20 --engine cpu

    SemiBin2 bin -i $i --data out/"$ASM"/data.csv --model out/"$ASM"/model.pt -o out/"$ASM" -t 8 --compression none
   
    echo -e "Done\n"

done
