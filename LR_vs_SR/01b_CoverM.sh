
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

write.csv(cover_full, "DEER_v2_CoverM.csv", row.names=F)
