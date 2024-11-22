#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/blast/ncbi-blast-2.15.0+/bin/blastn -query 2_8_bin.6.fa -db /storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/blast/Database/nt -out 2_8_bin.6.out -evalue 0.001 -outfmt 6 -num_threads 20
