#!/bin/bash
#SBATCH --mem=1000M
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8
module load SAMtools/1.13-GCC-10.3.0
envA=8
envB=10
for i in {1..7}
do
echo $i
samtools merge deer"$i"_env"$envA"_env"$envB"_LR.bam "$i"_"$envA"_LR.sorted.bam "$i"_"$envB"_LR.sorted.bam
samtools sort deer"$i"_env"$envA"_env"$envB"_LR.bam > deer"$i"_env"$envA"_env"$envB"_LR.sorted.bam
samtools index deer"$i"_env"$envA"_env"$envB"_LR.sorted.bam
done
