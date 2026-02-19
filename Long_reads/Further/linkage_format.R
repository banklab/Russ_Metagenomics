
library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Linkage")

instrain_dirs <- list.files(pattern="LR_InStrain_linkage.tsv ")

for(i in 1:length(instrain_dirs)){

  sample1 <- gsub("_LR.*","",instrain_dirs[i])
  
  df <- fread(instrain_dirs[i], header=T, stringsAsFactors=F, sep="\t")

  df$SAMPLE <- sample1
  df$Deer <- as.numeric(gsub("_.*","",sample1))
  df$Env <- as.numeric(gsub(".*_","",sample1))

  if(i==1){ df2 <- df } else { df2 <- rbind(df2,df) }

}

df2$bin <- gsub(".*_asm_","",df2$scaffold)
df2$Method <- "SR"

df2[grepl("metabat|maxbin|semibin",df2$bin),"Method"] <- "LR"
df2[grepl("hybrid",df2$bin),"Method"] <- "Hy"

df2$bin <- gsub(".*metabat","Me",df2$bin)
df2$bin <- gsub(".*maxbin","Ma",df2$bin)
df2$bin <- gsub(".*semibin","Se",df2$bin)

df2$bin <- gsub("\\.fa","",paste0(df2$Method,"_",df2$bin))


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain")
write.csv(df2, "Linkage_Info_DEER_v2.csv", row.names=F)
