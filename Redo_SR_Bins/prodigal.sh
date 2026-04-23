#!/bin/bash
#SBATCH --mem=4000M
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8 

module load prodigal/2.6.3-GCCcore-10.3.0

INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/05_drep/03_drep/dereplicated_genomes
OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/07_Prodigal


cd $INDIR

for i in *fa
do
 prodigal -i $i -o "$OUTDIR"/Genes/"$i".genes -a "$OUTDIR"/FAA/"$i".genes.faa -d "$OUTDIR"/FNA/"$i".genes.fna -m -p single
done
