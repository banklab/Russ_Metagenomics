
library(data.table)

format.function <- function(one.site){
  
  DF.AX <- DF_A_sub[DF_A_sub$Sp.ID.deer==one.site]
  DF.BX <- DF_B_sub[DF_B_sub$Sp.ID.deer==one.site]
  pool.X <- pool3_sub[pool3_sub$Sp.ID.deer==one.site]
  
  if(dim(DF.AX)[1] != 1 | dim(DF.BX)[1] != 1){stop("pop missing site - error?")}
  
  site.table <- data.frame(array(NA, dim = c(2,30), dimnames = list(c(),c("bin","Deer","Env","Scaffold","POS","DP","A","C","G","T","Maj.Freq","Min.Freq","Min2","Min3","Original","ref_base","con_base","var_base","ref_freq","con_freq","var_freq","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer"))))
  
  site.table[1,c("bin","Deer","Env","Scaffold","POS","DP","A","C","G","T")] <- DF.AX[1,c("bin","Deer","Env","Scaffold","POS","DP","A","C","G","T")]
  site.table[2,c("bin","Deer","Env","Scaffold","POS","DP","A","C","G","T")] <- DF.BX[1,c("bin","Deer","Env","Scaffold","POS","DP","A","C","G","T")]
  
  site.table[1,c("ref_base","con_base","var_base","ref_freq","con_freq","var_freq","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")] <- DF.AX[1,c("ref_base","con_base","var_base","ref_freq","con_freq","var_freq","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")]
  site.table[2,c("ref_base","con_base","var_base","ref_freq","con_freq","var_freq","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")] <- DF.BX[1,c("ref_base","con_base","var_base","ref_freq","con_freq","var_freq","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")]
  
  
  alleles1 <- sort(colSums(site.table[1,c("A","C","G","T")]), decreasing=T)
  alleles2 <- sort(colSums(site.table[2,c("A","C","G","T")]), decreasing=T)
  
  site.table[1,"Maj.Freq"] <- site.table[1,names(alleles1)[1]] / site.table$DP[1]
  site.table[1,"Min.Freq"] <- site.table[1,names(alleles1)[2]] / site.table$DP[1]
  site.table[1,"Min2"] <- site.table[1,names(alleles1)[3]] / site.table$DP[1]
  site.table[1,"Min3"] <- site.table[1,names(alleles1)[4]] / site.table$DP[1]
  
  site.table[2,"Maj.Freq"] <- site.table[2,names(alleles2)[1]] / site.table$DP[2]
  site.table[2,"Min.Freq"] <- site.table[2,names(alleles2)[2]] / site.table$DP[2]
  site.table[2,"Min2"] <- site.table[2,names(alleles2)[3]] / site.table$DP[2]
  site.table[2,"Min3"] <- site.table[2,names(alleles2)[4]] / site.table$DP[2]
  
  
  return(site.table)
}


