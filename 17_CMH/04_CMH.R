

EnvA <- 8
EnvB <- 10

# This many sites in at least 2 deer shared between Environments 
SNPs_Threshold <- 10e3




cmh.function <- function(one.Site, metric){
  
  pop1.site <- pop1_sp[pop1_sp$ID==one.Site,]
  pop2.site <- pop2_sp[pop2_sp$ID==one.Site,]
  
  if(dim(pop1.site)[1]<2){message("ERROR1");break}
  if(dim(pop2.site)[1]<2){message("ERROR2");break}
  
  usable.deer <- c(pop1.site$Deer,pop2.site$Deer)[duplicated(c(pop1.site$Deer,pop2.site$Deer))]
  num.deer <- length(usable.deer)
  
  pop1.site.deer <- pop1.site[pop1.site$Deer %in% usable.deer,]
  pop2.site.deer <- pop2.site[pop2.site$Deer %in% usable.deer,]
  
  
  allele.full.table <- rbind(pop1.site.deer[,c("A","C","G","T")],pop2.site.deer[,c("A","C","G","T")])
  
  allele.population <- colSums(allele.full.table)
  
  num.alleles <- sum(allele.population>0)
  
  
  contingency.table <- array(NA,  dim = c(2, num.alleles, num.deer), dimnames = list(
    Env = c(paste0("Env",EnvA), paste0("Env",EnvB)),
    Allele = c(c("Maj","Min","Min2","Min3")[1:num.alleles]),
    Deer = c(usable.deer)))
  
  
  ## no polymorphism (this could be because all deer are fixed 100% for variant)
  if(num.alleles<2){ if(metric=="table"| metric=="t"){ return(contingency.table) }else{return(NA)} }
  
  
  allele.population2 <- sort(allele.population, decreasing=T)
  
  Maj.allele <- names(allele.population2)[1]
  Min.allele <- names(allele.population2)[2]
  Multi1.allele <- names(allele.population2)[3]
  Multi2.allele <- names(allele.population2)[4]
  
  
  ## fill contingency table
  for(d in 1:num.deer){
    
    DEER <- usable.deer[d]
    
    ## POP 1
    contingency.table[1,1,d] <- pop1.site.deer[pop1.site.deer$Deer==DEER,Maj.allele]
    contingency.table[1,2,d] <- pop1.site.deer[pop1.site.deer$Deer==DEER,Min.allele]
    
    ## POP 2
    contingency.table[2,1,d] <- pop2.site.deer[pop2.site.deer$Deer==DEER,Maj.allele]
    contingency.table[2,2,d] <- pop2.site.deer[pop2.site.deer$Deer==DEER,Min.allele]
    
    ## multiallelic ##
    if(num.alleles>=3){ ## add in multiallelic bases
      ## 3 alleles
      contingency.table[1,3,d] <- pop1.site.deer[pop1.site.deer$Deer==DEER,Multi1.allele]
      contingency.table[2,3,d] <- pop2.site.deer[pop2.site.deer$Deer==DEER,Multi1.allele]
      
      if(num.alleles==4){ ## 4 alleles
        contingency.table[1,4,d] <- pop1.site.deer[pop1.site.deer$Deer==DEER,Multi2.allele]
        contingency.table[2,4,d] <- pop2.site.deer[pop2.site.deer$Deer==DEER,Multi2.allele]
      }
    } # multi
    
  } # deer
  
  
  cmh.res <- data.frame(array(NA, dim=c(1,2), dimnames = list(c(),c("p.value","statistic"))))
  
  
  ## TEST
  tryCatch(cmh.res <- mantelhaen.test(contingency.table), error = function(err) cat(one.Site," NA \n"))

  cmh.full <- data.frame(array(NA, dim=c(1,7), dimnames = list(c(),c("Scaffold","POS","pvalue","statistic","num.alleles","num.deer","deer"))))
           
  cmh.full$pvalue <- cmh.res$p.value
  cmh.full$statistic <- cmh.res$statistic
  
  cmh.full$num.alleles <- num.alleles
  cmh.full$num.deer <- num.deer

  cmh.full$deer <- paste0(usable.deer, collapse="")

  
  cmh.full$Scaffold <- as.numeric(gsub("_.*","",one.Site))
  cmh.full$POS <- as.numeric(gsub(".*_","",one.Site))
  

  
  if(metric=="table"| metric=="t"){ return(contingency.table) } 
  if(metric=="stat" | metric=="statistic" | metric=="s"){ return(cmh.res$statistic) } 
  # if(metric!="stat" & metric!="statistic" & metric!="table" & metric!="s" & metric!="t"){ return(cmh.res$p.value) } 
  if(metric=="pvalue" | metric=="p.value" | metric=="p"){ return(cmh.res$p.value) } 
  
  if(metric=="ALL" | metric=="All" | metric=="all"){ return(cmh.full) }
  

}

library(data.table)

setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/06_Good_Sites")

pop1 <- data.frame(fread(paste0("Env",EnvA,"_x_Env",EnvB,"_final_sites_Threshold",SNPs_Threshold,".csv"), header=T, stringsAsFactors = F))

pop2 <- data.frame(fread(paste0("Env",EnvB,"_x_Env",EnvA,"_final_sites_Threshold",SNPs_Threshold,".csv"), header=T, stringsAsFactors = F))

SPECIES <- unique(pop1$bin)

length(SPECIES)

for(i in 1:length(SPECIES)){
  
  pop1_sp <- pop1[pop1$bin==SPECIES[i],]
  pop2_sp <- pop2[pop2$bin==SPECIES[i],]
  
  Sites <- unique(c(pop1_sp$ID,pop2_sp$ID))
  Sites1 <- unique(pop1_sp$ID);Sites2 <- unique(pop2_sp$ID)
  
  if(identical(Sites,Sites1)==FALSE){message("ERROR11");break};if(identical(sort(Sites),sort(Sites2))==FALSE){message("ERROR22");break}
  
  
  ## Old way - just getting the p.value or contingency table etc
  
  # cmh_results2 <- data.frame(mapply(Sites, FUN=cmh.function, metric="p"))
  # colnames(cmh_results) <- "pvalue"
  # cmh_results$Scaffold <- as.numeric( gsub("_.*","",rownames(cmh_results)))
  # cmh_results$POS <- as.numeric( gsub(".*_","",rownames(cmh_results)))
  
  Sys.time()
  cmh_list <- lapply(Sites, FUN=cmh.function, metric="all")
  cmh_results <- as.data.frame(do.call(rbind, cmh_list))
  Sys.time()
  
  
  non_na_sites <- sum(!is.na(cmh_results$pvalue))
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/07_CMH")
  write.csv(cmh_results, paste0(SPECIES[i],"_Env",EnvA,"xEnv",EnvB,"_",non_na_sites,"snps_CMH.csv"), row.names = F)
  
}

