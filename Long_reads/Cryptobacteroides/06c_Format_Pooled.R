EnvA <- 8
EnvB <- 10

library(data.table)

for(DEER in 1:7){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/03_InStrain/RAW")
  snv_file <- data.frame(fread(paste0("deer",DEER,"_env",EnvA,"_env",EnvB,"_transposase_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- NA

  snv_file$Method <- NA
  
  snv_file$Deer <- DEER 
  
  snv_file$Env <- paste0("Env",EnvA,"_Env",EnvB)
  
  snv_file$Scaffold <- snv_file$scaffold
  
  snv_file$POS <- snv_file$position 
  
  snv_file$DP <- snv_file$position_coverage 

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20,22:26,4:19,1,21)]

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS) 
  
  snv_file2$Sp.ID.deer <- paste0("sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer) 
  
  snv_file2$Original <- TRUE 
 

 if(DEER==1){full_df <- snv_file2} else {full_df <- rbind(full_df, snv_file2)}
  
}

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/03_InStrain/FORMAT")
write.csv(full_df, paste0("Pooled_Env",EnvA,"_Env",EnvB,"_transposase_snps.csv"), row.names = F)
