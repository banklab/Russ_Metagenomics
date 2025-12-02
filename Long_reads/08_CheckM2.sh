conda activate checkm2_env

#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=4:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out

for i in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/07_DAS_Tool/*_DASTool_bins
do
 SAMPLE=$(basename $i _DASTool_bins)

 echo $SAMPLE

 checkm2 predict --input $i \
  --output_directory /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_CheckM2/"$SAMPLE" \
 -x fa \
 -t 16
done
