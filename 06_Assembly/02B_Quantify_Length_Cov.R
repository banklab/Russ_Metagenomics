
INDIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly/QUANTIFY_ASM_LENGTH_COV/data"
OUTDIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly/QUANTIFY_ASM_LENGTH_COV"

hypothetical_length_filter <- 1500
hypothetical_coverage_filter <- 2



setwd(INDIR)
file_list <- list.files(pattern = "data.txt")

asm_df <- data.frame(array(NA, dim = c(0,3), dimnames = list(c(),c("sample","length","coverage"))))

sample_df <- data.frame(array(NA, dim = c(length(file_list),9), dimnames = list(c(),c("sample","mean.length","mean.coverage","pass.length.filter","prop.total.length.passes.length.filter","pass.coverage.filter","prop.total.length.passes.coverage.filter","prop.keep.both","prop.total.length.passes.both.filter"))))

for(i in 1:length(file_list)){
  
  data2 <- read.table(file_list[i], header=F, stringsAsFactors = F)

  asm_df_TEMP <- data.frame(array(NA, dim = c(length(data2$V1),3), dimnames = list(c(),c("sample","length","coverage"))))
  
  asm_df_TEMP[,1] <- gsub("_deer.*","",file_list[i])
  
  asm_df_TEMP[,2] <- as.numeric(gsub(".*_length_|_cov_.*", "", data2$V1))
  
  asm_df_TEMP[,3] <- as.numeric(gsub(".*_cov_", "", data2$V1))

  asm_df <- rbind (asm_df, asm_df_TEMP)
  
  
  sample_df[i,1] <-gsub("_deer.*","",file_list[i])
  
  sample_df[i,2] <- mean(asm_df_TEMP[,2])
  
  sample_df[i,3] <- mean(asm_df_TEMP[,3])
  
  sample_df[i,4] <- sum(asm_df_TEMP[,2] >= hypothetical_length_filter) / length(asm_df_TEMP[,2])
  
  sample_df[i,5] <- sum(asm_df_TEMP[asm_df_TEMP[,2] >= hypothetical_length_filter,"length"]) / sum(asm_df_TEMP[,2])
  
  sample_df[i,6] <- sum(asm_df_TEMP[,3] >= hypothetical_coverage_filter) / length(asm_df_TEMP[,3])
  
  sample_df[i,7] <- sum(asm_df_TEMP[asm_df_TEMP[,3] >= hypothetical_coverage_filter,"length"]) / sum(asm_df_TEMP[,2])
  
  sample_df[i,8] <- sum(asm_df_TEMP[,2] >= hypothetical_length_filter & asm_df_TEMP[,3] >= hypothetical_coverage_filter) / length(asm_df_TEMP[,2])
  
  sample_df[i,9] <- sum(asm_df_TEMP[asm_df_TEMP[,2] >= hypothetical_length_filter & asm_df_TEMP[,3] >= hypothetical_coverage_filter,"length"]) / sum(asm_df_TEMP[,2])
  
}

setwd(OUTDIR)
write.csv(asm_df, "ASM_Length_and_Cov_RESULTS_by_scaffold.csv", row.names = F)

write.csv(sample_df, "ASM_Length_and_Cov_RESULTS_by_sample.csv", row.names = F)



