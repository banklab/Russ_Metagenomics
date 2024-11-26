#!/bin/bash
#SBATCH --mem=100M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:20:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load Python/3.10.8-GCCcore-12.2.0

DATASET=deer

for i in $(cat redux_sample_list.txt)
do

python dereplicate_contigs_in_bins.py 04_Top_Bins/STATS/"$i".stats 04_Top_Bins/"$i"_"$DATASET" 05_FINAL_BINS/"$i"_"$DATASET"
echo $i
echo "before:"
wc -l 04_Top_Bins/"$i"_"$DATASET"/* | grep 'total'
echo "after:"
wc -l 05_FINAL_BINS/"$i"_"$DATASET"/* | grep 'total'

done
