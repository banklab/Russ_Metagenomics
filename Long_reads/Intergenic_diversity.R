

library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")

env8 <- fread("ENV8_LR_SNPS.csv", header=T, stringsAsFactors=F)
env10 <- fread("ENV10_LR_SNPS.csv", header=T, stringsAsFactors=F)

inter8 <- env8[env8$mutation_type=="I",]
inter10 <- env10[env10$mutation_type=="I",]

inter <- data.frame(merge(inter8,inter10, by="Sp.ID.deer"))
dim(inter)
sum(duplicated(c(inter8$Sp.ID.deer,inter10$Sp.ID.deer)))

inter$total.A <- rowSums(inter[,c("A.x","A.y")])
inter$total.C <- rowSums(inter[,c("C.x","C.y")])
inter$total.G <- rowSums(inter[,c("G.x","G.y")])
inter$total.T <- rowSums(inter[,c("T.x","T.y")])


calc.freq.function <- function(one.site) {

  alleles <- sort(unlist(one.site[c("total.A","total.C","total.G","total.T")]), decreasing=T)

  major.allele <- sub("total.","",names(alleles[1]))
  minor.allele <- sub("total.","",names(alleles[2]))

  env8.major <- as.numeric(one.site[paste0(major.allele,".x")]) / as.numeric(one.site["DP.x"])
  env10.major <- as.numeric(one.site[paste0(major.allele,".y")]) / as.numeric(one.site["DP.y"])
  env8.minor <- as.numeric(one.site[paste0(minor.allele,".x")]) / as.numeric(one.site["DP.x"])
  env10.minor <- as.numeric(one.site[paste0(minor.allele,".y")]) / as.numeric(one.site["DP.y"])

  res <- data.frame(
    major.allele=major.allele,
    env8.major.freq=env8.major,
    env10.major.freq=env10.major,
    minor.allele=minor.allele,
    env8.minor.freq=env8.minor,
    env10.minor.freq=env10.minor,
    bin=one.site["bin.x"],
    Deer=one.site["Deer.x"],
    Scaffold=one.site["Scaffold.x"],
    POS=one.site["POS.x"]
    )

    return(res)
}

Sys.time()
inter_list <- apply(inter, MARGIN=1, FUN=calc.freq.function)
Sys.time()
inter_df <- as.data.frame(do.call(rbind, inter_list))

write.csv(inter_df, "Intergenic_snps.csv", row.names=F)



