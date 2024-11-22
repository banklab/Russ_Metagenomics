#!/bin/bash
#SBATCH --mem=1000M
#SBATCH --time=0:35:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load Python/3.10.8-GCCcore-12.2.0


DATASET=deer

TOOLC=01_MetaBAT2
TOOLC_PATH=metabat/scaffolds_filtered.fasta.metabat-bins*/*fa
TOOLD=03_CONCOCT
TOOLD_PATH=concoct/concoct_output/fasta_bins/*fa

INDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning/05_MetaCon

mkdir $INDIR/TEMP2
mkdir $INDIR/TEMP2/TOOLC
mkdir $INDIR/TEMP2/TOOLD

rm $INDIR/TEMP2/TOOLC/*
rm $INDIR/TEMP2/TOOLD/*

cd $INDIR
for i in $(cat redux_sample_list.txt)
do

cp "$INDIR/"$TOOLC/"$i"_"$DATASET"_$TOOLC_PATH $INDIR/TEMP2/TOOLC

cp "$INDIR/"$TOOLD/"$i"_"$DATASET"_$TOOLD_PATH $INDIR/TEMP2/TOOLD

cd $OUTDIR

Binning_refiner -i "$INDIR"/TEMP2 -p $i

cd $INDIR

rm $INDIR/TEMP2/TOOLC/*
rm $INDIR/TEMP2/TOOLD/*

done

echo Finished $TOOLC $TOOLD
