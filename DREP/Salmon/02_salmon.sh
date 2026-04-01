
REF_DIR=/storage/scratch/users/rj23k073/04_Deer/DREP/salmon/DEER_drep80_salmon_index

OUTDIR=/storage/scratch/users/rj23k073/04_Deer/DREP/salmon/DEER_drep80_salmon_out

mkdir -p $OUTDIR


INDIR=/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/03_Trim


for Read1 in "$INDIR"/*_R1.trim.fastq.gz
do

name=$(basename "$Read1")
ID="${name%%_R1*}"
    
salmon quant -i "$REF_DIR" --libType IU -1 "$Read1" -2 "${Read1/_R1./_R2.}" -o "$OUTDIR"/"$ID".quant --meta -p 1

echo "done $ID"

done
