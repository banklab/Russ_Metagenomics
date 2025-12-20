

library(data.table)


setwd("")
DF <- data.frame(fread("gtdbtk.bac120.summary.tsv", header=T, stringsAsFactors = F, sep="\t"))
DF2 <- data.frame(fread("gtdbtk.ar53.summary.tsv", header=T, stringsAsFactors = F, sep="\t"))

DF$bin <- gsub("_deer","",DF$user_genome) ## extract taxonomy information for Bacteria

DF$Method <- "SR"

DF[grepl("metabat|maxbin|semibin",DF$bin),"Method"] <- "LR"
DF[grepl("hybrid",DF$bin),"Method"] <- "Hy"

DF$bin <- gsub(".*metabat","Me",DF$bin)
DF$bin <- gsub(".*maxbin","Ma",DF$bin)
DF$bin <- gsub(".*semibin","Se",DF$bin)

DF$bin <- paste0(DF$Method,"_",DF$bin)
  

DF$Domain <- gsub("d__|;p__.*","",DF$classification)
DF$Phylum <- gsub(".*p__|;c__.*","",DF$classification)
DF$Class <- gsub(".*c__|;o__.*","",DF$classification)
DF$Order <- gsub(".*o__|;f__.*","",DF$classification)
DF$Family <- gsub(".*f__|;g__.*","",DF$classification)
DF$Genus <- gsub(".*g__|;s__.*","",DF$classification)
DF$Species <- gsub(".*s__","",DF$classification)


DF2$bin <- gsub("_deer","",DF2$user_genome) ## extract taxonomy information for Archaea

DF2$Method <- "SR"

DF2[grepl("metabat|maxbin|semibin",DF2$bin),"Method"] <- "LR"
DF2[grepl("hybrid",DF2$bin),"Method"] <- "Hy"

DF2$bin <- gsub(".*metabat","Me",DF2$bin)
DF2$bin <- gsub(".*maxbin","Ma",DF2$bin)
DF2$bin <- gsub(".*semibin","Se",DF2$bin)

DF2$bin <- paste0(DF2$Method,"_",DF2$bin)
  


DF2$Domain <- gsub("d__|;p__.*","",DF2$classification)
DF2$Phylum <- gsub(".*p__|;c__.*","",DF2$classification)
DF2$Class <- gsub(".*c__|;o__.*","",DF2$classification)
DF2$Order <- gsub(".*o__|;f__.*","",DF2$classification)
DF2$Family <- gsub(".*f__|;g__.*","",DF2$classification)
DF2$Genus <- gsub(".*g__|;s__.*","",DF2$classification)
DF2$Species <- gsub(".*s__","",DF2$classification)


full_tax <- rbind(DF,DF2)

write.csv(full_tax, "DEER_v2_Taxonomy.csv", row.names = F)
