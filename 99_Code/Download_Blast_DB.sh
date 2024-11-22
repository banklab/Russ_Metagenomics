#!/bin/bash
#SBATCH --mem=4000M
#SBATCH --time=12:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
module load StdEnv/2023
module load gcc/12.3
module load blast+/2.14.1
update_blastdb.pl --passive --decompress nt
