#!/bin/bash
#SBATCH --mem=32000M
#SBATCH --time=3:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8
module load Python/3.9.5-GCCcore-10.3.0
module load prodigal/2.6.3-GCCcore-10.3.0
module load HMMER/3.3.2-gompi-2021a
export GTDBTK_DATA_PATH=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/07_GTDB/release220/


INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/07_GTDB/missing_genomes
ID_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/07_GTDB/Identify
Aln_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/07_GTDB/Align

mkdir -p $ID_DIR
mkdir -p $Aln_DIR


gtdbtk identify --genome_dir $INDIR --out_dir $ID_DIR --extension fa --cpus 1

gtdbtk align --identify_dir $ID_DIR --out_dir $Aln_DIR --cpus 1

