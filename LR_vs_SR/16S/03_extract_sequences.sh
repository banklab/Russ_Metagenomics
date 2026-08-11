

module load BEDTools/2.30.0-GCC-10.3.0

ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/03_assembly
OUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/16S/05_extracted_sequences


for f in *16S.gff
do

ID="${f#LR28_contigs_}"
ID="${ID%_16S.gff}"

bedtools getfasta \
    -fi "$ASM_DIR"/"$ID".asm.p_ctg.fa \
    -bed $f \
    -s \
    -name \
    > "$OUT_DIR"/LR28_"$ID"_contigs_16S.fa

done



module load BEDTools/2.30.0-GCC-10.3.0

ASM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly
OUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/16S/05_extracted_sequences


for f in SR28_scaffolds*16S.gff
do

ID="${f#SR28_scaffolds_}"
ID="${ID%_16S.gff}"

bedtools getfasta \
    -fi "$ASM_DIR"/"$ID"_deer.asm/"$ID"_scaffolds_filtered_NoNorm.fasta \
    -bed $f \
    -s \
    -name \
    > "$OUT_DIR"/SR28_"$ID"_scaffolds_16S.fa

done
