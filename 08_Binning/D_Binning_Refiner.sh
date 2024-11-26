#!/bin/bash
#SBATCH --mem=1000M
#SBATCH --time=0:45:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load Python/3.10.8-GCCcore-12.2.0


## see A script for annotations

DATASET=deer

TOOLG=01_MetaBAT2
TOOLG_PATH=metabat/scaffolds_filtered.fasta.metabat-bins*/*fa
TOOLH=02_MaxBin2
TOOLH_PATH=maxbin/*fasta
TOOLI=03_CONCOCT
TOOLI_PATH=concoct/concoct_output/fasta_bins/*fa

INDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/08_Binning/07_MetaMaxCon

mkdir $INDIR/TEMP4
mkdir $INDIR/TEMP4/TOOLG
mkdir $INDIR/TEMP4/TOOLH
mkdir $INDIR/TEMP4/TOOLI

rm $INDIR/TEMP4/TOOLG/*
rm $INDIR/TEMP4/TOOLH/*
rm $INDIR/TEMP4/TOOLI/*


cd $INDIR
for i in $(cat redux_sample_list.txt)
do

cp "$INDIR/"$TOOLG/"$i"_"$DATASET"_$TOOLG_PATH $INDIR/TEMP4/TOOLG

cp "$INDIR/"$TOOLH/"$i"_"$DATASET"_$TOOLH_PATH $INDIR/TEMP4/TOOLH

cp "$INDIR/"$TOOLI/"$i"_"$DATASET"_$TOOLI_PATH $INDIR/TEMP4/TOOLI

cd $OUTDIR

Binning_refiner -i "$INDIR"/TEMP4 -p $i

cd $INDIR

rm $INDIR/TEMP4/TOOLG/*
rm $INDIR/TEMP4/TOOLH/*
rm $INDIR/TEMP4/TOOLI/*

done

echo Finished $TOOLG $TOOLH $TOOLI
