library(data.table)

for(ENV in c(8,10)){
for(DEER in 1:7){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/03_InStrain/RAW")
  snv_file <- data.frame(fread(paste0(DEER,"_",ENV,"_transposase_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- NA

  snv_file$Method <- NA

  snv_file$Deer <- DEER
  
  snv_file$Env <- ENV
  
  snv_file$Scaffold <- snv_file$scaffold
  
  snv_file$POS <- snv_file$position
  
  snv_file$DP <- snv_file$position_coverage

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20,22:26,4:19,1,21)]

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS)
  
  snv_file2$Sp.ID.deer <- paste0("sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer)

  snv_file2$Original <- TRUE
 

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/03_InStrain/FORMAT")
  write.csv(snv_file2, paste0(DEER,"_",ENV,"_transposase_InStrain_SNVs.tsv"), row.names = F)
  
}}


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/03_InStrain/FORMAT")
for(ENV in c(8,10)){
for(DEER in 1:7){

  snv_file3 <- data.frame(fread(paste0(DEER,"_",ENV,"_transposase_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))

  if(DEER==1){full_df <- snv_file3} else {full_df <- rbind(full_df, snv_file3)}

  if(length(unique(full_df$ENV))>1){stop("ERROR")}
  
  }
  write.csv(full_df, paste0("ENV",ENV,"_transposase_SNPS.csv"), row.names = F)

}
  
