
library(data.table)

EnvA <- 8

EnvB <- 10


## missing sites
setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/04_Missing_REF_Sites")
for(i in 1:7){
  
  Miss_A_deer <- data.frame(fread(paste0("Miss_Env",EnvA,"_Call_Env",EnvB,"_Deer",i,".csv"), header=T, stringsAsFactors = F))
  
  Miss_B_deer <- data.frame(fread(paste0("Miss_Env",EnvB,"_Call_Env",EnvA,"_Deer",i,".csv"), header=T, stringsAsFactors = F))
  
  if(i==1){Miss_A <- Miss_A_deer
  Miss_B <- Miss_B_deer
  } else {
    Miss_A <- rbind(Miss_A, Miss_A_deer)
    Miss_B <- rbind(Miss_B, Miss_B_deer)
  }
  
}

write.csv(Miss_A, paste0("Miss_Env",EnvA,"_Call_Env",EnvB,".csv"), row.names = F)
write.csv(Miss_B, paste0("Miss_Env",EnvB,"_Call_Env",EnvA,".csv"), row.names = F)



## original data
setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/03_Formatted_Results")

Data_A <- data.frame(fread(paste0("Env",EnvA,"_snps.csv"), header=T, stringsAsFactors = F))

Data_B <- data.frame(fread(paste0("Env",EnvB,"_snps.csv"), header=T, stringsAsFactors = F))

Data_A$Original <- TRUE
Data_B$Original <- TRUE

Data_A_FULL <- rbind(Data_A, Miss_A)

Data_B_FULL <- rbind(Data_B, Miss_B)

setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Original_Sites_and_REF_Sites")
write.csv(Data_A_FULL, paste0("Env",EnvA,"x",EnvB,"_ALL_snps.csv"), row.names = F)
write.csv(Data_B_FULL, paste0("Env",EnvB,"x",EnvA,"_ALL_snps.csv"), row.names = F)

