

full <- read.table("genomes_list.txt", header=F)

files2 <- 14
size <- 400

start <- seq(1, by=size, length.out=files2)
end <- seq(size, by=size, length.out=files2)

for(i in 1:files2){
  
  indices <- c(start[i]):c(end[i])
  
  temp_df <- data.frame(full[indices,])
  
  if(i==files2){temp_df <- temp_df[complete.cases(temp_df),]}
  
  write.table(temp_df, paste0("genomes",i,".txt"), row.names = F, col.names = F, quote=F)
  
}


