

library(data.table)


setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/16_Taxonomy")
DF <- data.frame(fread("gtdbtk.bac120.summary.tsv", header=T, stringsAsFactors = F, sep="\t"))
DF2 <- data.frame(fread("gtdbtk.ar53.summary.tsv", header=T, stringsAsFactors = F, sep="\t"))

DF$bin <- gsub("_deer","",DF$user_genome) ## extract taxonomy information for Bacteria

DF$Domain <- gsub("d__|;p__.*","",DF$classification)
DF$Phylum <- gsub(".*p__|;c__.*","",DF$classification)
DF$Class <- gsub(".*c__|;o__.*","",DF$classification)
DF$Order <- gsub(".*o__|;f__.*","",DF$classification)
DF$Family <- gsub(".*f__|;g__.*","",DF$classification)
DF$Genus <- gsub(".*g__|;s__.*","",DF$classification)
DF$Species <- gsub(".*s__","",DF$classification)


DF2$bin <- gsub("_deer","",DF2$user_genome) ## extract taxonomy information for Archaea

DF2$Domain <- gsub("d__|;p__.*","",DF2$classification)
DF2$Phylum <- gsub(".*p__|;c__.*","",DF2$classification)
DF2$Class <- gsub(".*c__|;o__.*","",DF2$classification)
DF2$Order <- gsub(".*o__|;f__.*","",DF2$classification)
DF2$Family <- gsub(".*f__|;g__.*","",DF2$classification)
DF2$Genus <- gsub(".*g__|;s__.*","",DF2$classification)
DF2$Species <- gsub(".*s__","",DF2$classification)


full_tax <- rbind(DF,DF2)

write.csv(full_tax, "DEER_Taxonomy.csv", row.names = F)
