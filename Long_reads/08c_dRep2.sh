# extra weight table like this for example, no quote, no col/row names, tab separated
metabat_2_3_bin.266.fa  100
metabat_2_4_bin.360.fa  100
metabat_4_10_bin.92.fa  100


#!/bin/bash
#SBATCH --mem=120000M
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8   
dRep dereplicate 05_drep_LR_bins_and_SR_bins \
-g 04_input_LR_bins_and_SR_bins/*fa \
-comp 70 -con 10 \
--S_algorithm ANImf \
--gen_warnings -ms 10000 -pa 0.8 -sa 0.95 -nc 0.30 \
--genomeInfo genomeInformation_Step1_bins_and_short_read_bins.csv \
-p 24 \
-comW 1 -conW 5 \
--extra_weight_table Extra_Weight_Table2.txt 
