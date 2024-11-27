#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
dRep dereplicate 03_drep_bins -g 01_input_bins/*fa -comp 70 -con 10 --S_algorithm fastANI --gen_warnings -ms 10000 -pa 0.8 -sa 0.95 -nc 0.30 --genomeInfo genomeInformation.csv -p 16 --run_tertiary_clustering -sizeW 1
