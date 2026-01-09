module load SeqKit/2.6.1

for i in *deer.asm_contigs.fasta
do
sample=${i%_deer.asm_contigs.fasta} 
seqkit seq -m 1000 $i > "$sample".filtered.contigs.fasta
#echo "$sample".filtered.contigs.fasta
done

