#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --time=02:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
module load vital-it/7
module load UHTS/Analysis/salmon/0.11.2
salmon index -p 4 -t DEER_bin_ref_ruminants.fasta -i DEER_bin_ref_ruminants_index
