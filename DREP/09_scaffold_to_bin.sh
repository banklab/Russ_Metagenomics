

module load Python/3.9.5-GCCcore-10.3.0

cd /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain

for i in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_8*_drep_LR_bins_and_SR_bins
do

drep2=$(basename "$i") 
drep1="${drep2%%_drep_*}"  
drep="${drep1%%05_}"  

./parse_stb.py --reverse -f /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_80_drep_LR_bins_and_SR_bins/dereplicated_genomes/*fa -o DEER_v2.stb
