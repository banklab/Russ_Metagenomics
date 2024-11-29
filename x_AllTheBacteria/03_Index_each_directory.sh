#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load BWA/0.7.17-GCC-10.3.0

for i in $(cat dir_list_all.txt)
do
  cd $i
  cat *fa > "$i"_database.fa
  bwa index "$i"_database.fa
  echo "done:" $i
  cd ..
done
