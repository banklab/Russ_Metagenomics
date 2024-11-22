library(seqinr)


INDIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly"

MIN_LENGTH <- 1500
MIN_COV <- 2

setwd(INDIR)
assembly_directories <- list.files(pattern = "asm")

for(i in 1:length(assembly_directories)){

  asm_sample <- assembly_directories[i]

  setwd(asm_sample)
  
  fasta_file <- read.fasta("scaffolds.fasta")
  
  names_list <- names(fasta_file)
  
  fasta_df <- data.frame(array(NA, dim = c(length(names_list),3), dimnames = list(c(),c("Name","Length","Coverage"))))
  
  fasta_df[,1] <- names_list
  fasta_df[,2] <- as.numeric(gsub(".*length_|_cov.*","",names_list))
  fasta_df[,3] <- as.numeric(gsub(".*cov_","",names_list))
  
  
  filter_df <- fasta_df[fasta_df$Length >= MIN_LENGTH & fasta_df$Coverage >= MIN_COV, ]
  
  
  filter_fasta <- fasta_file[names(fasta_file) %in% filter_df$Name]
  
  write.fasta(filter_fasta, names(filter_fasta),"scaffolds_filtered.fasta")
  
  log_file <- array(NA, dim = c(4,1), dimnames = list(c("Total Sequences", "Pass Length", "Pass Coverage", "Pass Both"),c()))
  
  log_file[1,] <- length(names_list)
  log_file[2,] <- sum(fasta_df$Length >= MIN_LENGTH)
  log_file[3,] <- sum(fasta_df$Coverage >= MIN_COV)
  log_file[4,] <- length(filter_df$Name)
  
  write.table(log_file,  gsub("\\.asm.*","_filter_log.txt",asm_sample), row.names = T, col.names = F)
  
  setwd(INDIR)
}
