#!/bin/bash
#SBATCH --mem=10000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out

humann_databases --download chocophlan full /rs_scratch/users/rj23k073/human

echo "done1"
humann_databases --download uniref uniref90_diamond /rs_scratch/users/rj23k073/human
echo "done2"
