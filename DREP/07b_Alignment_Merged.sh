#!/bin/bash
#SBATCH --mem=24000M
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8
module load SAMtools/1.13-GCC-10.3.0

envA=8
envB=10

DREP=80

for i in {1..7}
do
echo "deer $i"

samtools merge -@ 4 - \
  "$i"_"$envA"_drep"$DREP".bam \
  "$i"_"$envB"_drep"$DREP".bam \
| samtools sort -@ 4 -o deer"$i"_env"$envA"_env"$envB"_drep"$DREP".bam -

samtools index deer"$i"_env"$envA"_env"$envB"_drep"$DREP".bam

done
