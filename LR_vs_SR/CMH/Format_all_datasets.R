
library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/16_CMH/04_CMH")
SNP_filter <- 20e3 

setwd("//data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/12_CMH/03_Filtered_by_Coverage")
cmh_list <- list.files(pattern="_Coverage_Filter_snps")
snp_count <- as.numeric(gsub(".*snps|\\.csv","",cmh_list))

cmh_list2 <- cmh_list[snp_count>=SNP_filter]

