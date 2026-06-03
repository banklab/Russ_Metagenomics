

library(data.table)


SNP_filter <- 28e3

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/16_CMH/04_CMH")
cmh_files <- list.files(pattern=".csv")
snp_count <- as.numeric(gsub(".*tests|.*snps|_CMH.*","",cmh_files))
cmh_files2 <- cmh_files[snp_count>=SNP_filter]

cmh_files2 <- cmh_files2[!grepl("SR_",cmh_files2)]


for(i in 1:length(cmh_files2)){

  cmh_df <- fread(cmh_files2[i], header=T, stringsAsFactors=F)

  species2 <- gsub("_Env.*", "", cmh_files2[i])

  EnvA <- as.numeric(gsub(".*_Env|xEnv.*", "", cmh_files2[i]))
  EnvB <- as.numeric(gsub(".*xEnv|_tests.*|_snps.*", "", cmh_files2[i]))

  num_test <- as.numeric(gsub(".*_tests|.*snps|_CMH.*", "", cmh_files2[i]))

  cmh_df$bin <- species2
  cmh_df$EnvA <- EnvA
  cmh_df$EnvB <- EnvB
  cmh_df$tests <- num_test


  if(i==1){ cmh_all <- cmh_df } else { cmh_all<- rbind(cmh_all,cmh_df) }

  }


cmh_all$contrast <- paste0(cmh_all$EnvA,"_x_",cmh_all$EnvB)
cmh_all$contrast.bin <- paste0(cmh_all$contrast,"_",cmh_all$bin)



write.csv(cmh_all, "CMH_environments.csv", row.names=F)




                              
