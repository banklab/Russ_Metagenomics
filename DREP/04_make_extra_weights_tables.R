
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep")


## list of drep directories
drep_list <- c(list.files(pattern="04_8"),list.files(pattern="04_9"))


for(i in 1:length(drep_list)){

  setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/",drep_list[i]))

  drep_rate <- gsub("04_|_input.*","",drep_list[i])
  
  all_bins <- list.files(pattern="fa")

  if( sum(grepl("deer",all_bins)) < 800 ){stop("how many SR bins?")}
  if( sum(grepl("deer",all_bins)) > 1050 ){stop("how many SR bins 2?")}
  if( sum(!grepl("deer",all_bins)) <10 ){stop("how many LR bins?")}

  SR_bins <- all_bins[grepl("deer",all_bins)]
  LR_bins <- all_bins[!grepl("deer",all_bins)]
 
  SR_df <- data.frame(array(0, dim=c(length(SR_bins),2)))
  LR_df <- data.frame(array(100, dim=c(length(LR_bins),2)))

  SR_df[,1] <- SR_bins
  LR_df[,1] <- LR_bins

  extra_weight_df <- rbind(LR_df, SR_df)
  
  if( sum(extra_weight_df[,2])/100 != length(LR_bins) ){stop("weight wrong?")}

  filename2 <- paste0("Extra_Weight_Table_drep",drep_rate,".txt")

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep")

  write.table(extra_weight_df, filename2, quote=F, col.names=F, row.names=F, sep="\t")
  
  }
