

module load Python/3.9.5-GCCcore-10.3.0

chmod +x parse_stb.py 

./parse_stb.py --reverse -f /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_drep_LR_bins_and_SR_bins/dereplicated_genomes/*fa -o DEER_v2.stb
