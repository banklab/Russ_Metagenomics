
## keep sites above/equal to this depth
DP_threshold <- 5
## keep sites above/equal to this REF freq
AF_threshold <- 0.95

## Environment with Sites Called
Good_Env <- 8
## Environment with Missing Sites
Miss_Env <- 10




library(data.table)

missing.pop.function <- function(one_snp){
  
  Good_DF <- one_deer_called_in_good_but_not_miss_df[one_deer_called_in_good_but_not_miss_df$Sp.ID.deer==one_snp["Sp.ID.deer"],]
  
  Ref.base.var <- Good_DF$ref_base
  
  allele_table[1,"A"] <- as.numeric(Good_DF$A)
  allele_table[1,"C"] <- as.numeric(Good_DF$C)
  allele_table[1,"G"] <- as.numeric(Good_DF$G)
  allele_table[1,"T"] <- as.numeric(Good_DF[,"T"])
  allele_table[1,"DP"] <- as.numeric(Good_DF$DP)
  allele_table[1,"Ref.Base"] <- Ref.base.var
  allele_table[1,"Ref.Freq"] <- as.numeric(Good_DF$ref_freq)
  
  allele_table[2,"A"] <- as.numeric(one_snp["A"])
  allele_table[2,"C"] <- as.numeric(one_snp["C"])
  allele_table[2,"G"] <- as.numeric(one_snp["G"])
  allele_table[2,"T"] <- as.numeric(one_snp["T"])
  allele_table[2,"DP"] <- as.numeric(one_snp["DP"])
  allele_table[2,"Ref.Base"] <- one_snp["ref_base"]
  allele_table[2,"Ref.Freq"] <- as.numeric(one_snp["ref_freq"])
  
  
  
  allele_table[3,1:5] <- allele_table[2,1:5]-allele_table[1,1:5]
  
  if(length(unique(allele_table[1:2,6]))>1){message("ERROR");break}
  
  allele_table[3,"Ref.Base"] <- unique(allele_table[1:2,6])
  
  if(Ref.base.var!="N"){
    allele_table[3,"Ref.Freq"] <- allele_table[3,Ref.base.var] / allele_table[3,"DP"]
  }
  
  pop1 <- allele_table[1,]
  both <- allele_table[2,]
  miss <- allele_table[3,]
  
  colnames(pop1) <- paste0(colnames(pop1),".P1")
  colnames(both) <- paste0(colnames(both),".Both")
  colnames(miss) <- paste0(colnames(miss),".Miss")
  
  fin.allele.tab <- cbind(pop1, both, miss)
  
  rownames(fin.allele.tab) <- NULL
  
  fin.allele.tab$Species <- one_snp["Species"]
  fin.allele.tab$Sp.ID.deer <- one_snp["Sp.ID.deer"]
  
  
  calc_missing_Site$DP <- fin.allele.tab$DP.Miss
  calc_missing_Site$allele_count <-  sum(fin.allele.tab[,c("A.Miss","C.Miss","G.Miss","T.Miss")]>0, na.rm=T)
  calc_missing_Site$ref_base <- Ref.base.var
  calc_missing_Site$ref_freq <- fin.allele.tab$Ref.Freq.Miss
  calc_missing_Site$A <- fin.allele.tab$A.Miss
  calc_missing_Site$C <- fin.allele.tab$C.Miss
  calc_missing_Site$G <- fin.allele.tab$G.Miss
  calc_missing_Site[,"T"] <- fin.allele.tab$T.Miss
  
  
  calc_missing_Site$Species <- one_snp["Species"]
  calc_missing_Site$Deer <- one_snp["Deer"]
  calc_missing_Site$Env <- Miss_Env
  calc_missing_Site$Scaffold <- one_snp["Scaffold"]
  calc_missing_Site$POS <- one_snp["POS"]
  calc_missing_Site$gene <- one_snp["gene"]
  calc_missing_Site$mutation_type <- one_snp["mutation_type"]
  calc_missing_Site$class <- one_snp["class"]
  calc_missing_Site$scaffold2 <- one_snp["scaffold2"]
  calc_missing_Site$ID <- one_snp["ID"]
  calc_missing_Site$Sp.ID <- one_snp["Sp.ID"]
  calc_missing_Site$Sp.ID.deer <- one_snp["Sp.ID.deer"]
  calc_missing_Site$Original <- FALSE
  
  return(calc_missing_Site)
}


    
    setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/03_Formatted_Results")
    
    GOOD_DF <- data.frame(fread(paste0("ENV",Good_Env,"_SNPS.csv"), header=T, stringsAsFactors = F))
    MISS_DF <- data.frame(fread(paste0("ENV",Miss_Env,"_SNPS.csv"), header=T, stringsAsFactors = F))
    
    if(length(unique(GOOD_DF$Env))>1){message("error1");break}
    if(length(unique(MISS_DF$Env))>1){message("error2");break}
    
    
    setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/02_Two_Populations/FORMAT")
    
    pool_name <- c(list.files(pattern=paste0("Pooled_Env",Good_Env,"_Env",Miss_Env,"_snps.csv")),list.files(pattern=paste0("Pooled_Env",Miss_Env,"_Env",Good_Env,"_snps.csv")))
    
    pooled <- data.frame(fread(pool_name, header=T, stringsAsFactors = F))
    
    if(length(unique(pooled$Env))>1){message("error3");break}
    
    #pooled$Sp.ID.deer <- paste0(pooled$Sp.ID,"_d",pooled$Deer)
    
 if(length(pooled$Sp.ID.deer)<1){message("error4");break}
    
    
    called_in_good_but_not_miss_df <- GOOD_DF[!GOOD_DF$Sp.ID.deer %in% MISS_DF$Sp.ID.deer,]
    
    
    ## polymorphic in GOOD but NO call in MISS
    pooled_missing_sites <- pooled[pooled$Sp.ID.deer %in% called_in_good_but_not_miss_df$Sp.ID.deer,]
    
    
    ## test depth of POOLED vs GOOD data - is there enough depth for a site in MISS data?
    merged_df <- merge(pooled_missing_sites[,c("DP","Sp.ID.deer")], called_in_good_but_not_miss_df[,c("DP","Sp.ID.deer")], by="Sp.ID.deer")
    
    merged_df$miss.dp <- merged_df$DP.x - merged_df$DP.y
    
    pass_DP_filter <- merged_df[merged_df$miss.dp >=DP_threshold,]
    
    pooled_missing_sites_pass_DP <- pooled_missing_sites[pooled_missing_sites$Sp.ID.deer %in% pass_DP_filter$Sp.ID.deer, ]
    
    
    allele_table <- data.frame(array(NA, dim = c(3,7), dimnames = list(c("single.pop","both.pop","missing.pop"),c("DP","A","C","G","T","Ref.Base","Ref.Freq"))))
    calc_missing_Site <- data.frame(array(NA, dim = c(1,dim(GOOD_DF)[2]), dimnames = list(c(),c(colnames(GOOD_DF)))))
    
    Sys.time()
    # subset by deer for speed
    for(i in 1:7){
      
      one_deer_called_in_good_but_not_miss_df <- called_in_good_but_not_miss_df[called_in_good_but_not_miss_df$Deer==i,]
      
      missing_allele_list <- apply(pooled_missing_sites_pass_DP[pooled_missing_sites_pass_DP$Deer==i,], MARGIN=1, FUN=missing.pop.function)
      
      # ALL missing sites
      missing_allele_df <- as.data.frame(do.call(rbind, missing_allele_list))
      
      missing_allele_df[!is.na(missing_allele_df$ref_freq) & missing_allele_df$DP==0,"ref_freq"] <- NA
      
      FINAL_SITES <- missing_allele_df[!is.na(missing_allele_df$DP) & !is.na(missing_allele_df$ref_freq) & missing_allele_df$DP >= DP_threshold & missing_allele_df$ref_freq >= AF_threshold,]
      
      setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/04_Missing_REF_Sites")
      write.csv(FINAL_SITES, paste0("Miss_Env",Miss_Env,"_Call_Env",Good_Env,"_Deer",i,".csv"), row.names = F)
      
    }
    Sys.time()

