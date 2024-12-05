#!/bin/bash
#SBATCH --mem=100000M
#SBATCH --time=16:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8
dRep dereplicate 03_drep_bins -g 01_input_bins/*fa -comp 70 -con 10 --S_algorithm ANImf --gen_warnings -ms 10000 -pa 0.8 -sa 0.95 -nc 0.30 --genomeInfo genomeInformation.csv -p 10
