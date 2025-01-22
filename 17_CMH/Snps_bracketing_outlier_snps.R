
library(data.table)

snp_range <- 4
# snp_range <- 12

EnvA <- 8
EnvB <- 9
EnvC <- 10


setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
snp_df <- read.csv("outlier_SNPS.csv", header=T, stringsAsFactors = F)

outlier_species <- unique(snp_df$bin)

for(i in 1:length(outlier_species)){
  
  out_species <- outlier_species[i]
  
  cat(out_species,"\n")
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Filtered_Sites")
  snps <- data.frame(fread(list.files(pattern=paste0(out_species,"_Env",EnvA,"xEnv",EnvC,"_Filter")), header=T, stringsAsFactors = F))
  snps1 <- data.frame(fread(list.files(pattern=paste0(out_species,"_Env",EnvA,"xEnv",EnvB,"_Filter")), header=T, stringsAsFactors = F))
  snps2 <- data.frame(fread(list.files(pattern=paste0(out_species,"_Env",EnvB,"xEnv",EnvC,"_Filter")), header=T, stringsAsFactors = F))
  
  out_df_all <- snp_df[snp_df$bin == out_species,]

  for(j in 1:dim(out_df_all)[1]){
    
    one_out <- out_df_all[j,]
    
    scaffold_snps_all <- snps[snps$Scaffold==one_out$Scaffold,]
    
    ## just keep sites that are called in both env in at least 2 deer
    keep_these <- table(scaffold_snps_all$Sp.ID)[table(scaffold_snps_all$Sp.ID)>2]
    
    scaffold_snps <- scaffold_snps_all[scaffold_snps_all$Sp.ID %in% names(keep_these),]
    
    unique_positions <- unique(sort(scaffold_snps$POS))
    
    snp_index <- which(unique_positions==one_out$POS)
    
    if(c(snp_index-snp_range) < 0 ){stop("outside range 1")}
    if(c(snp_index+snp_range) > length(unique_positions) ){stop("outside range 2")}
    
    range_of_positions <- unique_positions[c(snp_index-snp_range):c(snp_index+snp_range)]
       
    # cat(range_of_positions[length(range_of_positions)] - range_of_positions[1],"bp\n")
    
    if((range_of_positions[length(range_of_positions)] - range_of_positions[1])>1e3){stop("too large?")}
    
    bracketing_snps <- scaffold_snps[scaffold_snps$POS %in% range_of_positions,]
 
    if(length(unique(table(bracketing_snps$Sp.ID.deer))) > 1){break}
    
    unique_genes_check <- unique(bracketing_snps$gene)
    unique_genes_check <- unique_genes_check[unique_genes_check!=""]
    
    # if(length(unique_genes_check)>1){stop("multiple genes?")}
    if(length(unique_genes_check)>1){message("multiple genes?")}
    
    bracketing_snps <- rbind(bracketing_snps, 
                             snps1[snps1$Scaffold==one_out$Scaffold & snps1$POS %in% range_of_positions,],
                             snps2[snps2$Scaffold==one_out$Scaffold & snps2$POS %in% range_of_positions,])
    
    bracketing_snps$First.Freq <- NA
    bracketing_snps$Second.Freq <- NA
    bracketing_snps$Third.Freq <- NA
    
    bracketing_snps$SNP.Outlier.Index <- 0
    
    bracketing_snps[bracketing_snps$POS==one_out$POS,"SNP.Outlier.Index"] <- 1
    
    for(p in 1:length(unique(bracketing_snps$POS))){ ## recalculate maj/min allele freq relative to the same base
      
      recalc_snps <- bracketing_snps[bracketing_snps$POS==unique(bracketing_snps$POS)[p],]
      
      alleles <- sort(colSums(recalc_snps[,c("A","C","G","T")]), decreasing = T)
      
      recalc_snps$First.Freq <- recalc_snps[,names(alleles)[1]] / rowSums(recalc_snps[,c("A","C","G","T")])
      recalc_snps$Second.Freq <- recalc_snps[,names(alleles)[2]] / rowSums(recalc_snps[,c("A","C","G","T")])
      recalc_snps$Third.Freq <- recalc_snps[,names(alleles)[3]] / rowSums(recalc_snps[,c("A","C","G","T")])
      
      if(p==1){ recalc_snps2 <- recalc_snps } else { recalc_snps2 <- rbind(recalc_snps2, recalc_snps) }
      
    } ## Bracketing sites for one outlier SNP
    
    ## 'First.Freq' is the major allele frequency according to the count taken over ALL deer-env points at a given site
    ## 'Maj/Min.Freq' is still the major/minor frequency according to count at a single deer (both env)
    
    recalc_snps2$Gene.Outlier.Index <- paste0(i,"_",j)
    
    if(j==1){ collect_sites <- recalc_snps2 } else { collect_sites <- rbind(collect_sites, recalc_snps2) }
    
  } ## sites
  
  if(i==1){ collect_sites2 <- collect_sites } else { collect_sites2 <- rbind(collect_sites2, collect_sites) }
  
} ## species

setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
write.csv(collect_sites2, "Bracket_snps.csv", row.names = F)
