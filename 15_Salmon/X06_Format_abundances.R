

setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon/01_Abundance_Results")

abund_list <- list.files(pattern="csv")

for(i in 1:length(abund_list)){
  
  abund_raw <- read.csv(abund_list[i], header=T, stringsAsFactors = F)

  abund_raw$Sample <- gsub("deer_|_abund.*","",abund_list[i])

  abund_raw$Deer <- as.numeric(gsub("_.*","",abund_raw$Sample))

  abund_raw$Env <- as.numeric(gsub(".*_","",abund_raw$Sample))

  total_abundance <- sum(abund_raw$abundance)
  
  abund_raw$percent.abundance <- (abund_raw$abundance / total_abundance)*100
  
   
  
  if(sum(abund_raw$percent.abundance) < 99.99){message("ERROR");break}
  
  if(i==1){ abund_total <- abund_raw } else { abund_total <- rbind(abund_total, abund_raw) }
  
}

table(tapply(abund_total$percent.abundance, abund_total$Sample, sum))

table(tapply(abund_total$bin, abund_total$Sample, length))



setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
write.csv(abund_total, "DEER_Abundance.csv", row.names = F)
