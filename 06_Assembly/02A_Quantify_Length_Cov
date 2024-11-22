
INDIR=/storage/scratch/users/rj23k073/01_RAS/06_Assembly
OUTDIR=/storage/scratch/users/rj23k073/01_RAS/06_Assembly/QUANTIFY_ASM_LENGTH_COV/data

cd $INDIR
for i in *asm
 do
 cd $i
 grep '>NODE' scaffolds.fasta > "$OUTDIR"/"$i"_data.txt
 cd $INDIR
done
