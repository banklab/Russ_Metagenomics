
setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/fastANI/RAW")

fastani_list <- list.files(pattern="txt")

fastani_list <- fastani_list[grepl("query",fastani_list)]

for(i in 1:length(fastani_list)){
  
  setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/fastANI/RAW")
  aa <- read.table(fastani_list[i], header=F, stringsAsFactors = F)
  
  aa$Query.Source <- gsub("query_|_subject_.*","",fastani_list[i])
  
  aa$Query <- gsub(".*dereplicated_genomes/|.*99_short_read_bins/|\\.fa","",aa$V1)
  
  aa$Subject.Source <- gsub(".*_subject_|\\.txt","",fastani_list[i])
  
  aa$Subject <- gsub(".*dereplicated_genomes/|.*99_short_read_bins/|\\.fa","",aa$V2)
  
  aa$ANI <- aa$V3
  
  aa$Coverage <- aa$V4 / aa$V5
  
  aa[,1:5] <- NULL
  
  
  setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/fastANI")
  write.csv(aa, gsub("\\.txt","_format.csv",fastani_list[i]), row.names = F)
  
}
