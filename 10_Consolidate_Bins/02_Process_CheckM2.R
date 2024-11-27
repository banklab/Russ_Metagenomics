## just renaming columns from CheckM2 output and copying them to 02_Stats directory


setwd("/storage/scratch/users/rj23k073/04_DEER/09_CheckM")

checkm_dirs <- list.files(pattern="^0")

for(i in 1:length(checkm_dirs)){

  setwd(paste0("/storage/scratch/users/rj23k073/04_DEER/09_CheckM/",checkm_dirs[i]))
  
  checkm_files <- list.files(pattern="_checkm2$")
  
  if(length(checkm_files)!=70){message("ERROR");break}
  
  for(j in 1:length(checkm_files)){
  
    setwd(paste0("/storage/scratch/users/rj23k073/04_DEER/09_CheckM/",checkm_dirs[i],"/",checkm_files[j]))
    
    checkm_data <- read.table("quality_report.tsv", header=T, stringsAsFactors = F, sep="\t")
    
    colnames(checkm_data)[1:3] <- c("bin","completeness","contamination") ## rename columns
    
    colnames(checkm_data)[9:10] <- c("size","GC") ## rename columns
    
    checkm_data$binner <- gsub(".*_","",checkm_dirs[i])

    write.table(checkm_data, paste0(gsub("checkm2","",checkm_files[j]), gsub(".*_","",checkm_dirs[i]), "_stats.txt"), row.names = F, sep="\t", quote = F) ## copy them to stats dir
    
    setwd("/storage/scratch/users/rj23k073/04_DEER/10_Consolidate_Bins/02_Stats")
    write.table(checkm_data, paste0(gsub("checkm2|concoct_","",checkm_files[j]), gsub(".*_","",checkm_dirs[i]), "_stats.txt"), row.names = F, sep="\t", quote = F)
    
  }
}
