
library(data.table)

EnvA <- 8
EnvB <- 10


cmh_species <- c('Hy_Me_2_8_bin.181','Hy_Me_2_8_bin.89','Hy_Me_4_8_bin.143','Hy_Se_2_10_bin.105','Hy_Se_2_8_bin.23','Hy_Se_2_8_bin.24','Hy_Se_4_8_bin.39','Hy_Se_6_8_bin.0','Hy_Se_6_8_bin.55','Hy_Se_6_9_bin.30','LR_Me_4_8_bin.270','LR_Me_6_9_bin.102_sub','LR_Me_6_9_bin.166','LR_Se_2_10_bin.36','LR_Se_6_10_bin.83')

for(s in 1:length(cmh_species)){
    
  SPECIES1 <- cmh_species[s]
  
  cat("Species:",SPECIES1,"\n")
    
  
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

        outlier_snps$Window_position <- j
        
        
    if(j==1){ outlier_snps2 <- outlier_snps } else { outlier_snps2 <- rbind(outlier_snps2,outlier_snps) }
        
    }

    outlier_snps2$Window <- i
    outlier_snps2$OUTLIER <- FALSE
    outlier_snps2[outlier_snps2$format_scaffold==outlier_site$Scaffold & outlier_snps2$POS==outlier_site$POS,"OUTLIER"] <- TRUE

    outlier_snps2$logq <- NA
    outlier_snps2[outlier_snps2$format_scaffold==outlier_site$Scaffold & outlier_snps2$POS==outlier_site$POS,"logq"] <- outlier_site$logq

    if(i==1){ outlier_full <- outlier_snps2 } else { outlier_full <- rbind(outlier_full,outlier_snps2) }

    }

  
    filename <- paste0(SPECIES1,"_outlier_frequencies_DEER_v2.csv")
    
    setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
    write.csv(outlier_full, filename, row.names=F)
    
}
