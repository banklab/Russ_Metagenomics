
library(data.table)
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/08_mosdepth/BED")
cov_files <- list.files(pattern="base.bed$")

## parallel by environment
cov_files <- cov_files[grepl("_1_drep",cov_files)]

for(i in 1:length(cov_files)){

cov_df <- fread(cov_files[i],stringsAsFactors=F)

colnames(cov_df) <- c("Scaffold","start","end","coverage")

cov_df$Sample <- gsub("_drep.*","",cov_files[i])
cov_df$Deer <- as.numeric(gsub("_.*","",cov_files[i]))
cov_df$Env <- as.numeric(gsub(".*_","",cov_df$Sample[1]))

cov_df$bin <- gsub(".*asm_","",cov_df$Scaffold)

cov_df$bin <- gsub(".*asm_","",cov_df$Scaffold)

cov_df$Method <- "SR"

cov_df[grepl("metabat|maxbin|semibin",cov_df$bin),"Method"] <- "LR"
cov_df[grepl("hybrid",cov_df$bin),"Method"] <- "Hy"

cov_df$bin <- gsub(".*metabat","Me",cov_df$bin)
cov_df$bin <- gsub(".*maxbin","Ma",cov_df$bin)
cov_df$bin <- gsub(".*semibin","Se",cov_df$bin)

cov_df$bin <- paste0(cov_df$Method,"_",cov_df$bin)

  
Drep_val <- gsub(".*_drep|\\.per.*","",cov_files[i])

cov_df$DREP <- as.numeric(Drep_val)
  
 if(i==1){ cov_df2 <- cov_df } else { cov_df2 <- rbind(cov_df2,cov_df) }

}

ENV <- unique(cov_df2$Env)

write.csv(cov_df2, paste0("ENV",ENV,"_temp_mosdepth.csv"), row.names=F)
