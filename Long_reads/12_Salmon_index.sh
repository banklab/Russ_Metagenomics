actually run on ubelix

#!/bin/bash
#SBATCH --mem=60000M
#SBATCH --time=2:50:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=END,FAIL
#SBATCH --output=slurm-%x.%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=pibu_el8
salmon index -p 4 -t DEER_v2.fa -i DEER_v2_salmon_index
