
library(data.table)

gene.function <- function(one.gene, N.scale){
  
  sites.in.gene <- diversity_sub[diversity_sub$Scaffold==as.numeric(one.gene["Scaffold"]) & diversity_sub$POS>=as.numeric(one.gene["Start"]) & diversity_sub$POS<=as.numeric(one.gene["End"]),]
  
  polymorphic.sites <- sum(sites.in.gene$allele_count>1)
  
  Size <- as.numeric(one.gene["Size"])
  
  ## proxy for species abundance, not the gene abundance
  N.proxy <- abund_sub[abund_sub$Sample==SAMPLE,"Percent"] * N.scale
  # N.proxy <- abund_sub[abund_sub$Sample==SAMPLE,"abundance"]
  
  # if(N.proxy<1){stop("N.proxy less than 1")}
  
  output <- data.frame(array(NA, dim = c(1,12), dimnames = list(c(),c("bin","Gene","Type","Size","S","prop.S","gene.pi","poly.pi","gene.H","Scaffold","Start","End"))))
  
  output[,"bin"] <- one.gene["bin"]
  output[,"Gene"] <- one.gene["Gene"]
  output[,"Type"] <- one.gene["Type"]
  output[,"Size"] <- Size
  output[,"S"] <- polymorphic.sites
  output[,"Scaffold"] <- one.gene["Scaffold"]
  output[,"Start"] <- one.gene["Start"]
  output[,"End"] <- one.gene["End"]
  
  if(polymorphic.sites>0){
    
    pi.gene <- sum(sites.in.gene$pi, na.rm=T) / Size
    pi.at.poly.sites <- mean(sites.in.gene$pi, na.rm=T)
    # pi.var <- var(sites.in.gene$pi, na.rm=T)
    
    H.gene <- sum(sites.in.gene$H, na.rm=T) / Size
    # H.var <- var(sites.in.gene$H, na.rm=T)
    
  
    output[,"gene.pi"] <- pi.gene ## mean pi across gene
    output[,"poly.pi"] <- pi.at.poly.sites ## mean pi at polymorphic sites
    output[,"gene.H"] <- H.gene
    output[,"prop.S"] <- polymorphic.sites/Size
  } else {
    ## zero polymorphic sites
    output[,c("gene.pi","poly.pi","gene.H","prop.S")] <- 0
  }
  
  
  instrain.site <- instrain_gene_sub[instrain_gene_sub$Scaffold==as.numeric(one.gene["Scaffold"]) & instrain_gene_sub$start==(as.numeric(one.gene["Start"])-1) & instrain_gene_sub$end==(as.numeric(one.gene["End"])-1),]
  
  if(dim(instrain.site)[1]>0){
    
    if( !is.na(instrain.site$gene_length) & (instrain.site$gene_length!=output["Size"]) ){message("gene size error? ",one.gene["Gene"])}
    
    output2 <- cbind(output,instrain.site[,c("coverage","breadth","nucl_diversity","dNdS_substitutions","pNpS_variants","SNV_count","SNV_S_count","SNV_N_count")])
    
  } else {
    output2 <- cbind(output,array(NA, dim = c(1,8), dimnames = list(c(),c(c("coverage","breadth","nucl_diversity","dNdS_substitutions","pNpS_variants","SNV_count","SNV_S_count","SNV_N_count")))))
  }
  
  
  return(output2)
  
}

setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
abund <- data.frame(fread("DEER_Abundance.csv", header=T, stringsAsFactors = F))

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
gene_intergenic_data <- data.frame(fread("DEER_Gene_and_Intergenic.csv", header=T, stringsAsFactors = F))


setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
diversity_files <- list.files(pattern = "Diversity_by_site.csv")




for(i in 1:length(diversity_files)){
  
  diversity <- data.frame(fread(diversity_files[i], header=T, stringsAsFactors = F))
  
  SAMPLE <- gsub("_Diversity.*","",diversity_files[i])
  
  species_list1 <- unique(diversity$bin)
  
  setwd(paste0("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population/",SAMPLE,"_InStrain/output"))
  instrain_gene_df <- data.frame(fread(paste0(SAMPLE,"_InStrain_gene_info.tsv"), header=T, stringsAsFactors = F))
  instrain_gene_df$bin <- gsub(".*_asm_","",instrain_gene_df$scaffold)
  instrain_gene_df$Scaffold <- gsub("NODE_|_length_.*","",instrain_gene_df$scaffold)

  for(s in 1:length(species_list1)){
    
    SPECIES <- species_list1[s]
    
    diversity_sub <- diversity[diversity$bin==SPECIES,]
    abund_sub <- abund[abund$bin==SPECIES,]
    instrain_gene_sub <-instrain_gene_df[instrain_gene_df$bin==SPECIES,]
    
    gene_list <- apply(gene_intergenic_data[gene_intergenic_data$bin==SPECIES,], MARGIN=1, FUN=gene.function, N.scale=1)
    
    gene_results <- as.data.frame(do.call(rbind, gene_list))
    
    if(s==1){ gene_results2 <- gene_results } else { gene_results2 <- rbind(gene_results2,gene_results) }
    
  } # species
  
  gene_results2$Scaffold <- as.numeric(gene_results2$Scaffold)
  gene_results2$Start <- as.numeric(gene_results2$Start)
  gene_results2$End <- as.numeric(gene_results2$End)
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
  write.csv(gene_results2, paste0(SAMPLE,"_Gene_results.csv"), row.names = F)
  
} # div

