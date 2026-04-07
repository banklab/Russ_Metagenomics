library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/05_drep/02_CheckM2")
checkm <- data.frame(fread("quality_report.tsv", header=T, stringsAsFactors = F))
  
colnames(checkm)[1:3] <- c("genome","completeness","contamination")
  
checkm$genome <- paste0(checkm$genome,".fa")

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/05_drep")
write.csv(checkm, "genomeInformation.csv", row.names=F)
