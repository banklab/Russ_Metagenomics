#!/bin/bash
#SBATCH --mem=1000M
#SBATCH --time=4:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
module load prodigal/2.6.3-GCCcore-10.3.0

INDIR=/storage/scratch/users/rj23k073/04_DEER/11_dRep/03_drep_bins
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/13_Prodigal


cd $INDIR

for i in *fa
do
 prodigal -i $i -o "$OUTDIR"/"$i".genes -a "$OUTDIR"/"$i".genes.faa -d "$OUTDIR"/"$i".genes.fna -m -p single
done
