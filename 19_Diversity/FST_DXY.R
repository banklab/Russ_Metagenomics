
library(hierfstat)
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 20e3


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Filtered_Sites")
snp_files <- list.files(pattern=paste0("_Env",EnvA,"xEnv",EnvB,"_Filter_snps"))
snp_count <- as.numeric(gsub(".*snps|\\.csv.*","",snp_files))
snp_files2 <- snp_files[snp_count>=SNP_filter]

snp_files2 <- snp_files2[1]

for(i in 1:length(snp_files2)){
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Filtered_Sites")
  snp_df <- data.frame(fread(snp_files2[i], header=T, stringsAsFactors = F))
  
  snp_df$Sample <- paste0(snp_df$Deer,"_",snp_df$Env)
  
  unique_sites <- unique(snp_df$Sp.ID)
  
  for(j in 1:length(unique_sites)){
    
    sites_df <- snp_df[snp_df$Sp.ID == unique_sites[j],]
    
    deer_comparisons <- choose( dim(sites_df)[1], 2 )
    
    result <- data.frame(array(NA, dim = c(deer_comparisons,10), dimnames = list(c(),c("Scaffold","POS","DeerA","EnvA","DeerB","EnvB","Fst","Ht","Hs","Dxy"))))
    result[,"Scaffold"] <- unique(sites_df$Scaffold)
    result[,"POS"] <- unique(sites_df$POS)
    
    dd <- 1
    
    for(site1 in 1:dim(sites_df)[1]){
    for(site2 in 1:dim(sites_df)[1]){
        
      if(site1 >= site2){next}
      
      line1 <- sites_df[site1,]
      line2 <- sites_df[site2,]
      
      env1_A <- array(1, dim = c(sum(line1[,c("A")]),2), dimnames = list(c(),c("Pop","Locus")))
      env1_C <- array(2, dim = c(sum(line1[,c("C")]),2), dimnames = list(c(),c("Pop","Locus")))
      env1_G <- array(3, dim = c(sum(line1[,c("G")]),2), dimnames = list(c(),c("Pop","Locus")))
      env1_T <- array(4, dim = c(sum(line1[,c("T")]),2), dimnames = list(c(),c("Pop","Locus")))
      
      env2_A <- array(1, dim = c(sum(line2[,c("A")]),2), dimnames = list(c(),c("Pop","Locus")))
      env2_C <- array(2, dim = c(sum(line2[,c("C")]),2), dimnames = list(c(),c("Pop","Locus")))
      env2_G <- array(3, dim = c(sum(line2[,c("G")]),2), dimnames = list(c(),c("Pop","Locus")))
      env2_T <- array(4, dim = c(sum(line2[,c("T")]),2), dimnames = list(c(),c("Pop","Locus")))
      
      env1_recode <- data.frame(rbind(env1_A, env1_C, env1_G, env1_T))
      env2_recode <- data.frame(rbind(env2_A, env2_C, env2_G, env2_T))
      
      env1_recode[,"Pop"] <- line1$Sample
      env2_recode[,"Pop"] <- line2$Sample
      
      full_data <- rbind(env1_recode, env2_recode)
      
      full_data$Pop <- factor(full_data$Pop)
      
      basic_stats <- basic.stats(full_data, diploid = F)
      
      result[dd,"DeerA"] <- line1[,"Deer"]
      result[dd,"EnvA"] <- line1[,"Env"]
      result[dd,"DeerB"] <- line2[,"Deer"]
      result[dd,"EnvB"] <- line2[,"Env"]
      result[dd,"Fst"] <- basic_stats$overall["Fst"]
      result[dd,"Ht"] <- basic_stats$overall["Ht"]
      result[dd,"Hs"] <- basic_stats$overall["Hs"]
      

      p1 <- sum(env1_recode==1) / dim(env1_recode)[1]
      q1 <- sum(env1_recode==2) / dim(env1_recode)[1]
      r1 <- sum(env1_recode==3) / dim(env1_recode)[1]
      s1 <- sum(env1_recode==4) / dim(env1_recode)[1]
      
      p2 <- sum(env2_recode==1) / dim(env2_recode)[1]
      q2 <- sum(env2_recode==2) / dim(env2_recode)[1]
      r2 <- sum(env2_recode==3) / dim(env2_recode)[1]
      s2 <- sum(env2_recode==4) / dim(env2_recode)[1]
      
      DXY <- p1*q2 + p1*r2 + p1*s2 + q1*r2 + q1*s2 + r1*s2 + p2*q1 + p2*r1 + p2*s1 + q2*r1 + q2*s1 + r2*s1
      
      result[dd,"Dxy"] <- DXY
      
      dd <- dd + 1
      
    } ## 1
    } ## 2
    
    if(j==1){result2 <- result} else { result2 <- rbind(result2, result) }
    
    
  } ## sites

  filename2 <- gsub("_Filter.*","_FST_DXY.csv",snp_files2[i])
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity/01_FST")
  write.csv(result2, filename2, row.names = F)
    
} ## species

