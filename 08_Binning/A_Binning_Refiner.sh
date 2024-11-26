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

TOOLA=01_MetaBAT2
TOOLA_PATH=metabat/scaffolds_filtered.fasta.metabat-bins*/*fa ## point to MetaBAT2 bins
TOOLB=02_MaxBin2
TOOLB_PATH=maxbin/*fasta ## point to MaxBin2 bins

INDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning/04_MetaMax ## MetaBAT2 & MaxBin2 results

mkdir $INDIR/TEMP1
mkdir $INDIR/TEMP1/TOOLA
mkdir $INDIR/TEMP1/TOOLB

rm $INDIR/TEMP1/TOOLA/*
rm $INDIR/TEMP1/TOOLB/*

cd $INDIR
for i in $(cat redux_sample_list.txt) ## iterate over each sample
do

cp "$INDIR/"$TOOLA/"$i"_"$DATASET"_$TOOLA_PATH $INDIR/TEMP1/TOOLA ## copy bins from first tool to working dir

cp "$INDIR/"$TOOLB/"$i"_"$DATASET"_$TOOLB_PATH $INDIR/TEMP1/TOOLB ## copy bins from second tool to working dir

cd $OUTDIR

Binning_refiner -i "$INDIR"/TEMP1 -p $i ## run binning refiner on both bin sets

cd $INDIR

rm $INDIR/TEMP1/TOOLA/* ## remove the bins we copied to working dir
rm $INDIR/TEMP1/TOOLB/*

done

echo Finished $TOOLA $TOOLB
