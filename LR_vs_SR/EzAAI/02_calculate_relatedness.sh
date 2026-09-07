#!/bin/bash
#SBATCH --mem=64000M
#SBATCH --time=90:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --partition=pibu_el8 


ezaai calculate \
    -i ezaai_db \
    -j ezaai_db \
    -o ezaai_results/AAI.tsv \
    -self 1 \
    -t 32 \
    -id 0.4 \
    -cov 0.5 \
    -mtx ezaai_results/AAI.mtx
