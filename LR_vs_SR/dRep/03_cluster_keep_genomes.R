

choose_drep <- 95

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep/04_drep95_onlyLR28_SR28/data_tables")
cdb <- read.csv("Cdb.csv")

cdb$Method <- sub("_.*", "", cdb$genome)

table(cdb$Method)
table(table(cdb$secondary_cluster))

cluster_list <- unique(cdb$secondary_cluster)

cluster_df <- data.frame(array(NA, dim=c(length(cluster_list), 10), dimnames=list(c(),c("drep","cluster","LR28SR70","LR28","SR70","SR28","LR28SR70.genome","LR28.genome","SR70.genome","SR28.genome"))))
cluster_df$drep <- choose_drep

for(i in 1:length(cluster_list)){

  cluster1 <- cdb[cdb$secondary_cluster==cluster_list[i],]

  cluster_df[i,"cluster"] <- cluster_list[i]

 cluster_df[i,"LR28SR70"] <- sum(sum(cluster1$Method=="LR28SR70")>0)
 cluster_df[i,"LR28"] <- sum(sum(cluster1$Method=="LR28")>0)
 cluster_df[i,"SR70"] <- sum(sum(cluster1$Method=="SR70")>0)
 cluster_df[i,"SR28"] <- sum(sum(cluster1$Method=="SR28")>0)

  if(sum(sum(cluster1$Method=="LR28SR70")>0)){
  cluster_df[i,"LR28SR70.genome"] <- cluster1[cluster1$Method=="LR28SR70","genome"]
    }

    if(sum(sum(cluster1$Method=="LR28")>0)){
  cluster_df[i,"LR28.genome"] <- cluster1[cluster1$Method=="LR28","genome"]
    }
  
   if(sum(sum(cluster1$Method=="SR70")>0)){
 cluster_df[i,"SR70.genome"] <- cluster1[cluster1$Method=="SR70","genome"]
}

    if(sum(sum(cluster1$Method=="SR28")>0)){
 cluster_df[i,"SR28.genome"] <- cluster1[cluster1$Method=="SR28","genome"]
}
  
}

cluster_df1 <- cluster_df[rowSums(cluster_df[,3:4])>0,]

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep")
write.csv(cluster_df1, "Methods_Clusters_keep_genomes.csv", row.names=F)

