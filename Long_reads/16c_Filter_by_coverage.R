
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 20e3 ## only using species with at least x number of USEABLE snps (snps that can go into cmh test)


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
snp_list <- list.files(pattern=(paste0("_Env",EnvA,"xEnv",EnvB,"_Filter_snps")))
snp_count <- as.numeric(gsub(".*snps|\\.csv","",snp_list))
snp_list2 <- snp_list[snp_list>=SNP_filter]


for(i in 1:length(snp_list2)){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
  snp_df <- data.frame(fread(snp_list2[i],header=T, stringsAsFactors=F))

  species2 <- gsub("_Env.*","",snp_list2[i])

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/mosdepth/BED")

  


  

  }

