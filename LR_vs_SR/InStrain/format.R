

library(data.table)

for(ENV in c(1:6,8:10)){
for(DEER in c(2,4,6,7){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/RAW")
  snv_file <- data.frame(fread(paste0(DEER,"_",ENV,"_LR28_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- gsub(".*asm_","",snv_file$scaffold) ## make variable for species (bin)

  snv_file$Method <- "LR28"

  snv_file$bin <- paste0(snv_file$Method,"_",snv_file$bin)
  
  if(sum(grep("scaffold",snv_file$bin))>0){stop("ERROR")}
  
  snv_file$Deer <- DEER 
  
  snv_file$Env <- ENV 
  
  snv_file$Scaffold <- gsub(".*NODE_|_length_.*","",snv_file$scaffold) 
  
  snv_file$POS <- snv_file$position 
  
  snv_file$DP <- snv_file$position_coverage 

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20,22:26,4:19,1,21)] ### CHECK ##################

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS) 

  snv_file2$Sp.ID <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS) 

  snv_file2$Sp.ID.deer <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer) 

  snv_file2$Original <- TRUE 
  
 

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/FORMAT")
  write.csv(snv_file2, paste0(DEER,"_",ENV,"_LR28_InStrain_SNVs_format.csv"), row.names = F)
  
}}


  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/FORMAT")
for(ENV in c(1:6,8:10)){
for(DEER in c(2,4,6,7){

  snv_file3 <- data.frame(fread(paste0(DEER,"_",ENV,"_LR28_InStrain_SNVs_format.csv"), header=T, stringsAsFactors = F))

  if(DEER==1){full_df <- snv_file3} else {full_df <- rbind(full_df, snv_file3)}

  if(length(unique(full_df$ENV))>1){stop("ERROR")}
  
  }
  write.csv(full_df, paste0("ENV",ENV,"_LR28_SNPS.csv"), row.names = F)

}
  
