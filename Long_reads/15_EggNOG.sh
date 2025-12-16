#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=72:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


INDIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/10_Prodigal/FAA"
OUTDIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/15_EggNOG"
DATA_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/15_EggNOG/DATA"

cd $INDIR

for f in *.faa; do
    base=$(basename "$f" .fa.genes.faa)
    emapper.py -i "$f" -o $OUTDIR/$base -m diamond --data_dir $DATA_DIR --cpu 8 --override
done

