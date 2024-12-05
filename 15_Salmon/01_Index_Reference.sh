#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --time=02:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
salmon index -p 4 -t DEER.fa -i DEER_salmon_index
