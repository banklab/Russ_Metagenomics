
library(data.table)

aa <- fread("transposase_vs_DEER_v2.out", header=F, stringsAsFactors=F)

## get species that overlap the transposase at least 1100 bp (gene is 1152nt) and are at least 90% identical
bb <- aa[aa$V4>1100 & aa$V3 >90,]


unique(bb$V2)
 [1] "s515.ctg000517l_asm_metabat_6_8_bin.102"        
 [2] "s177.ctg000179l_asm_metabat_6_8_bin.102"        
 [3] "s42.ctg000105l_asm_hybrid_semibin_2_9_bin.28"   
 [4] "s60.ctg000061c_asm_hybrid_semibin_2_8_bin.23"   
 [5] "s69.ctg000070c_asm_hybrid_semibin_2_8_bin.44"   
 [6] "s328.ctg000330l_asm_metabat_6_8_bin.102"        
 [7] "s105.ctg000106c_asm_hybrid_semibin_4_10_bin.123"
 [8] "s36.ctg000037c_asm_metabat_2_10_bin.260"        
 [9] "s19.ctg000020c_asm_maxbin_2_8_bin.002"          
[10] "s2.ctg000003c_asm_metabat_2_9_bin.149"     
