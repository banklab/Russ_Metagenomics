#!/bin/bash
#SBATCH --mem=100000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --time=4:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
checkm2 predict --input /storage/scratch/users/rj23k073/04_Deer/06_Binning/01_MetaBAT2/bins \
 --output_directory /storage/scratch/users/rj23k073/04_Deer/07_CheckM2/metabat \
-x fa \
-t 30
