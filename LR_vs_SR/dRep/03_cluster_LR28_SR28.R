

choose_drep <- 95

setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep/02_drep",choose_drep,"/data_tables"))
cdb <- read.csv("Cdb.csv")

cdb$Method <- sub("_.*", "", cdb$genome)

table(cdb$Method)
table(table(cdb$secondary_cluster))

cluster_list <- unique(cdb$secondary_cluster)

cluster_df <- data.frame(array(NA, dim=c(length(cluster_list), 6), dimnames=list(c(),c("drep","cluster","LR28","SR28","LR28.genome","SR28.genome"))))
cluster_df$drep <- choose_drep

for(i in 1:length(cluster_list)){

  cluster1 <- cdb[cdb$secondary_cluster==cluster_list[i],]

  cluster_df[i,"cluster"] <- cluster_list[i]

 cluster_df[i,"LR28"] <- sum(sum(cluster1$Method=="LR28")>0)
 cluster_df[i,"SR28"] <- sum(sum(cluster1$Method=="SR28")>0)

  if(sum(sum(cluster1$Method=="LR28")>0)){
  cluster_df[i,"LR28.genome"] <- cluster1[cluster1$Method=="LR28","genome"]
    }
  
   if(sum(sum(cluster1$Method=="SR28")>0)){
 cluster_df[i,"SR28.genome"] <- cluster1[cluster1$Method=="SR28","genome"]
}
  
}

cluster_df1 <- cluster_df[rowSums(cluster_df[,3:4])>0,]

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep")
write.csv(cluster_df1, "Methods_LR28vSR28_Clusters.csv", row.names=F)

