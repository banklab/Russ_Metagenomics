#!/bin/bash
#SBATCH --mem=100000M
#SBATCH --time=6:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8   
dRep dereplicate 05_80_drep_LR_bins_and_SR_bins \
-g 04_80_input_LR_bins_and_SR_bins/*fa \
-comp 70 -con 10 \
--S_algorithm ANImf \
--gen_warnings -ms 10000 -pa 0.65 -sa 0.80 -nc 0.30 \
--genomeInfo genomeInformation_Step2_drep80.csv \
-p 12 \
-comW 1 -conW 5 \
--extra_weight_table Extra_Weight_Table_drep80.txt 
