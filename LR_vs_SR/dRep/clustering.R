
## drep levels for CLUSTERING - this is still METHODS project ##
drep_list <- c(80,90,95,98,99)



for(j in 1:length(drep_list)){

choose_drep <- drep_list[j]

setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep/02_drep",choose_drep,"/data_tables"))
cdb <- read.csv("Cdb.csv")

cdb$Method <- sub("_.*", "", cdb$genome)

table(cdb$Method)
table(table(cdb$secondary_cluster))

cluster_list <- unique(cdb$secondary_cluster)

cluster_df <- data.frame(array(NA, dim=c(length(cluster_list), 10), dimnames=list(c(),c("drep","cluster","LR28SR70","LR28","SR70","SR28","n.LR28SR70","n.LR28","n.SR70","n.SR28"))))
cluster_df$drep <- choose_drep

for(i in 1:length(cluster_list)){

  cluster1 <- cdb[cdb$secondary_cluster==cluster_list[i],]

  cluster_df[i,"cluster"] <- cluster_list[i]

 cluster_df[i,"LR28SR70"] <- sum(sum(cluster1$Method=="LR28SR70")>0)
 cluster_df[i,"LR28"] <- sum(sum(cluster1$Method=="LR28")>0)
 cluster_df[i,"SR70"] <- sum(sum(cluster1$Method=="SR70")>0)
 cluster_df[i,"SR28"] <- sum(sum(cluster1$Method=="SR28")>0)

  cluster_df[i,"n.LR28SR70"] <- sum(cluster1$Method=="LR28SR70")
 cluster_df[i,"n.LR28"] <- sum(cluster1$Method=="LR28")
 cluster_df[i,"n.SR70"] <- sum(cluster1$Method=="SR70")
 cluster_df[i,"n.SR28"] <- sum(cluster1$Method=="SR28")

}

cat(table(table(cdb$secondary_cluster)),"\n")
cat(table(rowSums(cluster_df[,-c(1:2)])),"\n","\n")

if(j == 1){ cluster_df2 <- cluster_df } else { cluster_df2 <- rbind(cluster_df2,cluster_df) }

}

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep")
write.csv(cluster_df2, "Methods_Clusters.csv", row.names=F)
