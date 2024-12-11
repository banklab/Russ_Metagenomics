
library(data.table)

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
genes2 <- data.frame(fread("Deer_Genes_Format.csv", header=T, stringsAsFactors = F))

genes2$Type <- "Gene"

# summary(genes2$Size)

unq_species <- unique(genes2$bin)

new_genes2 <- genes2

minimum_gene_length <- min(new_genes2$Size)
median_gene_length <- median(new_genes2[new_genes2$Type=="Gene","Size"])

for(i in 1:length(unq_species)){
  
  choose_sp <- unq_species[i]
  
  sub_genes2 <- genes2[genes2$bin==choose_sp,]
  
  unq_scaff <- unique(sub_genes2$Scaffold)
  
  for(j in 1:length(unq_scaff)){
    
    choose_scaff <- unq_scaff[j]
    
    sub_genes22 <- sub_genes2[sub_genes2$Scaffold==choose_scaff,]
    
    num_genes2 <- dim(sub_genes22)[1]
    
    scaffold_length <- unique(sub_genes22$Scaffold.length)
    
    # only 1 gene and it takes up the entire scaffold
    if(num_genes2==1 & sub_genes22$Start[1]==1 & sub_genes22$End[1]==scaffold_length){next}
    
    
    intergenic_windows <- data.frame(array(NA, dim = c(num_genes2,11), dimnames = list(c(),colnames(sub_genes22))))
    
    intergenic_windows$bin <- choose_sp
    intergenic_windows$Scaffold <- choose_scaff
    intergenic_windows$Scaffold.length <-  unique(sub_genes22$Scaffold.length)
    intergenic_windows$Scaffold.coverage <-  unique(sub_genes22$Scaffold.coverage)
    
    intergenic_windows$Type <- "Intergenic"
    
    ## make intergenic window infront of each gene
    for(k in 1:num_genes2){
      
      choose_gene <- sub_genes22[k,]
      
      ## intergenic window start
      if(k==1){
        
        if( choose_gene$Start != 1 ){ intergenic_start <- 1 } else { next } 
        
      } else {
        
        intergenic_start <- sub_genes22[k-1,"End"] +  1
        
      }
      
      
      ## intergenic window end
      intergenic_end <- sub_genes22[k,"Start"] -  1
      
      
      
      intergenic_windows[k,"Start"] <- intergenic_start
      
      intergenic_windows[k,"End"] <- intergenic_end
      
    } ## genes2
    
    
    ## add final window after last gene (goes from last gene to scaffold end)
    if(sub_genes22[num_genes2,"End"] != scaffold_length){
      
      last_window <- intergenic_windows[1,]
      
      last_window$Start <- sub_genes22[num_genes2,"End"] + 1
      last_window$End <- scaffold_length
      
      intergenic_windows <- rbind(intergenic_windows, last_window)
    }
    
    intergenic_windows[,"Size"] <- intergenic_windows[,"End"] - intergenic_windows[,"Start"]
    
    
    ## remove windows that are smaller than the minimum gene length
    
    final_windows <- intergenic_windows[!is.na(intergenic_windows$Size) & intergenic_windows$Size >= minimum_gene_length,]
    
    if(j==1){ combine_inter_windows <- final_windows } else {
      
      if(dim(final_windows)[1] > 0){ combine_inter_windows <- rbind(combine_inter_windows, final_windows) }
      
    }
    
    
  } ## scaffolds
  
  filename <- paste0(choose_sp,"_intergenic_windows.csv")
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal/Intergenic")
  write.csv(combine_inter_windows, filename, row.names = F)

  
  new_genes2 <- rbind(new_genes2, combine_inter_windows)
  
  if(i%%100==0){print(i)}
  
} ## species

new_genes2$ID <- paste0(new_genes2$bin,"_scaff",new_genes2$Scaffold,"_start",new_genes2$Start,"_end",new_genes2$End,"_type_",new_genes2$Type)

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS/DEER/13_Prodigal")
write.csv(new_genes2, "DEER_Gene_and_Intergenic.csv", row.names = F)


