#!/bin/bash
#SBATCH --mem=4000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=12:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load vital-it/7
module load UHTS/Analysis/samtools/1.10
INDIR=/storage/scratch/users/rj23k073/04_DEER/07_BAM
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/07_BAM/02_Stats
cd $INDIR
for i in 1_*_filter.bam
do
file2=$(echo $i | perl -pe 's/bam/sorted.bam/')
flagfile=$(echo $i | perl -pe 's/bam/flagstat.txt/')
insertfile=$(echo $i | perl -pe 's/bam/insert_size.txt/')
samtools sort $i > $file2
samtools index $file2
samtools flagstat $file2 > $flagfile
samtools view -f66 $file2 | cut -f 9 | awk '{print sqrt($0^2)}' > $insertfile
mv $flagfile $OUTDIR
mv $insertfile $OUTDIR
done
