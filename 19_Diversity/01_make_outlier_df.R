
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 20e3 ## filter species by the number of CMH tests, ie, not technically snps
##  number of CMH tests= number of sites with non-na snps in both environments and at least 2 replicates


q_threshold <- 1e-4 ## top 1e-4 snps ## I used the top 1e-4 snps as a further outlier threshold beyond qvalue<=0.05
q_min_thresh <- 0.05 ## qvalue threshold


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/06_CMH")
cmh_files <- list.files(pattern="CMH.csv") ## cmh results from all species
snp_count <- as.numeric(gsub(".*snps|_CMH.*","",cmh_files))
cmh_files2 <- cmh_files[snp_count>=SNP_filter] ## subset to species with at least this many "snps" (CMH tests)


setwd("/storage/scratch/users/rj23k073/04_DEER/18_eggNOG")
eggy <- data.frame(fread("Eggnog_annotations.csv", header=T, stringsAsFactors = F))

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
gene_intergenic_data <- data.frame(fread("DEER_Gene_and_Intergenic.csv", header=T, stringsAsFactors = F))



for(s in 1:length(cmh_files2)){
  
  if(s==1){
  outlier_df <- data.frame(array(NA, dim = c(0,7), dimnames = list(c(),c("bin","type","description","category","ID","top.snp","q.top.snp"))))
  snp_df <- data.frame(array(NA, dim = c(0,9), dimnames = list(c(),c('Scaffold','POS','pvalue','statistic','num.alleles','num.deer','deer','bin','qvalue'))))
  }
  

  SPECIES1 <- gsub("_Env.*","",cmh_files2[s])
  
  cat("Species:",SPECIES1,"\n")
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/06_CMH")
  # setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/17_CMH/CSV")
  cmh_data <- data.frame(fread(cmh_files2[s], header=T, stringsAsFactors = F))
  
  cmh_data2 <- cmh_data[!is.na(cmh_data$pvalue),]
  
  cmh_data2$bin <- SPECIES1
  
  snp_count <- sum(!is.na(cmh_data2$pvalue)) ## total non na CMH tests
  
  cmh_data2$logp <- log10(cmh_data2$pvalue) ## convert pvalues to log10 space
  
  p_thresh <- quantile(cmh_data2$pvalue, q_threshold)
  
  cmh_data2$OUTLIER <- cmh_data2$pvalue <= p_thresh ## outliers before FDR correction
  
  cmh_data2$qvalue <- p.adjust(cmh_data2$pvalue, method = "BH") ## perform FDR correction here
  
  
  m1_thresh <- quantile(cmh_data2$qvalue, q_threshold)
  
  if(m1_thresh>q_min_thresh){m1_thresh<-q_min_thresh} 
  
  cmh_data2$M1_OUTLIER <- cmh_data2$qvalue <= m1_thresh ## outliers after FDR
  
  if(sum(cmh_data2$M1_OUTLIER)<1){message("no outs\n");next}
  

  
  ## by GENE
  gene_intergenic_sub <- gene_intergenic_data[gene_intergenic_data$bin==SPECIES1,]
  
  gene_list <- unique(gene_intergenic_sub$ID)
  
  gene_array <- data.frame(array(NA, dim = c(length(gene_list),14), dimnames = list(c(),c("scaffold","start","end","size","type","num.out","num.snps","prop.out","dbinom","gene.out","ID","Prodigal","deer","bin"))))
  
  gene_array[,"bin"] <- SPECIES1
  
  ## calc number of outs, snps, per gene
  ## calc which deer contribute to which gene etc
  for(i in 1:length(gene_list)){
    
    scaff <- as.numeric(gsub(".*_scaff|_start.*","",gene_list[i]))
    
    start1 <- as.numeric(gsub(".*_start|_end.*","",gene_list[i]))
    end1 <- as.numeric(gsub(".*_end|_type_.*","",gene_list[i]))
    
    type1 <- gsub(".*_type_","",gene_list[i])
    
    ## get cmh snps within a given gene/intergenic window
    gene_df <- cmh_data2[!is.na(cmh_data2$POS) & cmh_data2$Scaffold==scaff & cmh_data2$POS >=start1 & cmh_data2$POS < end1,]
    
    
    if(dim(gene_df)[1]==0){
      
      outs <- 0;snps1 <- 0;deer.that.contribute<-NA } else {
        
        outs <- sum(gene_df$M1_OUTLIER, na.rm = T)
        
        snps1 <- sum(!is.na(gene_df$qvalue))
        
        
        # deer that contribute to the gene
        deer.combos <- as.character(unique(gene_df$deer))
        
        deer.split <- unlist(strsplit(deer.combos, split=""))
        
        deer.that.contribute <- sort(as.numeric(unique(deer.split)))
        
      }
    
    
    gene_array[i,"num.snps"] <- snps1
    
    
    gene_array[i,"scaffold"] <- scaff
    gene_array[i,"start"] <- start1
    gene_array[i,"end"] <- end1
    gene_array[i,"size"] <- end1-start1
    gene_array[i,"type"] <- type1
    gene_array[i,"ID"] <- gene_list[i]
    
    gene_array[i,"Prodigal"] <- gene_intergenic_sub[gene_intergenic_sub$ID==gene_list[i],"Prodigal"]
    
    gene_array[i,"deer"] <- paste0(deer.that.contribute, collapse = "")
    
    gene_array[i,"num.out"] <- outs
    
  }
  
  
  cat("windows:",dim(gene_array)[1],"\n")
  
  cat("method 1 outliers:",sum(gene_array$num.out>0),"\n")
  
  
  ## Annotate genic outliers according to their COG functional category
  ## intergenic windows just placeholder tag
  cmh_data2$method1 <- 0
  
  gene_outs <- gene_array[gene_array$num.out>0,]
  
  gene_outs$query <- gsub(">| # .*","",gene_outs$Prodigal)
  
  eggy_sub <- eggy[eggy$bin==SPECIES1,]
  
  outlier_temp <- data.frame(array(NA, dim = c(dim(gene_outs)[1],7), dimnames = list(c(),c("bin","type","description","category","ID","top.snp","q.top.snp"))))
  outlier_temp$bin <- SPECIES1
  

  if(dim(gene_outs)[1]>0 ){
    
    for(g in 1:dim(gene_outs)[1]){
      
      outlier_gene <- gene_outs[g,]
      ## cmh snps in gene/window
      cmh_in_outlier_gene <- cmh_data2[cmh_data2$Scaffold==outlier_gene$scaffold & cmh_data2$POS >= outlier_gene$start & cmh_data2$POS <  outlier_gene$end,]
      
      if(dim(cmh_in_outlier_gene)[1] != outlier_gene$num.snps){message("ERROR");break}
      
      function_here <- eggy_sub[eggy_sub$query_name==outlier_gene$query,] ## get function of the outlier
      
      
      if(outlier_gene$type=="Gene"){ ## label gene outliers with COG category
        cmh_data2[cmh_data2$Scaffold==outlier_gene$scaffold & cmh_data2$POS >= outlier_gene$start & cmh_data2$POS <  outlier_gene$end,"method1"] <- paste0(function_here$COG_Functional_cat.,g)
      } else { ## intergenic placeholder label
        cmh_data2[cmh_data2$Scaffold==outlier_gene$scaffold & cmh_data2$POS >= outlier_gene$start & cmh_data2$POS <  outlier_gene$end,"method1"] <- paste0("int",g)
      }
      
      
      outlier_temp[g,2] <- outlier_gene$type
      if(outlier_gene$type=="Gene"){
        outlier_temp[g,3] <- function_here$eggNOG_free_text_desc. ## eggNOG description of gene function
        outlier_temp[g,4] <- function_here$COG_Functional_cat. ## COG category
      }
      
      outlier_temp[g,5] <- outlier_gene$ID
      
      top_snp <- cmh_in_outlier_gene[cmh_in_outlier_gene$qvalue ==min(cmh_in_outlier_gene$qvalue, na.rm=T),][1,] ## most extreme snp (qvalue) in the outlier gene/intergenic window
      
      outlier_temp[g,6] <- paste0(top_snp$Scaffold,"_",top_snp$POS) ## scaffold/position of most extreme snp in outlier
      
      outlier_temp[g,7] <- min(cmh_in_outlier_gene$qvalue, na.rm=T) ## qvalue of most extreme snp
      
    } ## loop
  } ## if
  
  outlier_df <- rbind(outlier_df,outlier_temp)
  
  snp_df <- rbind(snp_df,cmh_data2[cmh_data2$M1_OUTLIER,-c(9:10,12)])
  
}

outlier_df$Scaffold <- as.numeric(gsub(".*_scaff|_start.*","",outlier_df$ID))
outlier_df$Start <- as.numeric(gsub(".*_start|_end.*","",outlier_df$ID))
outlier_df$End <- as.numeric(gsub(".*_end|_type.*","",outlier_df$ID))

setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/19_Diversity")
# setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
write.csv(outlier_df, "outlier_df.csv", row.names = F) ## outlier genes
write.csv(snp_df, "outlier_SNPS.csv", row.names = F) ## outlier snps
