#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load vital-it/7
module load UHTS/Aligner/bowtie2
module load UHTS/Analysis/samtools/1.10
bowtie2-build dRep_ONLY_bin_ref_fastANI.fasta dRep_ONLY_bin_ref_fastANI
