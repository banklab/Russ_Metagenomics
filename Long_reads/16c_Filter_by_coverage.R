
library(data.table)


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
snp_list <- list.files(pattern=(paste0("_Env",EnvA,"xEnv",EnvB,"_Filter_snps")))

for(i in 1:length(snp_list)){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
  snp_df <- data.frame(fread(snp_list[i],header=T, stringsAsFactors=F))

  species2 <- gsub("_Env.*","",snp_list[i])

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/mosdepth")


  }

