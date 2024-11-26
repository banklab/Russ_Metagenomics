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


## see A script for annotations


DATASET=deer

TOOLE=02_MaxBin2
TOOLE_PATH=maxbin/*fasta
TOOLF=03_CONCOCT
TOOLF_PATH=concoct/concoct_output/fasta_bins/*fa

INDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning/06_MaxCon

mkdir $INDIR/TEMP3
mkdir $INDIR/TEMP3/TOOLE
mkdir $INDIR/TEMP3/TOOLF

rm $INDIR/TEMP3/TOOLE/*
rm $INDIR/TEMP3/TOOLF/*

cd $INDIR
for i in $(cat redux_sample_list.txt)
do

cp "$INDIR/"$TOOLE/"$i"_"$DATASET"_$TOOLE_PATH $INDIR/TEMP3/TOOLE

cp "$INDIR/"$TOOLF/"$i"_"$DATASET"_$TOOLF_PATH $INDIR/TEMP3/TOOLF

cd $OUTDIR

Binning_refiner -i "$INDIR"/TEMP3 -p $i

cd $INDIR

rm $INDIR/TEMP3/TOOLE/*
rm $INDIR/TEMP3/TOOLF/*

done

echo Finished $TOOLE $TOOLF
