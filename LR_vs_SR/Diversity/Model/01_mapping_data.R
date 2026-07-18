
pac_samps <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Mapping")
LR_stat <- read.table("LR_stats.txt", header=F)

LR_stat$Sample <- gsub("\\.stats.*","",LR_stat$V1)

LR_stat <- LR_stat[LR_stat$Sample %in% pac_samps,]

LR_stat$Deer <- as.numeric(gsub("_.*","",LR_stat$Sample))
LR_stat$Env <- as.numeric(gsub(".*_","",LR_stat$Sample))
LR_stat$Bases.mapped <- LR_stat$V4

LR_stat2 <- LR_stat[,c("Sample","Deer","Env","Bases.mapped")]


SR_stat <- read.table("SR_stats.txt", header=F)

SR_stat$Sample <- gsub("\\.stats.*","",SR_stat$V1)

SR_stat <- SR_stat[SR_stat$Sample %in% pac_samps,]

SR_stat$Deer <- as.numeric(gsub("_.*","",SR_stat$Sample))
SR_stat$Env <- as.numeric(gsub(".*_","",SR_stat$Sample))
SR_stat$Bases.mapped <- SR_stat$V4

SR_stat2 <- SR_stat[,c("Sample","Deer","Env","Bases.mapped")]

summary(LR_stat2$Bases.mapped)
summary(SR_stat2$Bases.mapped)

##

LR_flag <- fread("LR_flagstats.txt", header=F)
SR_flag <- fread("SR_flagstats.txt", header=F)

LR_flag$Sample <- gsub("\\.flag.*","",LR_flag$V1)

LR_flag <- LR_flag[LR_flag$Sample %in% pac_samps,]

LR_flag$Mapping.rate <- as.numeric(gsub("\\(|%","",LR_flag$V6))/100

LR_flag2 <- LR_flag[,c("Sample","Mapping.rate")]


SR_flag$Sample <- gsub("\\.flag.*","",SR_flag$V1)

SR_flag <- SR_flag[SR_flag$Sample %in% pac_samps,]

SR_flag$Mapping.rate <- as.numeric(gsub("\\(|%","",SR_flag$V6))/100

SR_flag2 <- SR_flag[,c("Sample","Mapping.rate")]

##


LR_good <- merge(LR_stat2,LR_flag2, by="Sample")
SR_good <- merge(SR_stat2,SR_flag2, by="Sample")

LR_good$Method <- "LR28"
SR_good$Method <- "SR28"

mapDf <- rbind(LR_good, SR_good)

write.csv(mapDf, "Mapping.rate.comparison.csv", row.names = F)
