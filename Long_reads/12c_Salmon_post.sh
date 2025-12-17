


python 03_summarize_salmon_files.py 

mkdir -p quant_files

mv *quant.counts quant_files/

#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=03:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
python 04_split_salmon_out_into_bins.py quant_files /rs_scratch/users/rj23k073/04_Deer/IBU/taxonomy/genomes DEER_v2.fa > bin_abundance_table_DEER_v2.tab
