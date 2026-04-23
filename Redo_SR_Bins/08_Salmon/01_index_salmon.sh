#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --time=6:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8


salmon index -p 4 -t /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/REFERENCES/DEER_SR.fa -i DEER_SR_salmon_index
