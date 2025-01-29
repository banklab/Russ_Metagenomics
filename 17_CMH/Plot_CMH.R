
library(ggplot2)
library(ggpubr)
library(RColorBrewer)
library(data.table)
library(qvalue)
library(scales)


EnvA <- 8
EnvB <- 10

SNP_filter <- 20e3


q_threshold <- 1e-4 ## top 1e-4 snps
q_min_thresh <- 0.05 ## if top snps are less than this == no outliers

setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/17_CMH/CSV")
cmh_files <- list.files(pattern="CMH.csv")
snp_count <- as.numeric(gsub(".*snps|_CMH.*","",cmh_files))
cmh_files2 <- cmh_files[snp_count>=SNP_filter]


# setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/18_eggNOG")
# eggy <- data.frame(fread("Eggnog_annotations.csv", header=T, stringsAsFactors = F))
# 
# setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/13_Prodigal")
# gene_intergenic_data <- data.frame(fread("DEER_Gene_and_Intergenic.csv", header=T, stringsAsFactors = F))

median(gene_intergenic_data[gene_intergenic_data$Type=="Gene","Size"])
## median all genes 810 nt
## median for outliers ~1300 nt

setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/19_Diversity")
outlier_df <- read.csv("outlier_df.csv", header=T, stringsAsFactors = F)



qthreshold_df <- data.frame(array(NA, dim = c(length(cmh_files2),2), dimnames = list(c(),c("bin","threshold"))))


for(s in 1:length(cmh_files2)){
  
  if(s==1){c1 <- 0}
  
  
  SPECIES1 <- gsub("_Env.*","",cmh_files2[s])
  
  cat("Species:",SPECIES1,"\n")
  
  setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/17_CMH/CSV")
  cmh_data <- data.frame(fread(cmh_files2[s], header=T, stringsAsFactors = F))
  
  cmh_data2 <- cmh_data[!is.na(cmh_data$pvalue),]
  
  cmh_data2$bin <- SPECIES1
  
  snp_count <- sum(!is.na(cmh_data2$pvalue))
  
  cmh_data2$logp <- log10(cmh_data2$pvalue)
  
  p_thresh <- quantile(cmh_data2$pvalue, q_threshold)
  
  cmh_data2$OUTLIER <- cmh_data2$pvalue <= p_thresh
  
  cmh_data2$qvalue <- p.adjust(cmh_data2$pvalue, method = "BH")
  
  cmh_data2$logq <- -log10(cmh_data2$qvalue)
  
  ## take top 0.01% SNPs based on FDR, ie, no dbinom
  q_thresh <- quantile(cmh_data2$qvalue, q_threshold)
  
  if(q_thresh>q_min_thresh){q_thresh<-q_min_thresh}
  
  cmh_data2$M1_OUTLIER <- cmh_data2$qvalue <= q_thresh
  sum(cmh_data2$M1_OUTLIER )
  
  qthreshold_df[s,1] <- SPECIES1
  qthreshold_df[s,2] <- q_thresh
  
  if(sum(cmh_data2$M1_OUTLIER)<1){message("no outs\n");next}
  
  
  
  
  
  
  # sort
  cmh_data2 <- cmh_data2[order(cmh_data2$Scaffold, cmh_data2$POS), ]
  
  
  # add plotting Scaffolds (1,2,3...n)
  # cmh_data2$Scaffold_plot <- match(cmh_data2$Scaffold, unique(cmh_data2$Scaffold))
  
  
  
  # Add chromosome colours
  cmh_data2$annotate <- 0
  
  second_scaffs <- unique(cmh_data2$Scaffold)[seq(2, length(unique(cmh_data2$Scaffold)), by=2)]
  
  cmh_data2[cmh_data2$Scaffold %in% second_scaffs,"annotate"] <- 1
  
  
  
  ## Annotate outliers
  
  gene_outs <- outlier_df[outlier_df$bin==SPECIES1,]
  
  for(g in 1:dim(gene_outs)[1]){
    
    outlier_gene <- gene_outs[g,]
    
    cmh_in_outlier_gene <- cmh_data2[cmh_data2$Scaffold==outlier_gene$Scaffold & cmh_data2$POS >= outlier_gene$Start & cmh_data2$POS <  outlier_gene$End,]
    
    if(dim(cmh_in_outlier_gene)[1] < 1){message("ERROR");break}
    
    if(outlier_gene$type=="Gene"){
      cmh_data2[cmh_data2$Scaffold==outlier_gene$Scaffold & cmh_data2$POS >= outlier_gene$Start & cmh_data2$POS <  outlier_gene$End,"annotate"] <- outlier_gene$category
    }
    
    if(outlier_gene$type=="Intergenic"){
      
      ## median gene size 810 nt
      ## if intergenic outlier, highlight 810 nucleotides
      
      max_snp <- max(cmh_data2[cmh_data2$Scaffold==outlier_gene$Scaffold & cmh_data2$POS >= outlier_gene$Start & cmh_data2$POS <  outlier_gene$End,"logq"])
      
      max_pos <- cmh_data2[cmh_data2$Scaffold==outlier_gene$Scaffold & cmh_data2$POS >= outlier_gene$Start & cmh_data2$POS <  outlier_gene$End & cmh_data2$logq == max_snp,"POS"]
      
      cmh_data2[cmh_data2$Scaffold==outlier_gene$Scaffold & cmh_data2$POS >= (max_pos-405) & cmh_data2$POS <  (max_pos+405),"annotate"] <- "int"

      # old way of intergenic - chopping up intergenic windows etc - this was only relevant when I was doing dbinom
      # cmh_data2[cmh_data2$Scaffold==outlier_gene$Scaffold & cmh_data2$POS >= outlier_gene$Start & cmh_data2$POS <  outlier_gene$End,"annotate"] <- "int"
    }
    
    
  } ## loop
  
  cmh_data2$Scaffold_factor <- factor(cmh_data2$Scaffold)
  
  # cumulative position for each scaffold
  chr_offsets <- cumsum(c(0, tapply(cmh_data2$POS, cmh_data2$Scaffold_factor, max, na.rm = TRUE))[-length(levels(cmh_data2$Scaffold_factor))])
  
  cmh_data2$cum_pos <- cmh_data2$POS
  
  for (i in seq_along(levels(cmh_data2$Scaffold_factor))) {
    cmh_data2$cum_pos[cmh_data2$Scaffold_factor == levels(cmh_data2$Scaffold_factor)[i]] <- cmh_data2$cum_pos[cmh_data2$Scaffold_factor == levels(cmh_data2$Scaffold_factor)[i]] + chr_offsets[i]
  }

  
  # plot_manhattan(cmh_data2, cmh_data2$Scaffold, cmh_data2$POS, cmh_data2$qvalue, sig.level=q_thresh,
  #                ytitle=expression(-log[10](qvalue)),
  #                annotate=cmh_data2$annotate)
  # 
  # ggplot(cmh_data2, aes(x = cum_pos, y = logq, color = factor(annotate))) +
  #   geom_point(size = 1) +
  #   geom_point(data=cmh_data2[!cmh_data2$annotate %in% c("0","1"),], aes(x = cum_pos, y = logq, fill=factor(annotate)), size = 1) +
  #   scale_color_manual(values = man_cols) +
  #   # geom_hline(yintercept = -log10(sig.level), linetype = "dashed", color = "red") +
  #   # scale_x_continuous(breaks = midpoints$cum_pos, labels = midpoints$chr) +
  #   # labs(title = title, x = "Scaffold", y = ytitle) +
  #   theme_classic() +
  #   theme(legend.position = "none", panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(),
  #         panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank())
  
  
  c1 <- c1 + 1
  
  if(c1==1){ cmh_all <- cmh_data2 } else { cmh_all <- rbind(cmh_all, cmh_data2) }
  
}