snps.function <- function(one.site){
  
  DF.AX <- DF_A_sub[DF_A_sub$Sp.ID.deer==one.site]
  DF.BX <- DF_B_sub[DF_B_sub$Sp.ID.deer==one.site]
  pool.X <- pool3_sub[pool3_sub$Sp.ID.deer==one.site]
  
  
  if(dim(DF.AX)[1]>0 & dim(DF.BX)[1]>0){stop("both pops have site - error?")}
  
  site.table <- data.frame(array(NA, dim = c(3,30), dimnames = list(c(),c("bin","Deer","Env","Scaffold","POS","DP","A","C","G","T","Maj.Freq","Min.Freq","Min2","Min3","Original","ref_base","con_base","var_base","ref_freq","con_freq","var_freq","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer"))))
  
  site.table[3,c("Env","DP","A","C","G","T","ref_base","con_base","var_base","ref_freq","con_freq","var_freq")] <- pool.X[,c("Env","DP","A","C","G","T","ref_base","con_base","var_base","ref_freq","con_freq","var_freq")]
  site.table[3,"Original"] <- TRUE
  
  
  if(dim(DF.AX)[1]>0){
    site.table[1,c("Env","DP","A","C","G","T","ref_base","con_base","var_base","ref_freq","con_freq","var_freq")] <- DF.AX[,c("Env","DP","A","C","G","T","ref_base","con_base","var_base","ref_freq","con_freq","var_freq")]
  } else {
    site.table[1,"Env"] <- EnvA
    
    site.table[1,"ref_base"] <- site.table[3,"ref_base"]
    
    site.table[1,"Original"] <- FALSE
    site.table[2,"Original"] <- TRUE
  }
  
  if(dim(DF.BX)[1]>0){
    site.table[2,c("Env","DP","A","C","G","T","ref_base","con_base","var_base","ref_freq","con_freq","var_freq")] <- DF.BX[,c("Env","DP","A","C","G","T","ref_base","con_base","var_base","ref_freq","con_freq","var_freq")]
    site.table[1,c("DP","A","C","G","T")] <- (site.table[3,c("DP","A","C","G","T")] - site.table[2,c("DP","A","C","G","T")])
    
    if(site.table[1,"ref_base"] != "N"){
      site.table[1,"ref_freq"] <- site.table[1,site.table[1,"ref_base"]] / site.table[1,"DP"]
    }
    
    site.table[1,"con_base"] <- c("A","C","G","T")[which(site.table[1,c("A","C","G","T")]==max(site.table[1,c("A","C","G","T")]))][1]
    site.table[1,"con_freq"] <- site.table[1,site.table[1,"con_base"]] / site.table[1,"DP"]
    
    if(site.table[1,"ref_base"] != "N"){
      site.table[1,"var_base"] <- names(sort(unlist(site.table[1,c("A","C","G","T")]), decreasing=T)[2])
    } else {
      site.table[1,"var_base"] <- names(sort(unlist(site.table[1,c("A","C","G","T")]), decreasing=T)[1])
    }
    
    site.table[1,"var_freq"] <- site.table[1,site.table[1,"var_base"]] / site.table[1,"DP"]
    
  } else {
    site.table[2,"Env"] <- EnvB
    site.table[2,c("DP","A","C","G","T")] <- (site.table[3,c("DP","A","C","G","T")] - site.table[1,c("DP","A","C","G","T")])
    
    site.table[2,"ref_base"] <- site.table[3,"ref_base"]
    
    if(site.table[2,"ref_base"] != "N"){
      site.table[2,"ref_freq"] <- site.table[2,site.table[2,"ref_base"]] / site.table[2,"DP"]
    }
    
    site.table[2,"con_base"] <- c("A","C","G","T")[which(site.table[2,c("A","C","G","T")]==max(site.table[2,c("A","C","G","T")]))][1]
    site.table[2,"con_freq"] <- site.table[2,site.table[2,"con_base"]] / site.table[2,"DP"]
    
    if(site.table[2,"ref_base"] != "N"){
      site.table[2,"var_base"] <- names(sort(unlist(site.table[2,c("A","C","G","T")]), decreasing=T)[2])
    } else {
      site.table[2,"var_base"] <- names(sort(unlist(site.table[2,c("A","C","G","T")]), decreasing=T)[1])
    }
    
    site.table[2,"var_freq"] <- site.table[2,site.table[2,"var_base"]] / site.table[2,"DP"]
    
    site.table[2,"Original"] <- FALSE
    site.table[1,"Original"] <- TRUE
  }
  
  
  if(length(unique(site.table[,"ref_base"]))>1){stop("too many REF base? - error?")}
  
  if( sum(site.table[,c("A","C","G","T")]<0)>1 ){stop("too many negative base calls?")}
  
  if( sum(site.table[,c("A","C","G","T")]<0)==1 ){
    ## adjust max allele count down
    new.max.allele.count <-  max(site.table[site.table$Original==FALSE,c("A","C","G","T")]) + min(site.table[site.table$Original==FALSE,c("A","C","G","T")])
    site.table[site.table$Original==FALSE,c("A","C","G","T")][site.table[site.table$Original==FALSE,c("A","C","G","T")]==max(site.table[site.table$Original==FALSE,c("A","C","G","T")])] <- new.max.allele.count
    ## set negative allele count to zero
    site.table[site.table$Original==FALSE,c("A","C","G","T")][site.table[site.table$Original==FALSE,c("A","C","G","T")]<0]<-0
    
    site.table[site.table$Original==FALSE,"ref_freq"] <- site.table[site.table$Original==FALSE,site.table[site.table$Original==FALSE,"ref_base"]] / site.table[site.table$Original==FALSE,"DP"]
    site.table[site.table$Original==FALSE,"con_freq"] <- site.table[site.table$Original==FALSE,site.table[site.table$Original==FALSE,"con_base"]] / site.table[site.table$Original==FALSE,"DP"]
    site.table[site.table$Original==FALSE,"var_freq"] <- site.table[site.table$Original==FALSE,site.table[site.table$Original==FALSE,"var_base"]] / site.table[site.table$Original==FALSE,"DP"]
    
    }
  
  for(i in 1:3){
    
    alleles <- sort(unlist(site.table[i,c("A","C","G","T")]), decreasing=T)
    
    site.table[i,"Maj.Freq"] <- site.table[i,names(alleles)[1]] / site.table$DP[i]
    site.table[i,"Min.Freq"] <- site.table[i,names(alleles)[2]] / site.table$DP[i]
    site.table[i,"Min2"] <- site.table[i,names(alleles)[3]] / site.table$DP[i]
    site.table[i,"Min3"] <- site.table[i,names(alleles)[4]] / site.table$DP[i]
    
  }
  
  ## both single pops are 
  # if( sum(site.table$Maj.Freq[1:2]==1)==2 & identical(site.table$con_base[1], site.table$con_base[2]) ){ return(NULL) }
  
  
  if( sum(site.table[1,c("A","C","G","T")]) != site.table[1,"DP"] ){stop("error depth 1?");message(one.site)}
  if( sum(site.table[2,c("A","C","G","T")]) != site.table[2,"DP"] ){stop("error depth 2?");message(one.site)}
  
  
  site.table[3,c("bin","Deer","Scaffold","POS","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")] <- pool.X[,c("bin","Deer","Scaffold","POS","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")]
  
  
  if(dim(DF.AX)[1]>0){
    site.table[1:2,c("bin","Deer","Scaffold","POS","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")] <- DF.AX[,c("bin","Deer","Scaffold","POS","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")]
  }
  
  if(dim(DF.BX)[1]>0){
    site.table[1:2,c("bin","Deer","Scaffold","POS","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")] <- DF.BX[,c("bin","Deer","Scaffold","POS","gene","mutation","mutation_type","cryptic","class","scaffold2","ID","Sp.ID","Sp.ID.deer")]
  }
  
  
  return(site.table)
  
}


