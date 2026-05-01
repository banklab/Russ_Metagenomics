
library(data.table)


cover_list <- list.files(pattern="\\.LR.abundance.tsv")

for(i in 1:length(cover_list)){

cov_df <- fread(cover_list[i], header=T, stringsAsFactors=F)

cov_df2 <- cov_df[cov_df$Genome != "unmapped",]

colnames(cov_df2)[2:3] <- c("CoverM.abundance","CoverM.mean")


cov_df2$Relative.Abundance <- cov_df2[,2] / sum(cov_df2[,2])

cov_df2$Sample <- gsub("\\.LR.abundance.*","",cover_list[i])

if(i==1){ cover_full <- cov_df2 } else { cover_full <- rbind(cover_full,cov_df2) }

}

cover_full$Deer <- as.numeric(gsub("_.*","",cover_full$Sample))
cover_full$Env <- as.numeric(gsub(".*_","",cover_full$Sample))

cover_full$bin <- gsub("deer_","",cover_full$Genome)

cover_full$Method <- "SR"

cover_full[grepl("metabat|maxbin|semibin",cover_full$bin),"Method"] <- "LR"
cover_full[grepl("hybrid",cover_full$bin),"Method"] <- "Hy"

cover_full$bin <- gsub(".*metabat","Me",cover_full$bin)
cover_full$bin <- gsub(".*maxbin","Ma",cover_full$bin)
cover_full$bin <- gsub(".*semibin","Se",cover_full$bin)

cover_full$bin <- paste0(cover_full$Method,"_",cover_full$bin) 

write.csv(cover_full, "DEER_v2_CoverM.csv", row.names=F)
