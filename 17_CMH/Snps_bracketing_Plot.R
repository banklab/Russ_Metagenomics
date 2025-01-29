

setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/19_Diversity")
snp_df <- read.csv("Bracket_snps.csv", header=T, stringsAsFactors = F)

outlier_genes <- unique(snp_df$Gene.Outlier.Index)

setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/17_CMH")
pdf("outlier_frequencies.pdf", width = 14, height = 8.5)
for(i in 1:length(outlier_genes)){
  
  single_gene <- snp_df[snp_df$Gene.Outlier.Index==outlier_genes[i],]
  
  cat(unique(single_gene$bin),"\n")
  
  range_of_positions2 <- range(single_gene$POS)
  # cat(range_of_positions2[2] - range_of_positions2[1],"bp\n")
  if((range_of_positions2[2] - range_of_positions2[1])>1e3){stop("too large?")}
  
  snp_plot <- ggplot(single_gene, aes(Env, First.Freq, col=factor(Deer))) + geom_point() + geom_line(linetype=2, size=0.4) +
    ylim(0,1) + 
    theme_classic() +
    ylab("Allele Frequency") + xlab("Environment") +
    labs(col = "Deer") +
    scale_x_continuous(lim=c(7.5,10.5)) +
    # theme(plot.title = element_text(size=8)) +
    # ggtitle(unique(single_gene$bin)) +
    geom_hline(yintercept = 1.00, col="lightgray", lty=3) +
    geom_hline(yintercept = 0.75, col="lightgray", lty=3) +
    geom_hline(yintercept = 0.50, col="lightgray", lty=3) +
    geom_hline(yintercept = 0.25, col="lightgray", lty=3) +
    geom_hline(yintercept = 0.0, col="lightgray", lty=3) +
    geom_rect(data=single_gene[single_gene$SNP.Outlier.Index==1,],aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf), inherit.aes = FALSE, color = "red", size = 0.75, fill = NA)
  
  
  snp_plot2 <- snp_plot + facet_wrap( ~ POS, nrow=3, ncol=3)
  

  out_species <- unique(single_gene$bin)
  
  setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/17_CMH/CSV")
  cmh_data <- data.frame(fread(list.files(pattern = out_species), header=T, stringsAsFactors = F))
  cmh_data2 <- cmh_data[!is.na(cmh_data$pvalue),]
  cmh_data2$bin <- SPECIES1
  snp_count <- sum(!is.na(cmh_data2$pvalue))
  cmh_data2$logp <- log10(cmh_data2$pvalue)
  p_thresh <- quantile(cmh_data2$pvalue, q_threshold)
  cmh_data2$OUTLIER <- cmh_data2$pvalue <= p_thresh
  cmh_data2$qvalue <- p.adjust(cmh_data2$pvalue, method = "BH")
  m1_thresh <- quantile(cmh_data2$qvalue, q_threshold)
  if(m1_thresh>0.1){m1_thresh<-0.1}
  cmh_data2$M1_OUTLIER <- cmh_data2$qvalue <= m1_thresh
  if(sum(cmh_data2$M1_OUTLIER)<1){message("no outs\n");next}

  ## Annotate
  cmh_data2$method1 <- 0

  cmh_data2[cmh_data2$Scaffold==unique(single_gene$Scaffold) & cmh_data2$POS<=max(single_gene$POS) & cmh_data2$POS>=min(single_gene$POS),"method1"] <- 1
  
  cmh_data2[cmh_data2$Scaffold==unique(single_gene$Scaffold) & cmh_data2$POS == unique(single_gene[single_gene$SNP.Outlier.Index==1,"POS"]),"method1"] <- 2
  

  plot_cmh <- Q.present.manhattan.plot(cmh_data2$Scaffold, cmh_data2$POS, cmh_data2$qvalue, sig.level = m1_thresh,
                                      annotate = list(cmh_data2$method1))
  
  plot_cmh2 <- annotate_figure(plot_cmh, top = text_grob(paste0(out_species), face = "bold", size = 12))
  
  
  print(plot_cmh2)
  print(snp_plot2)
  
  ## Multiallelic outlier
  if(mean(single_gene[single_gene$SNP.Outlier.Index==1,"Third.Freq"], na.rm=T) > 0.05){
    
    snp_plot_2 <- ggplot(single_gene, aes(Env, Second.Freq, col=factor(Deer))) + geom_point() + geom_line(linetype=2, size=0.4) +
      ylim(0,1) + 
      theme_classic() +
      ylab("Allele Frequency") + xlab("Environment") +
      labs(col = "Deer") +
      scale_x_continuous(lim=c(7.5,10.5)) +
      theme(plot.title = element_text(size=8)) +
      ggtitle("1st Minor Allele Frequency") +
      geom_hline(yintercept = 1.00, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.75, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.50, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.25, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.0, col="lightgray", lty=3) +
      geom_rect(data=single_gene[single_gene$SNP.Outlier.Index==1,],aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf), inherit.aes = FALSE, color = "red", size = 0.75, fill = NA)
    
    
    snp_plot_22 <- snp_plot_2 + facet_wrap( ~ POS, nrow=3, ncol=3)
    
    snp_plot_3 <- ggplot(single_gene, aes(Env, Third.Freq, col=factor(Deer))) + geom_point() + geom_line(linetype=2, size=0.4) +
      ylim(0,1) + 
      theme_classic() +
      ylab("Allele Frequency") + xlab("Environment") +
      labs(col = "Deer") +
      scale_x_continuous(lim=c(7.5,10.5)) +
      theme(plot.title = element_text(size=8)) +
      ggtitle("2nd Minor Allele Frequency") +
      geom_hline(yintercept = 1.00, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.75, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.50, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.25, col="lightgray", lty=3) +
      geom_hline(yintercept = 0.0, col="lightgray", lty=3) +
      geom_rect(data=single_gene[single_gene$SNP.Outlier.Index==1,],aes(xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf), inherit.aes = FALSE, color = "red", size = 0.75, fill = NA)
    
    
    snp_plot_33 <- snp_plot_3 + facet_wrap( ~ POS, nrow=3, ncol=3)
    
    print(snp_plot_22)
    print(snp_plot_33)
  }
  
}
dev.off()


