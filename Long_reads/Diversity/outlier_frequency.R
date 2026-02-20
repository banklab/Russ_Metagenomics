
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 28e3


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/CMH_4")
cmh_files <- list.files(pattern=paste0("_Env",EnvA,"xEnv",EnvB,"_snps")) ## all species
snp_count <- as.numeric(gsub(".*snps|_CMH.*|_LR.*","",cmh_files))
cmh_files2 <- cmh_files[snp_count>=SNP_filter]

cmh_files2 <- cmh_files2[!grepl("SR_",cmh_files2)]

species_here <- gsub("_Env.*","",cmh_files2)

for(i in 1:length(cmh_files2)){
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  snp_df <- data.frame(fread(list.files(pattern=paste0(species_here[i],"_Env")), header=T, stringsAsFactors = F))
  
  snp_df$Sample <- paste0(snp_df$Deer,"_",snp_df$Env)
  
  unique_sites <- unique(snp_df$Sp.ID)
 

