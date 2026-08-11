for f in LR28_contigs*gff
do
base=$(basename "$f" .asm.p_ctg.gff)


awk -F'\t' '$3=="rRNA" && $9 ~ /Name=16S_rRNA/ {print}' \
$f > ../04_rRNA_only_16S/${base}_16S.gff

done


for f in SR28_scaffolds_*gff
do
base=$(basename "$f" .gff)
awk -F'\t' '$3=="rRNA" && $9 ~ /Name=16S_rRNA/ {print}' \
$f > ../04_rRNA_only_16S/${base}_16S.gff

done


#for f in SR28_contigs*gff
#do
#base=$(basename "$f" .gff)
#awk -F'\t' '$3=="rRNA" && $9 ~ /Name=16S_rRNA/ {print}' \
#$f > ../04_rRNA_only_16S/${base}_16S.gff
#done
