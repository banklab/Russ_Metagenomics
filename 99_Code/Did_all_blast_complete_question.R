

slurm_outs <- list.files(pattern = "slurm")

sample_list <- unique(gsub("sh.*","sh",slurm_outs))

check_arr <- data.frame(array(NA, dim = c(length(sample_list),2), dimnames = list(c(),c("sample","success"))))

for(i in 1:length(sample_list)){
  
  these_files <- grep(sample_list[i], slurm_outs, value=T)
  
  check_arr[i,1] <- gsub("slurm-|\\.sh","",sample_list[i])
  
  for(j in 1:length(these_files)){
    
    # test <- read.table(these_files[j])
    test <- tryCatch(read.table(these_files[j]), error = function(e) NULL)
    
    if(is.null(test)==TRUE){next}
    
    if(test$V2=="error:"){next}
    
    if(test$V1=="Finished"){check_arr[i,2]<-"TRUE"}
    
  }
  
}

check_arr[is.na(check_arr$success),]


##
total_files <- list.files(pattern = "sh$")

setdiff(sub("\\.sh","",total_files),check_arr[,1])

missing <- setdiff(sub("\\.sh","",total_files),check_arr[,1])


