

library(data.table)
library(dplyr)
library(tidyr)

dat <- fread("ENV8_LR_SNPS.csv", header=T, stringsAsFactors=F)
dat <- dat[dat$Method != "SR",]

dat2 <- fread("ENV10_LR_SNPS.csv", header=T, stringsAsFactors=F)
dat2 <- dat2[dat2$Method != "SR",]

all_snps <- rbind(dat,dat2)

consensus <- all_snps %>%
  group_by(bin, Scaffold, POS) %>%
  summarise(
    A_total = sum(A),
    C_total = sum(C),
    G_total = sum(G),
    T_total = sum(T),
    .groups="drop"
  ) %>%
  rowwise() %>%
  mutate(
    consensus_base = as.character(
      c("A","C","G","T")[which.max(c(A_total, C_total, G_total, T_total))]
    )
  ) %>%
  ungroup() %>%
  select(bin, Scaffold, POS, consensus_base)

head(consensus)


all_snps2 <- all_snps %>%
  left_join(consensus, by=c("bin", "Scaffold", "POS"))


env8 <- all_snps2[all_snps2$Env==8,]

env10 <- all_snps2[all_snps2$Env==10,]


