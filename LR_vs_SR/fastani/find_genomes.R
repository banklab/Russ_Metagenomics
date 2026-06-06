

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


df <- read.table("top_species_vs_SR28.txt", header=F, stringsAsFactors=F)

df$Query <- gsub(".*dereplicated_genomes/","",df$V1)

df$Subject <- gsub(".*dereplicated_genomes/","",df$V2)

df$Coverage <- df$V4 / df$V5

df$ANI <- df$V3

df[,1:5] <- NULL

df <- df[df$Coverage >= 0.5,]

## LR28SR70 --> SR28
                       Query                Subject  Coverage     ANI
13 hybrid_semibin_2_8_bin.23.fa  semibin_2_10_bin.2.fa 0.8776493 99.8912
20 hybrid_semibin_2_8_bin.24.fa semibin_2_10_bin.17.fa 0.8144159 99.7928
35 hybrid_semibin_6_8_bin.55.fa  semibin_6_8_bin.32.fa 0.7363481 99.8236



df <- read.table("top_species_vs_LR28.txt", header=F, stringsAsFactors=F)

df$Query <- gsub(".*dereplicated_genomes/","",df$V1)

df$Subject <- gsub(".*dereplicated_genomes/","",df$V2)

df$Coverage <- df$V4 / df$V5

df$ANI <- df$V3

df[,1:5] <- NULL

df <- df[df$Coverage >= 0.5,]

## LR28SR70 --> LR28
                         Query                    Subject  Coverage      ANI
1   hybrid_metabat_2_8_bin.181.fa      metabat_2_8_bin.11.fa 1.0000000 100.0000
9    hybrid_metabat_2_8_bin.89.fa     metabat_2_8_bin.289.fa 0.9775281 100.0000
17  hybrid_metabat_4_8_bin.143.fa     metabat_6_9_bin.166.fa 0.5406091  86.5241
81   hybrid_semibin_2_8_bin.23.fa      metabat_2_8_bin.43.fa 0.9971098 100.0000
89   hybrid_semibin_2_8_bin.24.fa      metabat_2_8_bin.91.fa 0.9983430 100.0000
122  hybrid_semibin_4_8_bin.39.fa     metabat_6_9_bin.166.fa 0.5814932  85.6950
154   hybrid_semibin_6_8_bin.0.fa       semibin_6_8_bin.0.fa 0.9582090 100.0000
187  hybrid_semibin_6_8_bin.55.fa      maxbin_6_8_bin.001.fa 0.9556314 100.0000
189  hybrid_semibin_6_9_bin.30.fa     semibin_6_9_bin.136.fa 0.9990347 100.0000
190  hybrid_semibin_6_9_bin.30.fa      semibin_2_8_bin.30.fa 0.5260618  83.1941
191  hybrid_semibin_6_9_bin.30.fa     semibin_6_10_bin.83.fa 0.5868726  82.6992
192  hybrid_semibin_6_9_bin.30.fa     semibin_2_10_bin.36.fa 0.5135135  82.5685
221        metabat_4_8_bin.270.fa     metabat_4_8_bin.270.fa 0.9983457 100.0000
254    metabat_6_9_bin.102_sub.fa metabat_6_9_bin.102_sub.fa 1.0000000 100.0000
255    metabat_6_9_bin.102_sub.fa     semibin_6_10_bin.83.fa 0.5005754  84.4835
283        metabat_6_9_bin.166.fa     metabat_6_9_bin.166.fa 0.9989889 100.0000
315        semibin_2_10_bin.36.fa     semibin_2_10_bin.36.fa 0.9982238 100.0000
318        semibin_2_10_bin.36.fa     semibin_6_10_bin.83.fa 0.5301954  83.1343
348        semibin_6_10_bin.83.fa     semibin_6_10_bin.83.fa 0.9958362 100.0000
