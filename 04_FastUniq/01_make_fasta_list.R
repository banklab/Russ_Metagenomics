
INPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/03_Trim"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/04_FastUniq"


setwd(INPUT_DIR)

fasta_files <- list.files(pattern = "\\.trim.fastq")

sample_list <- unique(gsub("\\_R1.*|\\_R2.*","",fasta_files))

length(sample_list)

empty_file <- array(NA, dim = c(2,1))

for(i in 1:length(sample_list)){
  
  samp <- sample_list[i]
  
  ## make fastq input list for fastuniq
  file_name <- paste0(samp, "_fastq_list.txt")
  
  empty_file[1,1] <- paste0(INPUT_DIR,"/", samp, "_R1.trim.fastq")
  empty_file[2,1] <- paste0(INPUT_DIR,"/", samp, "_R2.trim.fastq")
  
  setwd(OUTPUT_DIR)
  write.table(empty_file, file_name, row.names = F, col.names = F, quote = F)

}
