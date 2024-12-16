

INPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/13_Prodigal/FAA"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/18_eggNOG"

setwd(INPUT_DIR)

sample_list <- unique(gsub("_bin.*","",list.files(pattern="genes.faa")))

## may not be exactly equal to 70 - because not all samples will be good enough for genes
length(sample_list)

setwd(OUTPUT_DIR)
for(i in 1:length(sample_list)){
  
  samp2 <- sample_list[i]
  
  sh_name <- paste0(samp2,"_eggnog.sh")
  
  code_block <- paste0("emapper.py -m diamond -i $i -o $file3 --data_dir ./data/ --cpu 2")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=16000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=2", sh_name, append = TRUE)
  write ("#SBATCH --time=36:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
 write (paste0("for i in ",INPUT_DIR,"/",samp2,"*faa"), sh_name, append = TRUE)
write ("do", sh_name, append = TRUE)
 write ("file2=$(basename '$i')", sh_name, append = TRUE)
write ("file3=$(echo $file2 | perl -pe 's/faa/out/')", sh_name, append = TRUE)
 write (code_block, sh_name, append = TRUE)
 write ("echo Finished $file3", sh_name, append = TRUE)
write ("done", sh_name, append = TRUE)
  
}


