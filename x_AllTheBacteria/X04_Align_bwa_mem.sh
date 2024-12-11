#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load BWA/0.7.17-GCC-10.3.0
module load SAMtools/1.13-GCC-10.3.0
for i in $(cat dir_list_all.txt)
do
  cd $i
  for j in {1..10}
  do
    bwa mem "$i"_database.fa /storage/scratch/users/rj23k073/04_DEER/04_FastUniq/1_"$j".R1.dedup.fastq /storage/scratch/users/rj23k073/04_DEER/04_FastUniq/1_"$j".R2.dedup.fastq > deer_1_"$j"_"$i".sam
    samtools view -Sb deer_1_"$j"_"$i".sam > deer_1_"$j"_"$i".bam
    rm deer_1_"$j"_"$i".sam
  done
  echo "done:" $i
  cd ..
done
