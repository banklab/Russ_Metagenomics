library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/EzAAI/SR/ezaai_results")

df <- data.frame(fread(list.files(pattern="tsv"), header=T, stringsAsFactors=F))

df$Query <- paste0("SR28_",gsub(".*FAA/|\\.fa.*","",df[,3]))

df$Subject <- paste0("SR28_",gsub(".*FAA/|\\.fa.*","",df[,4]))

df$Method <- "SR28"



setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/EzAAI/LR2/ezaai_results")

df2 <- data.frame(fread(list.files(pattern="tsv"), header=T, stringsAsFactors=F))

df2$Query <- paste0("LR28_",gsub(".*FAA/|\\.fa.*","",df2[,3]))

df2$Subject <- paste0("LR28_",gsub(".*FAA/|\\.fa.*","",df2[,4]))

df2$Method <- "LR28"


ezaai_results <- rbind(df2,df)
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/EzAAI")
write.csv(ezaai_results, "EzAAI_results.csv", row.names=F)



