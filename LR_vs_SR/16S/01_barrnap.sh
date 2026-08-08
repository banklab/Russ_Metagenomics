#!/bin/bash
#SBATCH --mem=8000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


for f in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly/*asm.p_ctg.fa
do
    base=$(basename "$f" .fa)
    barrnap --kingdom bac "$f" > "03_Barrnap/LR28_contigs_${base}.gff"
done



#!/bin/bash
#SBATCH --mem=8000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


for f in TEMP/*fasta
do
    base=$(basename "$f" _deer.asm_contigs.fasta)
    barrnap --kingdom bac "$f" > "03_Barrnap/SR28_contigs_${base}.gff"
done
