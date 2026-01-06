
# UBELIX



/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/blast/ncbi-blast-2.15.0+/bin/makeblastdb -in DEER.fa -dbtype nucl -out DEER


/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/programs/blast/ncbi-blast-2.15.0+/bin/blastn -query transposase.fa -db DEER -out transposase_vs_DEER_v1.out
