

library(data.table)

for(ENV in 1:10){
for(DEER in 1:7){

  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/RAW")
  snv_file <- data.frame(fread(paste0(DEER,"_",ENV,"_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- gsub(".*asm_","",snv_file$scaffold)
  
  if(sum(grep("scaffold",snv_file$bin))>0){message("ERROR");break}
  
  snv_file$Deer <- DEER
  
  snv_file$Env <- ENV
  
  snv_file$Scaffold <- gsub(".*NODE_|_length_.*","",snv_file$scaffold)
  
  snv_file$POS <- snv_file$position
  
  snv_file$DP <- snv_file$position_coverage

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20:25,4:19,1)]

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS)

  snv_file2$Sp.ID <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS)

  snv_file2$Sp.ID.deer <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer)

  snv_file2$Original <- TRUE
  
 

  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")
  write.csv(snv_file2, paste0(DEER,"_",ENV,"_InStrain_SNVs_format.csv"), row.names = F)

  
}}


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")
for(ENV in 1:10){
for(DEER in 1:7){

  snv_file3 <- data.frame(fread(paste0(DEER,"_",ENV,"_InStrain_SNVs_format.csv"), header=T, stringsAsFactors = F))

  if(DEER==1){full_df <- snv_file3} else {full_df <- rbind(full_df, snv_file3)}

  write.csv(full_df, paste0("ENV",ENV,"_SNPS.csv"), row.names = F)

  if(length(unique(full_df$ENV))>1){message("ERROR");break}
  
}}
  
