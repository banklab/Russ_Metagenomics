#!/bin/bash
#SBATCH --mem=8000M
#SBATCH --time=96:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
module load prodigal/2.6.3-GCCcore-10.3.0

INDIR=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/06_Assembly/
OUTDIR=/rs_scratch/users/rj23k073/04_Deer/30_Community

cd $INDIR

for i in *deer.asm
do
  sample=$(basename "$i" .asm)
  prodigal -i "$i/scaffolds.fasta" -o "$OUTDIR/${sample}.genes" -a "$OUTDIR/${sample}.genes.faa" -d "$OUTDIR/${sample}.genes.fna" -p meta
done
