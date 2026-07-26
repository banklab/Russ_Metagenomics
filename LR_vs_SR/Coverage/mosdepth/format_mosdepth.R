library(data.table)



setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Combined_Mapping/Genomes")
LR_unique_list <- read.table("LR_unique_list.txt", header=F, stringsAsFactors=F)
SR_unique_list <- read.table("SR_unique_list.txt", header=F, stringsAsFactors=F)
Shared_list <- read.table("Shared_good_copy_list.txt", header=F, stringsAsFactors=F)



setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Combined_Mapping/03_LR_subset/mosdepth/BED")
cov_files <- list.files(pattern=".per-base.bed$")


READS1 <- paste0(gsub(".*01_|.*02_|.*03_|.*04_|_subset.*|\\/mosdepth.*","",getwd()), "28")
REF1 <- "Combined"
if(grepl("_subset",getwd())){ REF1 <- "Subset" }


cat("Reads",READS1,"\n")
cat("Reference",REF1,"\n")



if(length(cov_files)>40){stop("aksaj")}

for(i in 1:length(cov_files)){

cov_df <- fread(cov_files[i],stringsAsFactors=F)

colnames(cov_df) <- c("Scaffold","start","end","coverage")

cov_df$Sample <- gsub("\\.per.base.*","",cov_files[i])
cov_df$Deer <- as.numeric(gsub("_.*","",cov_files[i]))
cov_df$Env <- as.numeric(gsub(".*_","",cov_df$Sample[1]))

cov_df$bin <- gsub(".*asm_","",cov_df$Scaffold)
cov_df$bin2 <- gsub(".*asm_","",cov_df$Scaffold)

cov_df$Method <- "LR28"

cov_df[grepl("NODE_",cov_df$Scaffold),"Method"] <- "SR28"


cov_df$bin2 <- gsub(".*metabat","Me",cov_df$bin2)
cov_df$bin2 <- gsub(".*maxbin","Ma",cov_df$bin2)
cov_df$bin2 <- gsub(".*semibin","Se",cov_df$bin2)

cov_df$bin <- paste0(cov_df$Method,"_",cov_df$bin)
cov_df$bin2 <- paste0(cov_df$Method,"_",cov_df$bin2)
  
 if(i==1){ cov_df2 <- cov_df } else { cov_df2 <- rbind(cov_df2,cov_df) }

cat(i,"\n")

}

cov_df2$Reads <- READS1
cov_df2$Ref <- REF1

write.csv(cov_df2,"mosdepth_TEMP.csv", row.names=F)

##

if(REF1=="Combined"){

genome_check <- gsub("\\.fa","",c(LR_unique_list[,1],SR_unique_list[,1],Shared_list[,1]))

genome_check <- sort(genome_check)

} else {

if(READS1=="LR28"){ genome_check <- gsub("\\.fa","",c(LR_unique_list[,1],Shared_list[,1])) }
if(READS1=="SR28"){ genome_check <- gsub("\\.fa","",c(SR_unique_list[,1],Shared_list[,1])) }

genome_check <- sort(genome_check)

}

##

mosdepth_genomes <- sort(unique(cov_df2$bin))

if( identical(mosdepth_genomes,genome_check)==FALSE ){stop("Different genomes error?")}

cat("num genomes",length(mosdepth_genomes),"\n")

sp_list <- mosdepth_genomes

for(ii in 1:length(sp_list)){
sp_cov <- cov_df2[cov_df2$bin==sp_list[ii],]
write.csv(sp_cov, paste0(sp_list[ii],"_mosdepth.csv"), row.names=F)
}



