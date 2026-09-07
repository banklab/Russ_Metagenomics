#!/bin/bash
#SBATCH --mem=32000M
#SBATCH --time=6:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8 

for f in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/07_Prodigal/FAA/*faa
do
    name=$(basename "$f" .faa)

    echo "Converting: $name"

    ezaai convert \
        -i "$f" \
        -s prot \
        -o "ezaai_db/$name"
done
