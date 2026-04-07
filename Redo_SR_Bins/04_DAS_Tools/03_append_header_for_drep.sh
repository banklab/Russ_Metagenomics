
INDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/04_DAS_Tool
OUTDIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/05_drep/01_input


cd $INDIR


for i in *_DASTool_bins
 do
 cd "$i"
 
for f in *.fa; do

    header_tag="${f%.fa}"

    sed "s/^>.*/&_asm_${header_tag}/" "$f" > "$OUTDIR/$f"


done
cd $INDIR
done
