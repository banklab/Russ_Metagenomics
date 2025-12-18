

library(data.table)

for(ENV in 1:10){
for(DEER in 1:7){

  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/RAW")
  snv_file <- data.frame(fread(paste0(DEER,"_",ENV,"_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- gsub(".*asm_","",snv_file$scaffold) ## make variable for species (bin)
  
  if(sum(grep("scaffold",snv_file$bin))>0){stop("ERROR")}
  
  snv_file$Deer <- DEER ## record deer ## change as study system requires
  
  snv_file$Env <- ENV ## record sampling environment ## change as study system requires
  
  snv_file$Scaffold <- gsub(".*NODE_|_length_.*","",snv_file$scaffold) ## record scaffold
  
  snv_file$POS <- snv_file$position ## record position
  
  snv_file$DP <- snv_file$position_coverage ## record coverage

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20:25,4:19,1)]

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS) ## make snp ID with scaffold and position

  snv_file2$Sp.ID <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS) ## species-specific snp ID

  snv_file2$Sp.ID.deer <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer) ## species-deer-specific snp ID

  snv_file2$Original <- TRUE ## these are original snps called by InStrain (later I add in sites that were fixed reference, ie, not original)
  
 

  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")
  write.csv(snv_file2, paste0(DEER,"_",ENV,"_InStrain_SNVs_format.csv"), row.names = F)

  
}}


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")
for(ENV in 1:10){
for(DEER in 1:7){

  snv_file3 <- data.frame(fread(paste0(DEER,"_",ENV,"_InStrain_SNVs_format.csv"), header=T, stringsAsFactors = F))

  if(DEER==1){full_df <- snv_file3} else {full_df <- rbind(full_df, snv_file3)}
  
  if(length(unique(full_df$ENV))>1){message("ERROR");break}

  }
  write.csv(full_df, paste0("ENV",ENV,"_SNPS.csv"), row.names = F)
  
}
  
