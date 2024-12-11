
# command line
# cat *fna > DEER.genes.fna
# grep '>' DEER.genes.fna > Deer_Genes.txt

library(data.table)

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
genes <- data.frame(fread("Deer_Genes.txt", header=F, stringsAsFactors=F))

Gene_ids <- gsub(".*_asm_| # .*","",genes$V1)

genes$bin <- sub("_[^_]*$","",Gene_ids)
genes$Gene <- Gene_ids
genes$Scaffold <- as.numeric(gsub(".*NODE_|_length.*","",genes$V1))

genes$placeholder <- sub(" # "," !placeholder3! ", sub(" # ", " !placeholder2! ", sub(" # "," !placeholder1! ",genes$V1)))

genes$Start <- as.numeric(gsub(".* !placeholder1! | !placeholder2! .*","", genes$placeholder))
genes$End <- as.numeric(gsub(".* !placeholder2! | !placeholder3! .*","", genes$placeholder))
genes$Size <- genes$End - genes$Start + 1

genes$placeholder <- NULL


genes$GC <- as.numeric(gsub(".*gc_cont=","",genes$V6))

genes$Scaffold.length <- as.numeric(gsub(".*length_|_cov_.*","",genes$V1))
genes$Scaffold.coverage <- as.numeric(gsub(".*_cov_|_asm_.*","",genes$V1))

genes$Prodigal <- genes$V1

colnames(genes)

genes2 <- genes[,7:16]

write.csv(genes2, "Deer_Genes_Format.csv", row.names = F)

