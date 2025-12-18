EnvA <- 8
EnvB <- 10



library(data.table)

for(DEER in 1:7){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/RAW")
  snv_file <- data.frame(fread(paste0("deer",DEER,"_env",EnvA,"_env",EnvB,"_LR_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
  
  snv_file$bin <- gsub(".*asm_","",snv_file$scaffold) ## make variable for species (bin)

  snv_file$Method <- "SR"

  snv_file[grepl("metabat|maxbin|semibin",snv_file$bin),"Method"] <- "LR"
  snv_file[grepl("hybrid",snv_file$bin),"Method"] <- "Hy"

  snv_file$bin <- gsub(".*metabat","Me",snv_file$bin)
  snv_file$bin <- gsub(".*maxbin","Ma",snv_file$bin)
  snv_file$bin <- gsub(".*semibin","Se",snv_file$bin)

  snv_file$bin <- paste0(snv_file$Method,"_",snv_file$bin)
  
  if(sum(grep("scaffold",snv_file$bin))>0){stop("ERROR")}
  
  snv_file$Deer <- DEER ## record deer ## change as study system requires
  
  snv_file$Env <- paste0()
  
  snv_file$Scaffold <- gsub(".*NODE_|_length_.*","",snv_file$scaffold) ## record scaffold
  
  snv_file$POS <- snv_file$position ## record position
  
  snv_file$DP <- snv_file$position_coverage ## record coverage

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20,22:26,4:19,1,21)]

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS) ## make snp ID with scaffold and position

  snv_file2$Sp.ID <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS) ## species-specific snp ID

  snv_file2$Sp.ID.deer <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer) ## species-deer-specific snp ID

  snv_file2$Original <- TRUE ## these are original snps called by InStrain (later I add in sites that were fixed reference, ie, not original)
  
 

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")
  write.csv(snv_file2, paste0(DEER,"_",ENV,"_LR_InStrain_SNVs_format.csv"), row.names = F)
  
}


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")
for(ENV in c(8,10)){
for(DEER in 1:7){

  snv_file3 <- data.frame(fread(paste0(DEER,"_",ENV,"_LR_InStrain_SNVs_format.csv"), header=T, stringsAsFactors = F))

  if(DEER==1){full_df <- snv_file3} else {full_df <- rbind(full_df, snv_file3)}

  if(length(unique(full_df$ENV))>1){stop("ERROR")}
  
  }
  write.csv(full_df, paste0("ENV",ENV,"_SNPS.csv"), row.names = F)

}
  
