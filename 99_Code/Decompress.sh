#!/bin/bash
#SBATCH --mem=1000M
#SBATCH --time=02:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
for i in nt*tar.gz
do
 tar -zxvf $i
done
