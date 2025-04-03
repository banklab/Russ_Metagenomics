

setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/19_Diversity")
outlier_df <- read.csv("outlier_df.csv", header=T, stringsAsFactors = F)

top_species <- unique(outlier_df$bin)



