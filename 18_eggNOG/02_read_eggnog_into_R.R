
library(readr)

## read eggNOG output into R
read_eggnog <- function (file){
  col_names <- c("query_name", "seed_eggNOG_ortholog", "seed_ortholog_evalue", 
                 "seed_ortholog_score", "predicted_gene_name", "GO_terms", "KEGG_KOs", 
                 "BiGG_reactions", "Annotation_tax_scope", "OGs", "bestOG_evalue_score", 
                 "COG_cat", "eggNOG_annot")
  
  read_tsv(file, col_names=col_names, comment="#")
}


setwd("/rs_scratch/users/rj23k073/04_DEER/18_eggNOG")

eggs <- list.files(pattern="annotations")

for(i in 1:length(eggs)){
  
  res <- read_eggnog(eggs[i])
  
  if(i==1){total_egg <- res} else {total_egg <- rbind(total_egg, res)}
  
}

setwd("/rs_scratch/users/rj23k073/04_DEER/18_eggNOG")
## general formatting etc
colnames(total_egg) <- c('query_name','seed_eggNOG_ortholog','seed_ortholog_evalue','seed_ortholog_score','best_tax_level','Preferred_name','GOs','EC','KEGG_ko','KEGG_Pathway','KEGG_Module','KEGG_Reaction','KEGG_rclass','BRITE','KEGG_TC','CAZy','BiGG_Reaction','taxonomic_scope','eggNOG_OGs','best_eggNOG_OG','COG_Functional_cat.','eggNOG_free_text_desc.')

total_egg$bin <- sub("_(?!.*_).*", "", gsub(".*asm_","",total_egg$query_name), perl=T)
total_egg$Scaffold <- as.integer(gsub(".*NODE_|_length.*","",total_egg$query_name))
total_egg$Gene <- gsub(".*asm_","",total_egg$query_name)

write.csv(total_egg, "Eggnog_annotations.csv", row.names = F)

