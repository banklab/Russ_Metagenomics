
## hardcoded cmh threshold at 0.01
## hardcoded dbinom threshold at 0.01, 0.005, 0.001


EnvA <- 8
EnvB <- 10


library(data.table)
library(ggplot2)


dbinom.function <- function(DF){
  num.out <- as.numeric(DF["num.out"])
  num.snp <- as.numeric(DF["num.snps"])
  dbinom.sum <- sum(dbinom(c(num.out:num.snp), num.snp, expected_outs))
  return(dbinom.sum)
}


setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
gene_intergenic_data <- data.frame(fread("DEER_Gene_and_Intergenic.csv", header=T, stringsAsFactors = F))


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/07_CMH")

species_list <- gsub("_Env.*","",list.files(pattern=paste0("Env",EnvA,"xEnv",EnvB)))


for(s in 1:length(species_list)){
  
  SPECIES <- species_list[s]
  
  
  gene_intergenic_sub <- gene_intergenic_data[gene_intergenic_data$bin==SPECIES,]
  
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/07_CMH")
  cmh_file <- list.files(pattern=paste0(SPECIES,"_Env",EnvA,"xEnv",EnvB))
  
  cmh_res <-data.frame(fread(cmh_file, header=T, stringsAsFactors = F))
  cmh_res$logp <- -log10(cmh_res$pvalue)
  
  
  thresh <- quantile(cmh_res$logp, 0.99, na.rm=T)
  
  
  cmh_res$outlier <- NA
  
  cmh_res[!is.na(cmh_res$logp) & cmh_res$logp >= thresh, "outlier"] <- TRUE
  cmh_res[!is.na(cmh_res$logp) & cmh_res$logp < thresh, "outlier"] <- FALSE
  
  sum(cmh_res$outlier==TRUE, na.rm=T)
  sum(cmh_res$outlier==FALSE, na.rm=T)
  
  # cat( sum(cmh_res$outlier==TRUE, na.rm=T) / sum(!is.na(cmh_res$logp)))
  
  
  
  gene_list <- unique(gene_intergenic_sub$ID)
  
  gene_array <- data.frame(array(NA, dim = c(length(gene_list),14), dimnames = list(c(),c("scaffold","start","end","size","type","num.out","num.snps","prop.out","dbinom","gene.out_0.01","gene.out_0.005","gene.out_0.001","ID","Prodigal"))))
  
  for(i in 1:length(gene_list)){
    
    scaff <- as.numeric(gsub(".*_scaff|_start.*","",gene_list[i]))
    
    start1 <- as.numeric(gsub(".*_start|_end.*","",gene_list[i]))
    end1 <- as.numeric(gsub(".*_end|_type_.*","",gene_list[i]))
    
    type1 <- gsub(".*_type_","",gene_list[i])
    
    
    gene_df <- cmh_res[!is.na(cmh_res$POS) & cmh_res$Scaffold==scaff & cmh_res$POS >=start1 & cmh_res$POS < end1,]
    
    if(dim(gene_df)[1]==0){
      
      outs1 <- 0;snps1 <- 0 } else {
      
        outs1 <- sum(gene_df$outlier, na.rm = T)
        snps1 <- sum(!is.na(gene_df$pvalue))
    }
    
    gene_array[i,"num.out"] <- outs1
    
    gene_array[i,"num.snps"] <- snps1
    
    
    gene_array[i,"scaffold"] <- scaff
    gene_array[i,"start"] <- start1
    gene_array[i,"end"] <- end1
    gene_array[i,"size"] <- end1-start1
    gene_array[i,"type"] <- type1
    gene_array[i,"ID"] <- gene_list[i]
    
    gene_array[i,"Prodigal"] <- gene_intergenic_sub[gene_intergenic_sub$ID==gene_list[i],"Prodigal"]
    
  }
  
  gene_array$prop.out <- gene_array$num.out / gene_array$num.snps
  
  
  remove_zero_outs <- gene_array[gene_array$num.snps>0 & gene_array$num.out>0,]
  
  expected_outs <- mean(remove_zero_outs$prop.out) ## expected outlier rate
  
  gene_array$dbinom <- apply(gene_array, MARGIN=1, FUN=dbinom.function)
  
  
  if(max(gene_array$num.out)>0){
    
    dbinom_thresh0.001 <- quantile(gene_array$dbinom, 0.001)
    dbinom_thresh0.005 <- quantile(gene_array$dbinom, 0.005)
    dbinom_thresh0.01 <- quantile(gene_array$dbinom, 0.01)
    
    gene_array[gene_array$dbinom <= dbinom_thresh0.001, "gene.out_0.001"] <- TRUE
    gene_array[gene_array$dbinom <= dbinom_thresh0.005, "gene.out_0.005"] <- TRUE
    gene_array[gene_array$dbinom <= dbinom_thresh0.01, "gene.out_0.01"] <- TRUE
    
    gene_array[gene_array$dbinom > dbinom_thresh0.001, "gene.out_0.001"] <- FALSE
    gene_array[gene_array$dbinom > dbinom_thresh0.005, "gene.out_0.005"] <- FALSE
    gene_array[gene_array$dbinom > dbinom_thresh0.01, "gene.out_0.01"] <- FALSE
    
  } else {
    
    gene_array[,"gene.out_0.001"] <- FALSE
    gene_array[,"gene.out_0.005"] <- FALSE
    gene_array[,"gene.out_0.01"] <- FALSE
    
  }
  
  
  
   
  
  filename <- paste0(SPECIES,"_Env",EnvA,"xEnv",EnvB,"_genes",length(gene_list),"_snps",sum(!is.na(cmh_res$pvalue)),"_dbinom.csv")
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/08_DBinom")
  write.csv(gene_array, filename, row.names = F)
  
  
  }



