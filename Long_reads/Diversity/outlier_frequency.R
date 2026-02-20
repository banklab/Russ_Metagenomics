
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 28e3


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
snp_files <- list.files(pattern=paste0("_Env",EnvA,"xEnv",EnvB,"_Coverage_Filter_snps")) ## all species
snp_count <- as.numeric(gsub(".*snps|\\.csv.*","",snp_files))
snp_files2 <- snp_files[snp_count>=SNP_filter] ## just top species

snp_files2 <- snp_files2[!grepl("SR_",snp_files2)]


