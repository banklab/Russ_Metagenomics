#!/bin/bash
#SBATCH --mem=8000M
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


for f in 01_LR28_genomes/*.fa
do
    base=$(basename "$f" .fa)
    barrnap --kingdom bac "$f" > "02_Barrnap/LR28_${base}.gff"
done

for f in 01_SR28_genomes/*.fa
do
    base=$(basename "$f" .fa)
    barrnap --kingdom bac "$f" > "02_Barrnap/SR28_${base}.gff"
done
