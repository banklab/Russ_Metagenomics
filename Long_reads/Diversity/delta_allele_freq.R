
library(data.table)


delta.function <- function(one.site){ 

    snps <- snp_df[snp_df$ID==one.site,]

    ## snps with only 1 environment
    if(length(unique(snps$Env))<2){return(NULL)}

    counts <- colSums(snps[,c("A","C","G","T")], na.rm=T)

    alleles <- sort(counts, decreasing=T)
    
    order.data <- snps[,c("Deer","Env","DP",names(alleles))]

    order.data[,names(alleles)] <- order.data[,names(alleles)] / order.data[,"DP"]

    colnames(order.data)[4:7]<- c("Major.freq","Minor.freq","Minor2","Minor3")

    wide.data <- reshape(order.data[order.data$Env %in% c(8,10), ],
                idvar = "Deer",
                timevar = "Env",
                direction = "wide")

    num.alleles <- sum(alleles>0)
    wide.data$num.alleles <- num.alleles
    
    wide.data$Major.Diff <- wide.data$Major.freq.10 - wide.data$Major.freq.8
    wide.data$Minor.Diff <- wide.data$Minor.freq.10 - wide.data$Minor.freq.8

    wide.data$Minor2.Diff <- NA
    wide.data$Minor3.Diff <- NA
    
    if(num.alleles>2){ ## at least 3 alleles
        wide.data$Minor2.Diff <- wide.data$Minor2.10 - wide.data$Minor2.8
        if(num.alleles>3){ ## all 4 alleles
            wide.data$Minor3.Diff <- wide.data$Minor3.10 - wide.data$Minor3.8
        }
    }
  
    wide.data$ID <- one.site

    return(wide.data)
}


# Env hardcoded actually
#EnvA <- 8
#EnvB <- 10


cmh_species <- c('Hy_Me_2_8_bin.181','Hy_Me_2_8_bin.89','Hy_Me_4_8_bin.143','Hy_Se_2_10_bin.105','Hy_Se_2_8_bin.23','Hy_Se_2_8_bin.24','Hy_Se_4_8_bin.39','Hy_Se_6_8_bin.0','Hy_Se_6_8_bin.55','Hy_Se_6_9_bin.30','LR_Me_4_8_bin.270','LR_Me_6_9_bin.102_sub','LR_Me_6_9_bin.166','LR_Se_2_10_bin.36','LR_Se_6_10_bin.83')

for(s in 1:length(cmh_species)){
    
  SPECIES1 <- cmh_species[s]
  
  cat("Species:",SPECIES1,"\n")
    
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  snp_df <- data.frame(fread(list.files(pattern=paste0(SPECIES1,"_Env")), header=T, stringsAsFactors = F))
 
  snp_df$format_scaffold <- gsub("_asm_.*","",snp_df$Scaffold)


  delta_list <- lapply(unique(snp_df$ID), FUN=delta.function)
  delta_results <- as.data.frame(do.call(rbind, delta_list))
  rownames(delta_results) <- NULL

  delta_results$Mean.DP <- rowMeans(delta_results[,c("DP.8","DP.10")], na.rm=T)

  filename2 <- paste0(SPECIES1,"_delta.csv")

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity/DELTA")
  write.csv(delta_results, filename2, row.names=F)

}

    
