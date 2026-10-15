

library(data.table)
res <- data.frame(array(NA, dim = c(1,9)))

pi_w.function <- function(one.site){ ## calculate pi per locus
  
  alleles <- as.numeric(one.site[c("A","C","G","T")])
  
  allele.words <- names(one.site[c("A","C","G","T")][order(as.numeric(one.site[c("A","C","G","T")]),decreasing=T)])
  
  major.llele <- sort(alleles, decreasing = T)[1]
  minor.llele <- sort(alleles, decreasing = T)[2]
  
  ## multiallelic check
  if(sum(alleles>0)<=2){ ## pi for biallelic loci
    
    allele.pop.size <- sum(as.numeric(major.llele),as.numeric(minor.llele))
    
    p <- as.numeric(major.llele) / allele.pop.size
    q <- as.numeric(minor.llele) / allele.pop.size
    
    pairwise.diff <- p * q * allele.pop.size^2
    
    pi_w <- ( pairwise.diff / (choose(allele.pop.size,2)) )
    
  } else { ## MULTIALLELIC
    
    minor2.llele <- sort(alleles, decreasing = T)[3]
    
    if(sum(alleles>0)<4){ ## 3 alleles
      
      allele.pop.size3 <- sum(as.numeric(major.llele),as.numeric(minor.llele),as.numeric(minor2.llele))
      
      p <- as.numeric(major.llele) / allele.pop.size3
      q <- as.numeric(minor.llele) / allele.pop.size3
      r <- as.numeric(minor2.llele) / allele.pop.size3
      
      pairwise.diff2 <- ( p*q + p*r + q*r ) * allele.pop.size3^2
      
      pi_w <- ( pairwise.diff2 / (choose(allele.pop.size3,2)) )
      
      res[,6] <- allele.words[3]
      res[,7] <- r
      
    } else { ## 4 alleles
      
      minor3.llele <- sort(alleles, decreasing = T)[4]
      
      allele.pop.size4 <- sum(as.numeric(major.llele),as.numeric(minor.llele),as.numeric(minor2.llele),as.numeric(minor3.llele))
      
      p <- as.numeric(major.llele) / allele.pop.size4
      q <- as.numeric(minor.llele) / allele.pop.size4
      r <- as.numeric(minor2.llele) / allele.pop.size4
      s <- as.numeric(minor3.llele) / allele.pop.size4
      
      pairwise.diff3 <- ( p*q + p*r + p*s + q*r + q*s + r*s ) * allele.pop.size4^2
      
      pi_w <- ( pairwise.diff3 / (choose(allele.pop.size4,2)) )
      
      res[,6] <- allele.words[3]
      res[,7] <- r
      res[,8] <- allele.words[4]
      res[,9] <- s
      
    }
    
  } ## multiallelic
  
   res[,1] <- pi_w
  res[,2] <- allele.words[1]
  res[,3] <- p
  res[,4] <- allele.words[2]
  res[,5] <- q
  
  return(res)
  
}


instrain_files <- list.files(pattern="_InStrain_SNVs.tsv")


for(i in 1:length(instrain_files)){

SAMPLE <- gsub("_LR.*|_SR.*","",instrain_files[i])
DEER <- as.numeric(gsub("_.*","",SAMPLE))
 ENV <- as.numeric(gsub(".*_","",SAMPLE))
 
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/RAW")
  snv_file <- data.frame(fread(paste0(DEER,"_",ENV,"_LR28_InStrain_SNVs.tsv"), header=T, stringsAsFactors = F))
   
  snv_file$bin <- gsub(".*asm_","",snv_file$scaffold) 

  snv_file$Method <- "LR28"

  snv_file$bin <- paste0(snv_file$Method,"_",snv_file$bin)
  
  if(sum(grep("scaffold",snv_file$bin))>0){stop("ERROR")}
  
  snv_file$Deer <- DEER 
  
  snv_file$Env <- ENV 
  
  snv_file$Scaffold <- gsub(".*NODE_|_length_.*","",snv_file$scaffold) 
  
  snv_file$POS <- snv_file$position 
  
  snv_file$DP <- snv_file$position_coverage 

  colnames(snv_file)[1] <- "scaffold2"
  
  snv_file2 <- snv_file[,c(20,22:26,4:19,1,21)] ### CHECK ##################

  snv_file2$ID <- paste0(snv_file2$Scaffold,"_",snv_file2$POS) 

  snv_file2$Sp.ID <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS) 

  snv_file2$Sp.ID.deer <- paste0(snv_file2$bin,"_sc",snv_file2$Scaffold,"_pos",snv_file2$POS,"_d",snv_file2$Deer) 

  snv_file2$Original <- TRUE 
  
 pi_and_freqs <- lapply(seq_len(nrow(snv_file2)), function(k) {
  pi_w.function(snv_file2[k, ])
}) 
pi_and_freqs2 <- as.data.frame(do.call(rbind, pi_and_freqs))

colnames(pi_and_freqs2) <- c("pi","Maj.allele","Maj.freq","Min1.allele","Min1.freq","Min2.allele","Min2.freq","Min3.allele","Min3.freq")

snv_file3 <- cbind(snv_file2, pi_and_freqs2)

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/METHODS")
  write.csv(snv_file3, paste0(DEER,"_",ENV,"_LR28_InStrain_SNVs_methods.csv"), row.names = F)

  cat(i,"\n")
  
}


### FIX ###
#  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/FORMAT")
#for(ENV in c(1:6,8:10)){
#for(DEER in c(2,4,6,7){

 # snv_file3 <- data.frame(fread(paste0(DEER,"_",ENV,"_LR28_InStrain_SNVs_format.csv"), header=T, stringsAsFactors = F))

  #if(DEER==1){full_df <- snv_file3} else {full_df <- rbind(full_df, snv_file3)}

  #if(length(unique(full_df$ENV))>1){stop("ERROR")}
  
  #}
 # write.csv(full_df, paste0("ENV",ENV,"_LR28_SNPS.csv"), row.names = F)

#}
  
