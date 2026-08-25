#!/bin/bash
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8 


module load DIAMOND/2.1.8-GCC-10.3.0


for i in *genes.faa
do

base=$(basename "$i" .fa.genes.faa)


diamond makedb \
    --in $i \
    --db $base

done

