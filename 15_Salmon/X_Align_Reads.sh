#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --time=03:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
module load vital-it/7
module load UHTS/Analysis/salmon/0.11.2
salmon quant -i /storage/scratch/users/rj23k073/04_DEER/REFERENCES/DEER_bin_ref_ruminants_index --libType IU -1 /storage/scratch/users/rj23k073/04_DEER/03_Trim/1_10_R1.trim.fastq.gz -2 /storage/scratch/users/rj23k073/04_DEER/03_Trim/1_10_R2.trim.fastq.gz -o /storage/scratch/users/rj23k073/04_DEER/15_Salmon/deer_1_10.quant --meta -p 1
