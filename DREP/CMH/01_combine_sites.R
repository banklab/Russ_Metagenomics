
library(data.table)


format.function <- function(one.site){
}


snps.function <- function(one.site){
}


EnvA <- 8 ## choose which environments
EnvB <- 10




## Pooled
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")
pool <- data.frame(fread(paste0("Pooled_Env",EnvA,"_Env",EnvB,"_LR_snps.csv"), header=T, stringsAsFactors = F))


## Single
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")
DF_A <- data.frame(fread(paste0("ENV",EnvA,"_LR_SNPS.csv"), header=T, stringsAsFactors = F))
DF_B <- data.frame(fread(paste0("ENV",EnvB,"_LR_SNPS.csv"), header=T, stringsAsFactors = F))



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


if( dim(pool)[1] != sum(dim(pool2)[1],dim(pool3)[1],dim(extra)[1]) ){stop("error sum of dfs")}



## Step 1: go through pooled sites and find sites that were called in one pop and not in the second, because they were REF in the second

pool3$Env <- gsub("Env|_","",pool3$Env)

pool3$Env <- as.numeric(pool3$Env)


species_list <- unique(pool3$bin)



for(s in 1:length(species_list)){ ## loop over species
  
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
  
  if(length(format_sites)>0){
    Sys.time() ## ~8.5k sites / min
    format_sites_list <- lapply(format_sites, FUN=format.function)
    Sys.time()
    
    format_sites_df <- as.data.frame(do.call(rbind, format_sites_list))
    format_sites_df$Original <- TRUE
    
    cat("min format depth:", min(format_sites_df$DP),"\n")
    
    combined_sites <- rbind(format_sites_df, new_sites_df[new_sites_df$Env %in% c(EnvA,EnvB),])
    
  } else { combined_sites <- new_sites_df[new_sites_df$Env %in% c(EnvA,EnvB),] }
  
  
  if( length(unique(combined_sites$Sp.ID.deer)) != sum(length(format_sites),length(all_sites)) ){message(paste0("error final size ",SPECIES));break}
  
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Combined_Sites")
  write.csv(combined_sites, paste0(SPECIES, "_Env",EnvA,"xEnv",EnvB,"_Combined_Sites.csv"), row.names = F)
  # write.csv(new_sites_df, paste0(SPECIES, "_Env",EnvA,"xEnv",EnvB, "_NEW_Sites.csv"), row.names = F)
  
  cat("done\n")
  cat("\n")
  
}
