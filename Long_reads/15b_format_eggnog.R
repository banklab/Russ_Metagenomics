library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/15_EggNOG")

egg_files <- list.files(pattern = "annotations", full.names = TRUE)

total_egg <- rbindlist(
  lapply(egg_files, function(f) {
    dt <- fread(f, sep = "\t", header = TRUE, skip = "#query", fill = TRUE, quote = "")
    dt[, source_file := basename(f)]
    dt}), use.names = TRUE, fill = TRUE)

colnames(total_egg)[1] <- "query"

total_egg$Gene <- gsub(".*asm_","",total_egg$query)


total_egg$bin <- sub("_(?!.*_).*", "", gsub(".*asm_","",total_egg$query), perl=T)

total_egg$Method <- "SR"

total_egg[grepl("metabat|maxbin|semibin",total_egg$bin),"Method"] <- "LR"
total_egg[grepl("hybrid",total_egg$bin),"Method"] <- "Hy"

total_egg$bin <- gsub(".*metabat","Me",total_egg$bin)
total_egg$bin <- gsub(".*maxbin","Ma",total_egg$bin)
total_egg$bin <- gsub(".*semibin","Se",total_egg$bin)

total_egg$bin <- paste0(total_egg$Method,"_",total_egg$bin)

total_egg$Scaffold <- gsub(".*NODE_|_length.*|_asm.*","",total_egg$query)


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE")
genes <- fread("Gene_names.txt", header=F)

genes$query <- gsub(">| #.*","",genes$V1)

genes$XX <- sub(" # ","placeholderX",genes$V1)
genes$YY <- sub(" # ","placeholderY",genes$XX)

genes$start <- as.numeric(gsub(".*placeholderX|placeholderY.*","",genes$YY))
genes$end <- as.numeric(gsub(".*placeholderY| #.*","",genes$YY))

genes$GC <- as.numeric(gsub("gc_cont=","",genes$V6))

genes$Prodigal <- genes$V1

genes1 <- genes[,c("query","start","end","GC","Prodigal")]

total_egg2 <- merge(total_egg, genes1, by="query")

write.csv(total_egg2, "Eggnog_DEER_v2.csv", row.names = F)
