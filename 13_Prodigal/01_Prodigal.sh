#!/bin/bash
#SBATCH --mem=1000M
#SBATCH --time=4:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1

#module load vital-it/7
#module load SequenceAnalysis/GenePrediction/prodigal/2.6.3
module load prodigal/2.6.3-GCCcore-10.3.0

INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REFERENCES/dRep_ONLY_bin_ref_fastANI_genomes
OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/13_Prodigal


cd $INDIR

for i in *fa
do
 prodigal -i $i -o "$OUTDIR"/"$i".genes -a "$OUTDIR"/"$i".genes.faa -d "$OUTDIR"/"$i".genes.fna -m -p single
done
