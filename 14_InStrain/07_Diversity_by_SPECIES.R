
library(data.table)



pi_w.function <- function(one.site){
  
  alleles <- as.numeric(one.site[c("A","C","G","T")])
  
  major.llele <- sort(alleles, decreasing = T)[1]
  minor.llele <- sort(alleles, decreasing = T)[2]
  
  ## multiallelic check
  if(sum(alleles>0)<=2){
    
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
      
    } else { ## 4 alleles
      
      minor3.llele <- sort(alleles, decreasing = T)[4]
      
      allele.pop.size4 <- sum(as.numeric(major.llele),as.numeric(minor.llele),as.numeric(minor2.llele),as.numeric(minor3.llele))
      
      p <- as.numeric(major.llele) / allele.pop.size4
      q <- as.numeric(minor.llele) / allele.pop.size4
      r <- as.numeric(minor2.llele) / allele.pop.size4
      s <- as.numeric(minor3.llele) / allele.pop.size4
      
      pairwise.diff3 <- ( p*q + p*r + p*s + q*r + q*s + r*s ) * allele.pop.size4^2
      
      pi_w <- ( pairwise.diff3 / (choose(allele.pop.size4,2)) )
      
    }
    
  } ## multiallelic
  
  return(pi_w)
  
}

hetero.function2 <- function(one.site){
  
  alleles <- as.numeric(one.site[c("A","C","G","T")])
  
  alleles <- alleles[!is.na(alleles)]
  
  depth <- sum(alleles, na.rm=T)
  
  freqs <- alleles / depth
  
  H <- 1 - sum(freqs^2)
  
  return(H)
  
}



setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")

instrain_list <- list.files(pattern="csv")


SPECIES <- "6_6_bin.14"

env_list <- 1:7

instrain_list <- list.files(pattern="csv")

for(ENV in env_list){
  
  instrain_list_ENV <- instrain_list[grepl(paste0("_",ENV,"_InStrain"),instrain_list)]
  
  if(length(instrain_list_ENV)!=7){message("ERROR");break}
  
  cat(ENV,"\n")
  
  for(i in 1:7){
    
   setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")
   snp_file <- data.frame(fread(instrain_list_ENV[i]), header=T, stringsAsFactors = F)
    
   species_snps <- snp_file[snp_file$Species==SPECIES,]
    
   if(dim(species_snps)[1]>0){
    
    species_snps$pi <- apply(species_snps, MARGIN=1, FUN=pi_w.function)
    species_snps$H <- apply(species_snps, MARGIN=1, FUN=hetero.function2)
   
   } else { species_snps <- cbind(species_snps,array(NA, dim=c(0,2), dimnames = list(c(),c("pi","H")))) }
   
   
   if(i==1){ full_df <- species_snps } else { full_df <- rbind(full_df,species_snps) }
   
  }
  
  
  write.csv(full_df, paste0(SPECIES,"_Env",ENV,"_diversity.csv"), row.names = F)
 
}


