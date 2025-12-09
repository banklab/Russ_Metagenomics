
## MetaBAT2

for asm in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly/*.asm.p_ctg.gfa
do

## sample ID
SAMPLE=$(basename "$asm" .asm.p_ctg.gfa)
 mkdir -p $SAMPLE
cp metabat_"$SAMPLE"_bin*fa $SAMPLE
done



## MaxBin2

for asm in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly/*.asm.p_ctg.gfa
do

## sample ID
SAMPLE=$(basename "$asm" .asm.p_ctg.gfa)
 mkdir -p $SAMPLE
cp maxbin_"$SAMPLE"_bin*fasta $SAMPLE
done



## SemiBin2

for asm in /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly/*.asm.p_ctg.gfa
do

## sample ID
SAMPLE=$(basename "$asm" .asm.p_ctg.gfa)
 mkdir -p $SAMPLE
cp semibin_"$SAMPLE"_bin*fa $SAMPLE
done
