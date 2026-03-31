#!/bin/bash
#SBATCH --mem=4000M
#SBATCH --time=6:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=pibu_el8 

module load prodigal/2.6.3-GCCcore-10.3.0

INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep
OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/03_Prodigal

cd $INDIR


### to avoid rerunning 95%
for drep in 05_8*_drep_LR_bins_and_SR_bins
do

tmp="${drep#*_}"
drep_val="${tmp%%_*}"

echo "start drep $drep_val"

cd "$INDIR"/"$drep"/dereplicated_genomes

mkdir -p "$OUTDIR/Genes_drep$drep_val"
mkdir -p "$OUTDIR/FAA_drep$drep_val"
mkdir -p "$OUTDIR/FNA_drep$drep_val"

for i in *fa
do
 prodigal -i $i -o "$OUTDIR"/Genes_drep"$drep_val"/"$i".genes -a "$OUTDIR"/FAA_drep"$drep_val"/"$i".genes.faa -d "$OUTDIR"/FNA_drep"$drep_val"/"$i".genes.fna -m -p single
done

echo "done drep $drep_val"

cd $INDIR

done



