

# 16S reference 99% derep
# SILVA_SSURef_NR99.nocontam.masked.trimmed.NR99.fasta
# https://zenodo.org/records/18627380

# taxonomy of sequences
# silva-138-99-tax.qza
# https://docs.qiime2.org/2024.10/data-resources/


module load BLAST+/2.15.0-gompi-2021a
makeblastdb \
    -in SILVA_SSURef_NR99.nocontam.masked.trimmed.NR99.fasta \
    -dbtype nucl \
    -out SILVA_SSURef_NR99


    
module load BLAST+/2.15.0-gompi-2021a

DATABASE=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/16S/SILVA_database
OUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/16S/06_blast_hits

for f in LR28*_16S.fa

do

base=$(basename "$f" _contigs_16S.fa)
blastfile="$OUT_DIR"/"$base"_vs_16S_SILVA.out

blastn \
    -query $f \
    -db "$DATABASE"/SILVA_SSURef_NR99 \
    -out "$blastfile" \
    -outfmt "6 qseqid sseqid pident length qcovs evalue bitscore" \
    -max_target_seqs 10 \
    -evalue 1e-20
