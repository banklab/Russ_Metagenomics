
module load Python/3.9.5-GCCcore-10.3.0

python 03_summarize_salmon_files.py 

mkdir -p quant_files

mv *quant.counts quant_files/

python 04_split_salmon_out_into_bins.py quant_files /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/05_drep/03_drep/dereplicated_genomes /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/REFERENCES/DEER_SR.fa > bin_abundance_table_DEER_SR.tab