length(unique(cmh_all$bin))

# plot_manhattan(cmh_all, cmh_all$Scaffold, cmh_all$POS, cmh_all$qvalue,
#                ytitle=expression(-log[10](qvalue)),
#                annotate=cmh_all$annotate)



  
cmh_by_qval <- cmh_all[order(cmh_all$qvalue),]
  
cmh_by_qval$bin2 <- factor(cmh_by_qval$bin, levels=unique(cmh_by_qval$bin))
  
qthreshold_df2 <- qthreshold_df[qthreshold_df$bin %in% levels(cmh_by_qval$bin2),]
qthreshold_df2$bin2 <- factor(qthreshold_df2$bin, levels=unique(cmh_by_qval$bin))

  ggplot(cmh_by_qval, aes(x = cum_pos, y = logq, color = factor(annotate))) +
    geom_point(size = 1, alpha=0.75) +
    geom_point(data=cmh_by_qval[!cmh_by_qval$annotate %in% c("0","1"),], aes(x = cum_pos, y = logq, fill=factor(annotate)), size = 1) +
    scale_color_manual(values = man_cols) +
    # geom_hline(data=qthreshold_df2, aes(yintercept=-log10(threshold)), linetype = "dashed", color = "red") +
    theme_classic() +
    theme(legend.position = "bottom", panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(),
          panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
          axis.text.x = element_blank()) +
    facet_wrap(~bin2, scales = "free", nrow=5, ncol=2) +
    xlab("Scaffold") + ylab(expression(-log[10](qvalue)))
  
  
setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/16_Taxonomy")
taxonomy <- data.frame(fread("DEER_Taxonomy.csv", header=T, stringsAsFactors = F))

top_species <- gsub("_Env.*","",cmh_files2)
tax_top_species <- taxonomy[taxonomy$bin %in% top_species,]

table(tax_top_species$Genus)

outlier_species <- unique(outlier_df$bin)
tax_outlier_species <- taxonomy[taxonomy$bin %in% outlier_species,]

table(tax_outlier_species$Genus)
table(tax_outlier_species$Species)

## so that I keep the order of the bins
cmh_by_qval2 <- merge(cmh_all, tax_outlier_species, by="bin")

cmh_by_qval2 <- cmh_by_qval2[order(cmh_by_qval2$qvalue),]

cmh_by_qval2$bin2 <- factor(cmh_by_qval2$bin, levels=unique(cmh_by_qval2$bin))


print(unique(paste0(cmh_by_qval2$Genus,"_",cmh_by_qval2$bin2)))

cmh_by_qval2$Genus2 <- factor(paste0(cmh_by_qval2$Genus,"_",cmh_by_qval2$bin2), levels=unique(paste0(cmh_by_qval2$Genus,"_",cmh_by_qval2$bin2)),
                              labels = c("HGM04593 sp017451695", "Cryptobacteroides sp.", "Faecousia sp. A", "Faecousia sp. B", "Faecousia sp. C", "Phocaeicola sp017467385", "Faecousia sp. D", "Phocaeicola A sp.", "Faecousia sp. E", "Faecousia sp. F"))

outlier_df$Species <- NA
for(i in 1:dim(outlier_df)[1]){
  
  outlier_df[i,"Species"] <- unique(cmh_by_qval2[outlier_df[i,"bin"] == cmh_by_qval2[,"bin"],"Genus2"])
  
}


CMH_PLOT <- ggplot(cmh_by_qval2, aes(x = cum_pos, y = logq, color = factor(annotate))) +
              geom_point(size = 1, alpha=0.75) +
              geom_point(data=cmh_by_qval2[!cmh_by_qval2$annotate %in% c("0","1"),], aes(x = cum_pos, y = logq, fill=factor(annotate)), size = 1) +
              scale_color_manual(values = man_cols) +
              # geom_hline(data=qthreshold_df2, aes(yintercept=-log10(threshold)), linetype = "dashed", color = "red") +
              theme_minimal() +
              theme(legend.position = "none", panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(),
                    panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
                    axis.text.x = element_blank(), axis.ticks.x = element_blank(),
                    panel.border = element_rect(color = "black", fill = NA, size=0.5)) +
              facet_wrap(~Genus2, scales = "free", nrow=5, ncol=2) +
              xlab("Scaffold") + ylab(expression(-log[10](qvalue)))


## split the 5x2 data up into 2
CMH1 <- cmh_by_qval2[cmh_by_qval2$Genus2 %in% unique(cmh_by_qval2$Genus2)[seq(1,9,by=2)],]
CMH2 <- cmh_by_qval2[cmh_by_qval2$Genus2 %in% unique(cmh_by_qval2$Genus2)[seq(2,10,by=2)],]

CMH_1 <- ggplot(CMH1, aes(x = cum_pos, y = logq, color = factor(annotate))) +
              geom_point(size = 1, alpha=0.75) +
              geom_point(data=CMH1[!CMH1$annotate %in% c("0","1"),], aes(x = cum_pos, y = logq, fill=factor(annotate)), size = 1) +
              scale_color_manual(values = man_cols) +
              # geom_hline(data=qthreshold_df2, aes(yintercept=-log10(threshold)), linetype = "dashed", color = "red") +
              theme_minimal() +
              theme(legend.position = "none", panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(),
                    panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
                    axis.text.x = element_blank(), axis.ticks.x = element_blank(),
                    panel.border = element_rect(color = "black", fill = NA, size=0.5)) +
              facet_wrap(~Genus2, scales = "free", nrow=5, ncol=1) +
              xlab("Scaffold") + ylab(expression(-log[10](qvalue)))

CMH_2 <- ggplot(CMH2, aes(x = cum_pos, y = logq, color = factor(annotate))) +
              geom_point(size = 1, alpha=0.75) +
              geom_point(data=CMH2[!CMH2$annotate %in% c("0","1"),], aes(x = cum_pos, y = logq, fill=factor(annotate)), size = 1) +
              scale_color_manual(values = man_cols) +
              # geom_hline(data=qthreshold_df2, aes(yintercept=-log10(threshold)), linetype = "dashed", color = "red") +
              theme_minimal() +
              theme(legend.position = "none", panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(),
                    panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
                    axis.text.x = element_blank(), axis.ticks.x = element_blank(),
                    panel.border = element_rect(color = "black", fill = NA, size=0.5)) +
              facet_wrap(~Genus2, scales = "free", nrow=5, ncol=1) +
              xlab("Scaffold") + ylab("    ")


