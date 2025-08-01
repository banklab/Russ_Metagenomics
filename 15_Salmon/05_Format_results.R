
library(data.table)

setwd("")

dat <- fread("bin_abundance_table.tab", header=T, stringsAsFactors=F)

colnames(dat) <- gsub(" |deer_","",colnames(dat))

dat2 <- data.frame(dat)

dat2$bin <- gsub("_deer","",dat2$Genomic.bins)



samples <- colnames(dat)[-1]

for(i in 1:70){
  
  samp <- samples[i]
  
  df1 <- dat2[,c("bin",paste0("X",samp))]
  
  colnames(df1)[2] <- "Abundance"
  
  df1$Deer <- as.numeric(gsub("_.*","",samp))
  df1$Env <- as.numeric(gsub(".*_","",samp))
  df1$Sample <- samp
  
  df1$Percent <- (df1$Abundance/sum(df1$Abundance))*100 ## covert species abundances into relative abundances for a given sample
  
  if(i==1){full1 <- df1} else { full1<- rbind(full1,df1) }
}

setwd()
write.csv(full1, "", row.names = F)
