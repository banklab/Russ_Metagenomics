#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out

module load Python/3.10.4-GCCcore-11.3.0
module load prodigal/2.6.3-GCCcore-10.3.0
module load HMMER/3.3.2-gompi-2021a
export GTDBTK_DATA_PATH=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/GTDB/release220/

gtdbtk align --identify_dir . --out_dir . --cpus 1
