

library(Biostrings)

## fasta clustered at 50% identity (amino acids)
aa_rep <- "genes50_rep_seq.fasta"
## prodigal output (nucleotide)
nt_all <- "nucl_from_contigs.fna"

## output file - a fasta clustered at 50% identity, but it's the dna now instead of amino acids
out_fasta <- "genes50_rep_seq_DNA.fna"

aa_seqs <- readAAStringSet(aa_rep)

# prodigal id's
rep_ids <- sub(" .*", "", names(aa_seqs))

# all nucleotide seqs
nt_seqs <- readDNAStringSet(nt_all)

keep <- names(nt_seqs) %in% rep_ids
nt_rep <- nt_seqs[keep]

# now nucleotides at 50% clustering
writeXStringSet(nt_rep, out_fasta)
