
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep")

checkm_SR <- read.csv("raw_Short_read_bins_CheckM2.csv", header=T, stringsAsFactors=F)
checkm_LR <- read.csv("genomeInformation_long_read_bins_and_hybrid_bins.csv", header=T, stringsAsFactors=F)

checkm <- rbind(checkm_SR, checkm_LR)

#checkm$bin <- gsub("\\.fa","",checkm$genome)


## list of drep directories
drep_list <- c(list.files(pattern="04_8"),list.files(pattern="04_9"))


for(i in 1:length(drep_list)){

  setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/",drep_list[i]))

  genomes <- list.files(pattern="fa")

  checkm_subset <- checkm[checkm$genome %in% genomes,]

  if( dim(checkm_subset)[1] != length(genomes) ){stop("checkm has different number of genomes?")}


  filename2 <- paste0("CheckM_step2_drep",drep_rate,".csv")

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep")

  write.csv(checkm_subset, filename2)

  }



  
