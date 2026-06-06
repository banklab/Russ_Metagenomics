

df <- read.table("top_species_vs_SR70.txt", header=F, stringsAsFactors=F)

df$Query <- gsub(".*dereplicated_genomes/","",df$V1)

df$Subject <- gsub(".*99_short_read_bins/","",df$V2)

df$Coverage <- df$V4 / df$V5

df$ANI <- df$V3

df[,1:5] <- NULL

df <- df[df$Coverage >= 0.5,]

## LR28SR70 --> SR70
                          Query             Subject  Coverage     ANI
1   hybrid_metabat_2_8_bin.181.fa 5_10_deer_bin.13.fa 0.5199660 97.9989
9    hybrid_metabat_2_8_bin.89.fa  5_8_deer_bin.13.fa 0.6986721 97.5729
17  hybrid_metabat_4_8_bin.143.fa  4_8_deer_bin.58.fa 0.6353638 99.8301
78   hybrid_semibin_2_8_bin.23.fa  2_10_deer_bin.9.fa 0.7967245 99.9430
89   hybrid_semibin_2_8_bin.24.fa  2_9_deer_bin.41.fa 0.6793703 99.7160
182  hybrid_semibin_6_8_bin.55.fa  6_9_deer_bin.25.fa 0.6766212 99.8288
272        metabat_6_9_bin.166.fa   6_8_deer_bin.9.fa 0.5166835 99.4674


