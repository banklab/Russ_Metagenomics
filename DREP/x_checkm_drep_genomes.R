
checkm1 <- read.csv("Long_read_bins_CheckM2.csv", header=T, stringsAsFactors = F)
checkm2 <- read.csv("Hybrid_bins_CheckM2.csv", header=T, stringsAsFactors = F)
checkm3 <- read.csv("raw_Short_read_bins_CheckM2.csv", header=T, stringsAsFactors = F)

checkm <- rbind(checkm1,checkm2,checkm3)

drep_list <- list.files(pattern="drep_LR_bins_and_SR_bins")

drep_list <- drep_list[c(1,3,6:8)]

for(i in 1:length(drep_list)){
  
  setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/",drep_list[i],"/dereplicated_genomes"))
  
  if(drep_list[i]=="05_drep_LR_bins_and_SR_bins"){ drep_val <- 95 } else {
    drep_val <- as.numeric(gsub("05_|_drep.*","",drep_list[i]))
  }
  
  
  genomes <- list.files(pattern="fa")
  
  checkm_sub <- checkm[checkm$genome %in% genomes,]
  
  if( dim(checkm_sub)[1] != length(genomes) ){stop("count genomes?")}
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep")
  write.csv(checkm_sub, paste0("CheckM_drep",drep_val,".csv"), row.names=F)
  
  
}