EnvA <- 8
EnvB <- 10



## Pooled
setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/02_Two_Populations/FORMAT")
pool <- data.frame(fread("NEW_Pooled_Env8_Env10_snps.csv", header=T, stringsAsFactors = F))


## Single
setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/03_Formatted_Results")
DF_A <- data.frame(fread(paste0("Env",EnvA,"_snps.csv"), header=T, stringsAsFactors = F))
DF_B <- data.frame(fread(paste0("Env",EnvB,"_snps.csv"), header=T, stringsAsFactors = F))


## unique ID of each species-deer-scaffold-pos 
## ID in one or both pops
all_sites_in_single_pops <- union(DF_A$Sp.ID.deer,DF_B$Sp.ID.deer)
## ID in BOTH pops
sites_in_both_pops <- intersect(DF_A$Sp.ID.deer,DF_B$Sp.ID.deer)
## ID in ONLY one pop
sites_in_only_one_pop <- setdiff(all_sites_in_single_pops, sites_in_both_pops)


## these are sites called in BOTH single pops
pool2 <- pool[pool$Sp.ID.deer %in% sites_in_both_pops,]

## sites called in Pooled pop but NOT in either single pop
extra <- pool[!pool$Sp.ID.deer %in% all_sites_in_single_pops,]

## these are sites called in ONLY one single pop - so fill in the missing pop from the pooled data etc
pool3 <- pool[pool$Sp.ID.deer %in% sites_in_only_one_pop,]


if( dim(pool)[1] != sum(dim(pool2)[1],dim(pool3)[1],dim(extra)[1]) ){message("error sum of dfs");break}


## Step 1: go through pooled sites and find sites that were called in one pop and not in the second, because they were REF in the second

# all_sites <- pool2$Sp.ID.deer
# all_sites <- pool3$Sp.ID.deer


pool3$Env <- gsub("Env|_","",pool3$Env)

pool3$Env <- as.numeric(pool3$Env)

species_list <- unique(c(pool2$bin,pool3$bin))


for(s in 1:length(species_list)){
  
  SPECIES <- species_list[s]
  
  cat(SPECIES,"\n")
  
  DF_A_sub <- as.data.table(DF_A[DF_A$bin==SPECIES,])
  DF_B_sub <- as.data.table(DF_B[DF_B$bin==SPECIES,])
  pool2_sub <- as.data.table(pool2[pool2$bin==SPECIES,])
  pool3_sub <- as.data.table(pool3[pool3$bin==SPECIES,])
  
  format_sites <- pool2_sub$Sp.ID.deer
  all_sites <- pool3_sub$Sp.ID.deer
  
  cat("find missing sites:",length(all_sites),"\n")
  
  Sys.time() ## ~6.1k sites / min
  new_sites_list <- lapply(all_sites, FUN=snps.function)
  Sys.time()
  
  new_sites_df <- as.data.frame(do.call(rbind, new_sites_list))
  
  
  cat("format sites:",length(format_sites),"\n")
  
  Sys.time() ## ~8.5k sites / min
  format_sites_list <- lapply(format_sites, FUN=format.function)
  Sys.time()
  
  format_sites_df <- as.data.frame(do.call(rbind, format_sites_list))
  format_sites_df$Original <- TRUE
  
  cat("min format depth:", min(format_sites_df$DP),"\n")
  
  
  combined_sites <- rbind(format_sites_df, new_sites_df[new_sites_df$Env %in% c(EnvA,EnvB),])
  
  if( length(unique(combined_sites$Sp.ID.deer)) != sum(length(format_sites),length(all_sites)) ){message(paste0("error final size ",SPECIES));break}
  
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/04_Combined_Sites")
  write.csv(combined_sites, paste0(SPECIES, "_Env",EnvA,"xEnv",EnvB,"_Combined_Sites.csv"), row.names = F)
  write.csv(new_sites_df, paste0(SPECIES, "_Env",EnvA,"xEnv",EnvB, "_NEW_Sites.csv"), row.names = F)
  
  cat("done\n")
  cat("\n")
  
}







