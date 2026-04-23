

INPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/07_Prodigal/FAA"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/11_eggNOG"

setwd(INPUT_DIR)

sample_list <- unique(gsub("_bin.*","",list.files(pattern="genes.faa")))

## may not be exactly equal to 70 (total samples in dataset) - because not all samples will be good enough for genes
length(sample_list)

setwd(OUTPUT_DIR)
for(i in 1:length(sample_list)){
  
  samp2 <- sample_list[i]
  
  sh_name <- paste0(samp2,"_eggnog.sh")

  setwd(INPUT_DIR)
  files_here <- length(list.files(pattern=glob2rx(paste0(samp2,"*faa")))) ## oops time estimate is too much for files ending in 1 (it also gets 10)
  setwd(OUTPUT_DIR)

  HOURS <- 3*as.numeric(files_here)
   
  code_block <- paste0("emapper.py -m diamond -i $i -o $file3 --data_dir /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/15_EggNOG/DATA --cpu 8")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=32000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=8", sh_name, append = TRUE)
  write (paste0("#SBATCH --time=",HOURS,":00:00"), sh_name, append = TRUE) 
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
   write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
 write (paste0("for i in ",INPUT_DIR,"/",samp2,"*faa"), sh_name, append = TRUE)
write ("do", sh_name, append = TRUE)
 write ("file2=$(basename $i)", sh_name, append = TRUE)
write ("file3=$(echo $file2 | perl -pe 's/fa.genes.faa/genes/')", sh_name, append = TRUE)
 write (code_block, sh_name, append = TRUE)
 write ("echo Finished $file3", sh_name, append = TRUE)
write ("done", sh_name, append = TRUE)
  
}
