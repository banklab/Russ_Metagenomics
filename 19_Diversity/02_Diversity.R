
library(data.table)

pi_w.function <- function(one.site){ ## calculate pi per locus
  
  alleles <- as.numeric(one.site[c("A","C","G","T")])
  
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
  
  res <- data.frame(array(NA, dim = c(1,3)))
  res[,1] <- pi_w
  res[,2] <- p
  res[,3] <- q
  
  return(res)
  
}

hetero.function2 <- function(one.site){ ## heterozygosity per locus
  
  alleles <- as.numeric(one.site[c("A","C","G","T")])
  
  alleles <- alleles[!is.na(alleles)]
  
  depth <- sum(alleles, na.rm=T)
  
  freqs <- alleles / depth
  
  H <- 1 - sum(freqs^2)

  return(H)
  
}


setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/15_Salmon")
diversity_df <- data.frame(fread("DEER_Abundance.csv", header=T, stringsAsFactors = F))

diversity_df$genome.pi <- NA
diversity_df$genome.H <- NA
diversity_df$diallelic <- NA
diversity_df$multiallelic <- NA
diversity_df$polymorphic <- NA
diversity_df$pi.mean <- NA
diversity_df$pi.var <- NA
diversity_df$H.mean <- NA
diversity_df$H.var <- NA
diversity_df$dN <- NA
diversity_df$dS <- NA
diversity_df$Multiallelic.SNV <- NA
diversity_df$Intergenic.SNV <- NA

setwd("/storage/scratch/users/rj23k073/04_DEER/REFERENCES")
genome_size <- read.csv("genome_sizes.csv", header=T, stringsAsFactors=F)


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")

snp_file_list <- list.files(pattern="InStrain_SNVs_format.csv")


for(i in 1:length(snp_file_list)){
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/FORMAT")
  snp_DF <- data.frame(fread(snp_file_list[i], header=T, stringsAsFactors = F))
  
  species_list <- unique(snp_DF$bin)
  
  DEER <- as.numeric(gsub("_.*","",snp_file_list[i]))
  ENV <- as.numeric(gsub(".*_","",gsub("_InStrain.*","",snp_file_list[i])))
  
  Sys.time()
  for(j in 1:length(species_list)){
    
    single_pop_df <- snp_DF[snp_DF$bin==species_list[j],]
    
    single_pop_df$pi <- NA;single_pop_df$maj.freq <- NA;single_pop_df$min.freq <- NA
    
    pi_and_freqs <- apply(single_pop_df, MARGIN=1, FUN=pi_w.function)
    
    pi_and_freqs2 <- as.data.frame(do.call(rbind, pi_and_freqs))
    
    single_pop_df[,c("pi","maj.freq","min.freq")] <- pi_and_freqs2
    
    single_pop_df$H <- apply(single_pop_df, MARGIN=1, FUN=hetero.function2)
    
    
    ## heterozygosity
    if(sum(is.na(single_pop_df$H))>0){message("NA hetero");break}
    
    genome_H <- sum(single_pop_df$H) / genome_size[genome_size$bin==species_list[j],"genome.size"]
    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"genome.H"] <- genome_H
    
    diallelic <- sum(single_pop_df$allele_count == 2)
    multiallelic <- sum(single_pop_df$allele_count >=3)
    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"diallelic"] <- diallelic
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"multiallelic"] <- multiallelic
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"polymorphic"] <- sum(diallelic, multiallelic) / genome_size[genome_size$bin==species_list[j],"genome.size"]
    
    H_no_zero <- single_pop_df[single_pop_df$H>0,"H"]
    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"H.mean"] <- mean(H_no_zero)
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"H.var"] <- var(H_no_zero)
    
    
    ## pi within
    genome_pi <- sum(single_pop_df$pi) / genome_size[genome_size$bin==species_list[j],"genome.size"]
    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"genome.pi"] <- genome_pi
    
    pi_no_zero <- single_pop_df[single_pop_df$pi>0,"pi"]
    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"pi.mean"] <- mean(pi_no_zero)
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"pi.var"] <- var(pi_no_zero)
    
    
    Ns <- sum(single_pop_df$mutation_type=="N") ## count nonsynonymous mutations (but these are with respect to my own assemblies not reference)
    Ss <- sum(single_pop_df$mutation_type=="S") ## count synonymous (as above)
    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"dN"] <- Ns
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"dS"] <- Ss

    
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"Multiallelic.SNV"] <- sum(single_pop_df$mutation_type=="M")
    diversity_df[diversity_df$bin==species_list[j] & diversity_df$Deer==DEER & diversity_df$Env==ENV,"Intergenic.SNV"] <- sum(single_pop_df$mutation_type=="I")

    if(j==1){ div_by_site <- single_pop_df } else { div_by_site <- rbind(div_by_site,single_pop_df) }
    
  }
  Sys.time()

  setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
  write.csv(div_by_site, paste0(DEER,"_",ENV, "_Diversity_by_site.csv"), row.names = F)
  
  diversity_df_for_sample <- diversity_df[diversity_df$Deer==DEER & diversity_df$Env==ENV,]
  
 
  write.csv(diversity_df_for_sample, paste0(DEER,"_",ENV, "_Diversity_by_sample.csv"), row.names = F)
  
}


Diversity_files <- list.files(pattern="Diversity_by_sample.csv")

for(i in 1:length(Diversity_files)){

  div_file <- data.frame(fread(Diversity_files[i], header=T, stringsAsFactors=F))

  if(i==1){all_div <- div_file} else {all_div <- rbind(all_div, div_file)}

}

all_div2 <- merge(all_div, genome_size, by="bin")

setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
write.csv(all_div2, "DEER_diversity.csv", row.names=F)

