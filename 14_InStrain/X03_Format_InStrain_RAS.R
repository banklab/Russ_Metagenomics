

library(data.table)

setwd("/storage/scratch/users/rj23k073/01_RAS/14_InStrain/RAW")

setwd("/data/projects/p898_Deer_RAS_metagenomics/01_RAS/14_InStrain/01_One_Population/RAW")

tsv <- list.files(pattern="InStrain_SNVs.tsv$")

for(i in 1:length(tsv)){
  
  snv_file <- data.frame(fread(tsv[i], header=T, stringsAsFactors = F))
  
  snv_file$Species <- gsub(".*_asm_","",snv_file$scaffold)
  
  if(sum(grep("scaffold",snv_file$Species))>0){message("ERROR");break}
  
  snv_file$Sample <- as.numeric(gsub("_InStrain.*","",tsv[i]))
  
  snv_file$Scaffold <- as.numeric(gsub(".*NODE_|_length_.*","",snv_file$scaffold))
  
  snv_file$POS <- snv_file$position
  
  snv_file$DP <- snv_file$position_coverage
  
  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20:24,4:19,1)]
  
  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS)
  
  snv_file2$Sp.ID <- paste0(snv_file2$Species,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS)
  
  snv_file2$Original <- TRUE
  
  write.csv(snv_file2, paste0(as.numeric(gsub("_InStrain.*","",tsv[i])),"_InStrain_SNVs_format.csv"), row.names = F)

}

