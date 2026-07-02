
library(data.table)


SNP_filter <- 20e3 


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/16_CMH/04_CMH")
cmh_list <- list.files(pattern="_CMH.csv")
snp_count <- as.numeric(gsub(".*_tests|.*snps|_CMH.csv","",cmh_list))

cmh_list2 <- cmh_list[snp_count>=SNP_filter]

for(i in 1:length(cmh_list2)){

cmh_df <- fread(cmh_list2[i], header=T, stringsAsFactors=F)

envA <- as.numeric(gsub(".*_Env|xEnv.*","",cmh_list2[i]))
  envB <- as.numeric(gsub(".*xEnv|_tests.*","",cmh_list2[i]))

cmh_df$EnvA <- envA
  cmh_df$EnvB <- envB

  
cmh_df$bin <- gsub("_Env.*","",cmh_list2[i])
  
snp_count1 <- as.numeric(gsub(".*_tests|.*snps|_CMH.csv","",cmh_list2[i]))

cmh_df$tests <- snp_count1

cmh_df$Data <- "LR28SR70"

if(i==1){ cmh_df2 <- cmh_df } else { cmh_df2 <- rbind(cmh_df2,cmh_df) }
  
  }



setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/03_CMH_on_SR_alignments/04_CMH")
cmhA_list <- list.files(pattern="_CMH.csv")
snp_count <- as.numeric(gsub(".*_tests|.*snps|_LR28_CMH.csv","",cmhA_list))

cmhA_list2 <- cmhA_list[snp_count>=SNP_filter]

for(i in 1:length(cmhA_list2)){

cmhA_df <- fread(cmhA_list2[i], header=T, stringsAsFactors=F)

  envAA <- as.numeric(gsub(".*_Env|xEnv.*","",cmhA_list2[i]))
  envBB <- as.numeric(gsub(".*xEnv|_tests.*","",cmhA_list2[i]))

cmhA_df$EnvA <- envAA
  cmhA_df$EnvB <- envBB

  
cmhA_df$bin <- gsub("_Env.*","",cmhA_list2[i])

snp_count11 <- as.numeric(gsub(".*_tests|.*snps|_LR28_CMH.csv","",cmhA_list2[i]))

cmhA_df$tests <- snp_count11

cmhA_df$Data <- "LR28"

if(i==1){ cmhA_df2 <- cmhA_df } else { cmhA_df2 <- rbind(cmhA_df2,cmhA_df) }
  
  }




setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/SR70/01_CMH/07_CMH")
cmhB_list <- list.files(pattern="_CMH.csv")
snp_count <- as.numeric(gsub(".*_tests|.*snps|_SR70_CMH.csv","",cmhB_list))

cmhB_list2 <- cmhB_list[snp_count>=SNP_filter]

for(i in 1:length(cmhB_list2)){

cmhB_df <- fread(cmhB_list2[i], header=T, stringsAsFactors=F)

    envAAA <- as.numeric(gsub(".*_Env|xEnv.*","",cmhB_list2[i]))
  envBBB <- as.numeric(gsub(".*xEnv|_tests.*","",cmhB_list2[i]))

cmhB_df$EnvA <- envAAA
  cmhB_df$EnvB <- envBBB


  cmhB_df$bin <- gsub("_Env.*","",cmhB_list2[i])

snp_count111 <- as.numeric(gsub(".*_tests|.*snps|__SR70_CMH.csv","",cmhB_list2[i]))

cmhB_df$tests <- snp_count111

cmhB_df$Data <- "SR70"

if(i==1){ cmhB_df2 <- cmhB_df } else { cmhB_df2 <- rbind(cmhB_df2,cmhB_df) }
  
  }



setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/12_CMH/04_CMH")
cmhC_list <- list.files(pattern="_CMH.csv")
snp_count <- as.numeric(gsub(".*_tests|.*snps|_SR28_CMH.csv","",cmhC_list))

cmhC_list2 <- cmhC_list[snp_count>=SNP_filter]

for(i in 1:length(cmhC_list2)){

cmhC_df <- fread(cmhC_list2[i], header=T, stringsAsFactors=F)

  
    envAAAA <- as.numeric(gsub(".*_Env|xEnv.*","",cmhC_list2[i]))
  envBBBB <- as.numeric(gsub(".*xEnv|_tests.*","",cmhC_list2[i]))

cmhC_df$EnvA <- envAAAA
  cmhC_df$EnvB <- envBBBB



  
    cmhC_df$bin <- gsub("_Env.*","",cmhC_list2[i])

snp_count1111 <- as.numeric(gsub(".*_tests|.*snps|_SR28_CMH.csv","",cmhC_list2[i]))

cmhC_df$tests <- snp_count1111

cmhC_df$Data <- "SR28"

if(i==1){ cmhC_df2 <- cmhC_df } else { cmhC_df2 <- rbind(cmhC_df2,cmhC_df) }
  
  }




