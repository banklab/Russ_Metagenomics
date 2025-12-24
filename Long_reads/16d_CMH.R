

library(data.table)

cmh.function <- function(one.site){
  
  site.df <- cmh_input[cmh_input$Sp.ID==one.site,]
  
  if(dim(site.df)[1]<4){return(NULL)}
  if(length(unique(site.df$Env))<2){stop("not enough dims on input 2")}
  
  usable.deer <- unique(site.df$Deer) ## need at least 2 deer (replicates) to perform a test
  
  usable.alleles <- names(colSums(site.df[,c("A","C","G","T")]))[ colSums(site.df[,c("A","C","G","T")])>0]
  
  num.alleles <- length(usable.alleles) ## need at least 2 alleles to perform test
  
  
  if(num.alleles<2){stop("number of alleles")}
  ## fill in contingency table
  contingency.table <- array(NA,  dim = c(2, num.alleles, length(usable.deer)), dimnames = list(
    Env = c(paste0("Env",EnvA), paste0("Env",EnvB)),
    Allele = c(usable.alleles),
    Deer = c(usable.deer)))
  
  for(d in 1:length(usable.deer)){ ## fill in allele counts for each deer (replicate)
    
    contingency.table[1,usable.alleles,d] <- as.numeric(site.df[site.df$Env==EnvA & site.df$Deer==usable.deer[d],usable.alleles])
    contingency.table[2,usable.alleles,d] <- as.numeric(site.df[site.df$Env==EnvB & site.df$Deer==usable.deer[d],usable.alleles])
    
  }
  
  
  cmh.res <- data.frame(array(NA, dim=c(1,2), dimnames = list(c(),c("p.value","statistic")))) ## collect results
  
  
  ## TEST
  tryCatch(cmh.res <- mantelhaen.test(contingency.table), error = function(err) cat(one.site," NA \n"))
  
  cmh.full <- data.frame(array(NA, dim=c(1,7), dimnames = list(c(),c("Scaffold","POS","pvalue","statistic","num.alleles","num.deer","deer"))))
  
  cmh.full$pvalue <- cmh.res$p.value
  cmh.full$statistic <- cmh.res$statistic
  
  cmh.full$num.alleles <- num.alleles
  cmh.full$num.deer <- length(usable.deer)
  
  cmh.full$deer <- paste0(usable.deer, collapse="") ## here I am just recording specifically which deer ID contributed to the test
  
  
  cmh.full$Scaffold <- gsub(".*_sc|_pos.*","",one.site)
  cmh.full$POS <- as.numeric(gsub(".*_pos","",one.site))
  
  return(cmh.full)
}

EnvA <- 8
EnvB <- 10


SNP_filter <- 20e3 ## only using species with at least x number of USEABLE snps (snps that can go into cmh test)


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
cmh_list <- list.files(pattern=(paste0("_Env",EnvA,"xEnv",EnvB,"_Filter_snps")))
snp_count <- as.numeric(gsub(".*snps|\\.csv","",cmh_list))

cmh_list2 <- cmh_list[snp_count>=SNP_filter]



for(i in 1:length(cmh_list2)){

  SPECIES <- gsub("_Env.*","",cmh_list2[i])
  
  cat(SPECIES,"\n")
  
 setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
 sites_df <- data.frame(fread(cmh_list2[i], header=T, stringsAsFactors = F))
  
  sites_table <- table(sites_df$Sp.ID)
  
  ## each site in at least 2 deer
  cmh_input <- sites_df[sites_df$Sp.ID %in% names(sites_table[sites_table>2]),]
  
  sites <- unique(cmh_input$Sp.ID)
  
  
  cat("input sites:",length(sites),"\n")
  
  Sys.time() 
  cmh_list <- lapply(sites, FUN=cmh.function)
  Sys.time()
  
  cmh_results <- as.data.frame(do.call(rbind, cmh_list))
  
  num_tests <- sum(!is.na(cmh_results$pvalue))
  
 setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/CMH")
 write.csv(cmh_results, paste0(SPECIES,"_Env",EnvA,"xEnv",EnvB, "_snps",num_tests,"_CMH_LR.csv"), row.names = F)
  
}
