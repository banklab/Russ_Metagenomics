#!/bin/bash
#SBATCH --mem==40000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=3:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8 

module load Bowtie2/2.4.4-GCC-10.3.0
bowtie2-build DEER_v2.fa DEER_v2
