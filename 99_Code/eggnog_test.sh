#!/bin/bash
#SBATCH --mem=100000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
emapper.py -m diamond -i 2_8_bin.6.fa.genes.faa -o test --data_dir ./data/ --cpu 16
