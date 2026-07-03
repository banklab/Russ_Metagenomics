#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8
dRep dereplicate 02_drep95 -g 01_genomes/*fa -comp 70 -con 10 --S_algorithm ANImf --gen_warnings -ms 10000 -pa 0.80 -sa 0.95 -nc 0.30 --genomeInfo all_good_copy_genomes_CheckM.csv -p 10
