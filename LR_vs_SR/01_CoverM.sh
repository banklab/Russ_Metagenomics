
## LR

BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment

for bam in "$BAM_DIR"/2_*LR.sorted.bam
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

--genome-fasta-files *.fa
## SR
