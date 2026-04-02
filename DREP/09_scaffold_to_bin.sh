

module load Python/3.9.5-GCCcore-10.3.0

cd /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain


## 80's drep
for i in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_8*_drep_LR_bins_and_SR_bins
do

drep1=$(basename "$i") 
drep=$(echo "$drep1" | cut -d'_' -f2)

./parse_stb.py --reverse -f /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_"$drep"_drep_LR_bins_and_SR_bins/dereplicated_genomes/*fa -o /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/01_References/DEER_drep"$drep".stb

done

## 90's drep
for i in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_9*_drep_LR_bins_and_SR_bins
do

drep1=$(basename "$i") 
drep=$(echo "$drep1" | cut -d'_' -f2)

./parse_stb.py --reverse -f /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_"$drep"_drep_LR_bins_and_SR_bins/dereplicated_genomes/*fa -o /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/01_References/DEER_drep"$drep".stb

done
