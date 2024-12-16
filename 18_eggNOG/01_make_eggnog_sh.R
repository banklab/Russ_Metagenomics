

INUT_DIR="/storage/scratch/users/rj23k073/04_DEER/13_Prodigal/FAA"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/18_eggNOG"

setwd(INUT_DIR)

sample_list <- list.files(pattern="genes.faa")

length(sample_list)

setwd(OUTPUT_DIR)
for(i in 1:length(sample_list)){
  
  samp2 <- sample_list[i]
  
  sh_name <- paste0(gsub("\\.fa.*","",samp2),"_eggnog.sh")
  
  code_block <- paste0("emapper.py -m diamond -i ",INUT_DIR,"/",samp2," -o ",gsub("\\.fa.*","",samp2)," --data_dir ./data/ --cpu 4")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=10000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=4", sh_name, append = TRUE)
  write ("#SBATCH --time=04:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  
}


