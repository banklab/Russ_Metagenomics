
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 28e3

q_min_thresh <- 0.10

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/CMH_4")
cmh_files <- list.files(pattern=paste0("_Env",EnvA,"xEnv",EnvB,"_snps")) ## all species
snp_count <- as.numeric(gsub(".*snps|_CMH.*|_LR.*","",cmh_files))
cmh_files2 <- cmh_files[snp_count>=SNP_filter]

cmh_files2 <- cmh_files2[!grepl("SR_",cmh_files2)]

species_here <- gsub("_Env.*","",cmh_files2)


for(s in 1:length(cmh_files2)){
    
  SPECIES1 <- gsub("_Env.*","",cmh_files2[s])
  
  cat("Species:",SPECIES1,"\n")
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/CMH_4")
  cmh_data <- data.frame(fread(cmh_files2[s], header=T, stringsAsFactors = F))
  
  
  ## remove phage :(
  ######################################################################################################
  if(SPECIES1=="Hy_Se_6_10_bin.170"){
    cmh_data <- cmh_data[cmh_data$Scaffold != "s6381.ctg006388l_asm_hybrid_semibin_6_10_bin.170", ]
  }
  ######################################################################################################
  
  
  cmh_data$Scaffold <- gsub("_asm.*", "", cmh_data$Scaffold)
  
  cmh_data2 <- cmh_data[!is.na(cmh_data$pvalue),]
  
  cmh_data2$bin <- SPECIES1
  
  snp_count <- sum(!is.na(cmh_data2$pvalue))
  
  cmh_data2$qvalue <- p.adjust(cmh_data2$pvalue, method = "BH")
  
  cmh_data2$logq <- -log10(cmh_data2$qvalue)
  
  ## new outlier method
  cmh_data2$OUTLIER <- cmh_data2$qvalue <= q_min_thresh
  
  
  if(sum(cmh_data2$OUTLIER)<1){next}

  cmh_outs <- cmh_data2[cmh_data2$OUTLIER,]


  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  snp_df <- data.frame(fread(list.files(pattern=paste0(SPECIES1,"_Env")), header=T, stringsAsFactors = F))
 
  snp_df$format_scaffold <- gsub("_asm_.*","",snp_df$Scaffold)
  
  for(i in 1:sum(cmh_data2$OUTLIER)){

    outlier_site <- cmh_outs[i,]
    
    snp_df[snp_df$format_scaffold==outlier_site$Scaffold & snp_df$POS==outlier_site$POS,]


    
    }


  
}



