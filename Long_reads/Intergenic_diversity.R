

library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")

env8 <- fread("ENV8_LR_SNPS.csv", header=T, stringsAsFactors=F)
env10 <- fread("ENV10_LR_SNPS.csv", header=T, stringsAsFactors=F)

inter8 <- env8[env8$mutation_type=="I",]
inter10 <- env10[env10$mutation_type=="I",]

inter <- rbind(inter8,inter10)



calc.freq.function <- function(df, allele_cols = c("A", "C", "T", "G")) {

  counts <- as.matrix(df[, ..allele_cols])
  total  <- rowSums(counts)

  ord <- t(apply(counts, 1, order, decreasing = TRUE))

  major_idx <- ord[, 1]
  minor_idx <- ord[, 2]

  data.table::data.table(
    major_allele = allele_cols[major_idx],
    major_freq   = counts[cbind(seq_len(nrow(counts)), major_idx)] / total,
    minor_allele = allele_cols[minor_idx],
    minor_freq   = counts[cbind(seq_len(nrow(counts)), minor_idx)] / total
  )
}

Sys.time()
inter2 <- cbind(inter, calc.freq.function(inter))
Sys.time()

write.csv(inter2, "Intergenic_snps.csv", row.names=F)



