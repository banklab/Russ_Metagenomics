
library(data.table)


SNP_filter <- 20e3 


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/16_CMH/04_CMH")
cmh_list <- list.files(pattern="_CMH.csv")
snp_count <- as.numeric(gsub(".*_tests|.*snps|_CMH.csv","",cmh_list))

cmh_list2 <- cmh_list[snp_count>=SNP_filter]

for(i in 1:length(cmh_list2)){

cmh_df <- fread(cmh_list2[i], header=T, stringsAsFactors=F)
  
snp_count1 <- as.numeric(gsub(".*_tests|.*snps|_CMH.csv","",cmh_list2[i]))

cmh_df$tests <- snp_count1

cmh_df$Data <- "LR28SR70"

if(i==1){ cmh_df2 <- cmh_df } else { cmh_df2 <- rbind(cmh_df2,cmh_df) }
  
  }



