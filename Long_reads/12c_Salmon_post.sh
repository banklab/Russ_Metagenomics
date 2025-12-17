


python 03_summarize_salmon_files.py 

mkdir -p quant_files

mv *quant.counts quant_files/

python 04_split_salmon_out_into_bins.py quant_files /rs_scratch/users/rj23k073/04_Deer/IBU/taxonomy/genomes DEER_v2.fa > bin_abundance_table_DEER_v2.tab
