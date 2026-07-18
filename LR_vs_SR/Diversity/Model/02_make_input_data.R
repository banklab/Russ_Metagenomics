
library(lme4)
# library(lmerTest)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Models")
snp_counts_LR28 <- read.csv("Snp_counts_LR28.csv", header=T, stringsAsFactors = F)
snp_counts_SR28 <- read.csv("Snp_counts_SR28.csv", header=T, stringsAsFactors = F)

asm_df <- read.csv("asm_df.csv", header=T, stringsAsFactors=F)

asm_LR28 <- asm_df[asm_df$DATA=="LR28",]
asm_SR28 <- asm_df[asm_df$DATA=="SR28",]

asm_LR28$Genome <- gsub("\\.fa","",asm_LR28$genome)
asm_SR28$Genome <- gsub("\\.fa","",asm_SR28$genome)


cluster_genomes <- read.csv("Methods_Clusters_keep_genomes.csv", header=T, stringsAsFactors = F)

cluster_genomes$LR28SR70.genome1 <- gsub("LR28SR70_|deer_|\\.fa","",cluster_genomes$LR28SR70.genome)
cluster_genomes$LR28.genome1 <- gsub("LR28_|deer_|\\.fa","",cluster_genomes$LR28.genome)
cluster_genomes$SR70.genome1 <- gsub("SR70_|deer_|\\.fa","",cluster_genomes$SR70.genome)
cluster_genomes$SR28.genome1 <- gsub("SR28_|deer_|\\.fa","",cluster_genomes$SR28.genome)



asm_cols <- c('Genome','completeness','contamination','Coding_Density','Contig_N50','Average_Gene_Length','GC_Content','Total_Coding_Sequences','Total_Contigs','Max_Contig_Length','Assembly','X..contigs.....0.bp.','X..contigs.....1000.bp.','X..contigs.....5000.bp.','X..contigs.....10000.bp.','X..contigs.....25000.bp.','X..contigs.....50000.bp.','Total.length.....0.bp.','Total.length.....1000.bp.','Total.length.....5000.bp.','Total.length.....10000.bp.','Total.length.....25000.bp.','Total.length.....50000.bp.','X..contigs','Largest.contig','N50','N90','auN','L50','L90','X..N.s.per.100.kbp')

setdiff(snp_counts_LR28$Genome, asm_LR28$Genome)
setdiff(snp_counts_SR28$Genome, asm_SR28$Genome)

snp_counts_LR28_2 <- merge(snp_counts_LR28, asm_LR28[,asm_cols], by="Genome")
snp_counts_SR28_2 <- merge(snp_counts_SR28, asm_SR28[,asm_cols], by="Genome")


snp_counts_DF <- rbind(snp_counts_LR28_2,snp_counts_SR28_2)

pc_sample <-c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')

## subset to ONLY pacbio samples
snp_counts_DF <- snp_counts_DF[snp_counts_DF$Sample %in% pc_sample,]

## just genomes from the same cluster
snp.counts.function <- function(diversity, data1, data2, format="wide"){
  
  div1 <- diversity[diversity$Method==data1,]
  
  div2 <- diversity[diversity$Method==data2,]
  
  
  common.samples <- intersect(unique(div1$Sample),unique(div2$Sample))
  
  div1 <- div1[div1$Sample %in% common.samples, ]
  
  div2 <- div2[div2$Sample %in% common.samples, ]
  
  
  clusters.test <- cluster_genomes[,c(data1, data2)]
  if( max(clusters.test[,1])>1 | max(clusters.test[,2])>1 ){stop("redundant genomes?")}
  
  
  cluster_genomes1 <- cluster_genomes[cluster_genomes[,data1]>0,c(paste0(data1,".genome1"),"cluster")]
  colnames(cluster_genomes1)[1] <- "Genome"
  
  if( dim(cluster_genomes1)[1] < length(unique(div1$Genome)) ){stop("error data 1")}
  
  cluster_genomes2 <- cluster_genomes[cluster_genomes[,data2]>0,c(paste0(data2,".genome1"),"cluster")]
  colnames(cluster_genomes2)[1] <- "Genome"
  
  if( dim(cluster_genomes2)[1] < length(unique(div2$Genome)) ){stop("error data 2")}
  
  
  
  div1.cluster <- merge(div1, cluster_genomes1, by="Genome")
  if( sum(is.na(div1.cluster$cluster))>0 ){stop("error merge 1")}
  if( dim(div1.cluster)[1]==0 ){stop("error merge 1.1")}
  
  div2.cluster <- merge(div2, cluster_genomes2, by="Genome")
  if( sum(is.na(div2.cluster$cluster))>0 ){stop("error merge 2")}
  if( dim(div2.cluster)[1]==0 ){stop("error merge 2.1")}
  
  
  common.clusters <- intersect(div1.cluster$cluster,div2.cluster$cluster)
  
  div1.common <- div1.cluster[div1.cluster$cluster %in% common.clusters, ]
  div2.common <- div2.cluster[div2.cluster$cluster %in% common.clusters, ]
  
  
  if(format=="wide"){
    
    colnames(div1.common) <- paste0(colnames(div1.common),".",data1)
    colnames(div2.common) <- paste0(colnames(div2.common),".",data2)
    
    div1.common$ID <- paste0(div1.common$cluster,"_xx_",div1.common$Sample)
    div2.common$ID <- paste0(div2.common$cluster,"_xx_",div2.common$Sample)
    
    diversity.by.cluster <- merge(div1.common,div2.common, by="ID")
    
  } else {
    
    div1.common$ID <- paste0(div1.common$cluster,"_xx_",div1.common$Sample)
    div2.common$ID <- paste0(div2.common$cluster,"_xx_",div2.common$Sample)
    
    diversity.by.cluster_0 <- rbind(div1.common, div2.common)
    
    # remove species if they have 0 snps in a sample (in both methods)
    speices.with.zero <- tapply(diversity.by.cluster_0$snp.count, diversity.by.cluster_0$ID, sum)[tapply(diversity.by.cluster_0$snp.count, diversity.by.cluster_0$ID, sum)==0]
    
    diversity.by.cluster <- diversity.by.cluster_0[!diversity.by.cluster_0$ID %in% names(speices.with.zero),]
    
  }
  
  return(diversity.by.cluster)
  
}

# snp_wide <- snp.counts.function(snp_counts_DF, data1="LR28", data2="SR28")
snp_long <- snp.counts.function(snp_counts_DF, data1="LR28", data2="SR28", format="long")

write.csv(snp_long, "snp_long.csv", row.names=F)


