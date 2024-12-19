

library(data.table)

cmh.function <- function(one.site){
  
  site.df <- cmh_input[cmh_input$Sp.ID==one.site,]
  
  if(dim(site.df)[1]<4){stop("not enough dims on input 1")}
  if(length(unique(site.df$Env))<2){stop("not enough dims on input 2")}
  
  usable.deer <- unique(site.df$Deer)
  
  usable.alleles <- names(colSums(site.df[,c("A","C","G","T")]))[ colSums(site.df[,c("A","C","G","T")])>0]
  
  num.alleles <- length(usable.alleles)
  
  
  if(num.alleles<2){stop("number of alleles")}
  
  contingency.table <- array(NA,  dim = c(2, num.alleles, length(usable.deer)), dimnames = list(
    Env = c(paste0("Env",EnvA), paste0("Env",EnvB)),
    Allele = c(usable.alleles),
    Deer = c(usable.deer)))
  
  for(d in 1:length(usable.deer)){
    
    contingency.table[1,usable.alleles,d] <- as.numeric(site.df[site.df$Env==EnvA & site.df$Deer==usable.deer[d],usable.alleles])
    contingency.table[2,usable.alleles,d] <- as.numeric(site.df[site.df$Env==EnvB & site.df$Deer==usable.deer[d],usable.alleles])
    
  }
  
  
  cmh.res <- data.frame(array(NA, dim=c(1,2), dimnames = list(c(),c("p.value","statistic"))))
  
  
  ## TEST
  tryCatch(cmh.res <- mantelhaen.test(contingency.table), error = function(err) cat(one.site," NA \n"))
  
  cmh.full <- data.frame(array(NA, dim=c(1,7), dimnames = list(c(),c("Scaffold","POS","pvalue","statistic","num.alleles","num.deer","deer"))))
  
  cmh.full$pvalue <- cmh.res$p.value
  cmh.full$statistic <- cmh.res$statistic
  
  cmh.full$num.alleles <- num.alleles
  cmh.full$num.deer <- length(usable.deer)
  
  cmh.full$deer <- paste0(usable.deer, collapse="")
  
  
  cmh.full$Scaffold <- as.numeric(gsub(".*_sc|_pos.*","",one.site))
  cmh.full$POS <- as.numeric(gsub(".*_pos","",one.site))
  
  return(cmh.full)
}

EnvA <- 8
EnvB <- 10

setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Filtered_Sites")
sites_df <- data.frame(fread(paste0(SPECIES,"_Env",EnvA,"xEnv",EnvB, "_Filtered_Sites.csv"), header=T, stringsAsFactors = F))

sites_table <- table(sites_df$Sp.ID)

## each site in at least 2 deer
cmh_input <- sites_df[sites_df$Sp.ID %in% names(sites_table[sites_table>2]),]

sites <- unique(cmh_input$Sp.ID)


Sys.time() ## 4.4k sites / min
cmh_list <- lapply(sites, FUN=cmh.function)
Sys.time()

cmh_results <- as.data.frame(do.call(rbind, cmh_list))

num_tests <- sum(!is.na(cmh_results$pvalue))

setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/06_CMH")
write.csv(cmh_results, paste0(SPECIES,"_Env",EnvA,"xEnv",EnvB, "_snps",num_tests,"_CMH.csv"), row.names = F)