CMH_combine <- ggarrange(CMH_1, CMH_2,
                          nrow = 1, ncol=2)
  
## FIG 3
ggarrange(CMH_combine, cmh_legend,
          ncol=1,
          heights = c(10,1))  



## first 2 are genome background
## letters are outliers
man_cols <- c("0" = "lightgrey", "1" = "darkgrey",
                "G" = "#E31A1C", "E" = "#E31A1C", "I" = "#E31A1C", "F" = "#E31A1C",
                "C" = "#33A02C", 
                "J" = "#1F78B4", "K" = "#1F78B4",
                "L" = "#FF7F00",
                "D" = "#FDBF6F",
                "M" = "#B2DF8A", #cell wall structure and biogenesis and outer membrane
                "Q" = "#6A3D9A", #Secondary metabolites biosynthesis, transport and catabolism
                "U" = "#FB9A99", #Intracellular trafficking, secretion, and vesicular transport
                "int" = "#A6CEE3",
                "S" = "#B15928", "NA" = "#B15928")

# unused

"#FFFF99" 
"#CAB2D6"



# make legend

library(cowplot)


legend_df <- cmh_by_qval2[!cmh_by_qval2$annotate %in% c(0,1),]

legend_cols <- c("Cell division, chromosome partitioning" = "#FDBF6F",
                 "Energy production and conversion" = "#33A02C",
                 "Intracellular trafficking, secretion, vesicular transport" = "#FB9A99",
                 "Macromolecule metabolism and transport" = "#E31A1C",
                 "Cell wall structure and biogenesis, outer membrane" = "#B2DF8A",
                 "Replication, recombination, repair" = "#FF7F00",
                 "Secondary metabolites biosynthesis, transport and catabolism" = "#6A3D9A",
                 "Transcription, translation, ribosome structure and biogenesis" = "#1F78B4",
                 "Intergenic region" = "#A6CEE3",
                 "Unknown" = "#B15928")


legend_plot <- ggplot(legend_df, aes(x = cum_pos, y = logq, color = factor(annotate))) +
                geom_point(size=2) +
                theme_classic() +
                theme(legend.position = "bottom", legend.text = element_text(size=8)) +
                scale_color_manual(values =legend_cols, name="")
  
cmh_legend <- get_legend(legend_plot)


plot_grid(CMH_PLOT, cmh_legend, ncol = 1)
 









## plot with only genes / intergenic

man_cols1 <- c("0" = "lightgrey", "1" = "darkgrey",
              "Gene" = "#1F78B4",
              "int" = "#A6CEE3",
              "NA" = "#1F78B4")

CMH_B <- cmh_by_qval2

CMH_B$annotate2 <- CMH_B$annotate

CMH_B[!CMH_B$annotate2 %in% c("0","1","int"),"annotate2"] <- "Gene"

CMH_BB <- CMH_B[order(CMH_B$Genus2, CMH_B$annotate2, CMH_B$Scaffold, CMH_B$POS),]

CMH1B <- CMH_BB[CMH_BB$Genus2 %in% unique(CMH_BB$Genus2)[seq(1,9,by=2)],]
CMH2B <- CMH_BB[CMH_BB$Genus2 %in% unique(CMH_BB$Genus2)[seq(1,9,by=2)],]


ggplot(CMH1B, aes(x = cum_pos, y = logq, color = factor(annotate2))) +
  geom_point(size = 1, alpha=0.75) +
  geom_point(data=CMH1B[CMH1B$annotate2 %in% c("int"),], aes(x = cum_pos, y = logq, fill=factor(annotate2)), size = 1) +
  geom_point(data=CMH1B[CMH1B$annotate2 %in% c("Gene","NA"),], aes(x = cum_pos, y = logq, fill=factor(annotate2)), size = 1) +
  geom_text(data=CMH1B[CMH1B$M1_OUTLIER,], aes(label = annotate2), vjust = -0.5, size = 3) +
  scale_color_manual(values = man_cols1) +
  theme_minimal() +
  theme(legend.position = "none", panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_blank(), panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(), axis.ticks.x = element_blank(),
        panel.border = element_rect(color = "black", fill = NA, size=0.5)) +
  facet_wrap(~Genus2, scales = "free", nrow=5, ncol=1) +
  xlab("Scaffold") + ylab(expression(-log[10](qvalue)))


