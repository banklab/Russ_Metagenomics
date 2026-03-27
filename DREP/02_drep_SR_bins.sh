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
dRep dereplicate /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/99_short_read_bins/drep80 -g /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/99_short_read_bins/RAW/*fa -comp 70 -con 10 --S_algorithm ANImf --gen_warnings -ms 10000 -pa 0.65 -sa 0.80 -nc 0.30 --genomeInfo raw_Short_read_bins_CheckM2.csv -p 10
