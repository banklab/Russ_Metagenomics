
## LR28 + SR70

BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment


## parallel by deer
for bam in "$BAM_DIR"/1_*LR.sorted.bam
do


BASE=$(basename "$bam")

ID="${BASE%%_LR.sorted.bam}"

OUTPUT="$ID".LR.abundance.tsv


coverm genome \
  -b $bam \
  --genome-fasta-files /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/05_drep_LR_bins_and_SR_bins/dereplicated_genomes/*fa \
  -m relative_abundance mean \
  -o $OUTPUT

done



## LR28

BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/01_Alignment

for bam in "$BAM_DIR"/*.bam
do

BASE=$(basename "$bam")

ID="${BASE%%.bam}"

OUTPUT="$ID".LR28.abundance.tsv


coverm genome \
  -b $bam \
  --genome-fasta-files /data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/REFERENCES/genomes/*fa \
  -m relative_abundance mean \
  -o $OUTPUT

done




## SR70

BAM_DIR=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/12_Alignment


## parallel by deer
for bam in "$BAM_DIR"/1_*.sorted.bam
do


BASE=$(basename "$bam")

ID="${BASE%%.sorted.bam}"

OUTPUT="$ID".SR70.abundance.tsv


coverm genome \
  -b $bam \
  --genome-fasta-files /storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/11_dRep/03_drep_bins/dereplicated_genomes/*fa \
  -m relative_abundance mean \
  -o $OUTPUT

done



## SR28

BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/06_Alignment

## parallel by deer
for bam in "$BAM_DIR"/1_*.bam
do

BASE=$(basename "$bam")

ID="${BASE%%.bam}"

OUTPUT="$ID".SR28.abundance.tsv


coverm genome \
  -b $bam \
  --genome-fasta-files /data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/05_drep/03_drep/dereplicated_genomes/*fa \
  -m relative_abundance mean \
  -o $OUTPUT

done

