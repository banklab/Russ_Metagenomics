#!/bin/bash
#SBATCH --mem=2000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=8:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out

for i in *sorted.bam
do
file2=$(echo $i | perl -pe 's/.sorted.bam//')
echo $file2
mosdepth -t 4 -b 1 $file2 $i
done
