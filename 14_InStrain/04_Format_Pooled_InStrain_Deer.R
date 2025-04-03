
## format pooled snp outputs, same as previous


library(data.table)

setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/02_Two_Populations/RAW2")
instrain_files <- list.files(pattern="InStrain_SNVs.tsv")

EnvA_list <- unique(as.numeric(gsub("_env.*","",gsub(paste0("deer",1:7,"_env", collapse = "|"),"",instrain_files))))


for(EnvA in EnvA_list){

EnvB_list <- unique(as.numeric(gsub(".*_env","",gsub("_InStrain_.*","",instrain_files[grepl(paste0("deer",1:7,"_env",EnvA, collapse = "|"), instrain_files)]))))
  
for(EnvB in EnvB_list){

for(DEER in 1:7){

  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/02_Two_Populations/RAW2")
  snv_file <- data.frame(fread(paste0("deer",DEER,"_env",EnvA,"_env",EnvB,"_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- gsub(".*asm_","",snv_file$scaffold)
  
  if(sum(grep("scaffold",snv_file$bin))>0){message("ERROR");break}
  
  snv_file$Deer <- DEER
  
  snv_file$Env <- paste0("Env",EnvA,"_Env",EnvB)
  
  snv_file$Scaffold <- gsub(".*NODE_|_length_.*","",snv_file$scaffold)
  
  snv_file$POS <- snv_file$position
  
  snv_file$DP <- snv_file$position_coverage

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20:25,4:19,1)]

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS)

  snv_file2$Sp.ID <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS)

  snv_file2$Sp.ID.deer <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer)


  if(DEER==1){full_df <- snv_file2} else {full_df <- rbind(full_df, snv_file2)}
  
}

setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/02_Two_Populations")
write.csv(full_df, paste0("Pooled_Env",EnvA,"_Env",EnvB,"_snps.csv"), row.names = F)

}
}
