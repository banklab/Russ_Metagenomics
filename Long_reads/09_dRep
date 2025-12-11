#!/bin/bash
#SBATCH --mem=200000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8   
dRep dereplicate 03_drep_long_read_bins_and_hybrid_bins \
-g 01_raw_long_read_bins_and_hybrid_bins/*fa \
-comp 70 -con 10 \
--S_algorithm ANImf \
--gen_warnings -ms 10000 -pa 0.8 -sa 0.95 -nc 0.30 \
--genomeInfo genomeInformation_long_read_bins_and_hybrid_bins.csv \
-p 24
