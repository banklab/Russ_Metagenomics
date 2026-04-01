actually run on ubelix

#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4


for i in DEER_drep*fa
do

tmp="${i%.fa}"
#drep_val="${tmp##*drep}"

salmon index -p 4 -t $i -i "$tmp"_salmon_index

echo "done $tmp"

done
