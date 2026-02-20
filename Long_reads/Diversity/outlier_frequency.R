
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
  
  
  if(sum(cmh_data2$OUTLIER)<1){message("no outs\n");next}
 
  cmh_outs <- cmh_data2[cmh_data2$OUTLIER,]


  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  snp_df <- data.frame(fread(list.files(pattern=paste0(SPECIES1,"_Env")), header=T, stringsAsFactors = F))
 
  snp_df$format_scaffold <- gsub("_asm_.*","",snp_df$Scaffold)
  
  for(i in 1:sum(cmh_data2$OUTLIER)){

    outlier_site <- cmh_outs[i,]

    ## find flanking snps
    outlier_scaffold <- snp_df[snp_df$format_scaffold==outlier_site$Scaffold,]
    positions <- unique(outlier_scaffold$POS)
    outlier_index <- which(positions==outlier_site$POS)

    flanking_positions <-  positions[c(outlier_index-4):c(outlier_index+4)]

    for(j in 1:length(flanking_positions)){

        outlier_snps <- outlier_scaffold[outlier_scaffold$POS==flanking_positions[j],]
        
        alleles <- outlier_snps[,c("A","C","G","T")]
          
        alleles2 <- names(alleles)[order(colSums(alleles), decreasing=T)]
      
        major.llele <- alleles2[1]
        minor.llele <- alleles2[2]
        #minor.llele2 <- alleles2[3]
        #minor.llele3 <- alleles2[4]
    
        outlier_snps$Major.Freq <- outlier_snps[,major.llele] / outlier_snps$DP
        outlier_snps$Minor.Freq <- outlier_snps[,minor.llele] / outlier_snps$DP
        outlier_snps$Major.Allele <- major.llele
        outlier_snps$Minor.Allele <- minor.llele

    if(j==1){ outlier_snps2 <- outlier_snps } else { outlier_snps2 <- rbind(outlier_snps2,outlier_snps) }
        
    }

    outlier_snps2$OUTLIER <- FALSE
    outlier_snps2[outlier_snps2$format_scaffold==outlier_site$Scaffold & outlier_snps2$POS==outlier_site$POS,"OUTLIER"] <- TRUE

    outlier_snps2$logq <- NA
    outlier_snps2[outlier_snps2$format_scaffold==outlier_site$Scaffold & outlier_snps2$POS==outlier_site$POS,"logq"] <- outlier_site$logq
      
    }

    if(i==1){ outlier_full <- outlier_snps2 } else { outlier_full <- rbind(outlier_full,outlier_snps2) }

    filename <- paste0(SPECIES1,"_outlier_frequencies_DEER_v2.csv")
    
    setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
    write.csv(outlier_full, filename, row.names=F)
    
}



