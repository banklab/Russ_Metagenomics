#!/bin/bash
#SBATCH --mem=24000M
#SBATCH --time=48:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --partition=pibu_el8 

isescan.py \
    --seqfile ../../LONG_READS/08_dRep/97B_LR_only_dereplicated/dereplicated_genomes/*fa \
    --output LR_results \
    --nthread 8
