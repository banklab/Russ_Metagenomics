ASM_DIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly"
BAM_DIR="/storage/scratch/users/rj23k073/04_DEER/07_BAM"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/08_Binning/01_MetaBAT2"


DATASET="deer"


setwd(ASM_DIR)

Read_list <- gsub("\\.asm.*","",list.files(pattern="asm"))

setwd(OUTPUT_DIR)
for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  reads_dir <- paste0(reads1,"_metabat")
  
  sh_name <- paste0(reads1,"_metabat2.sh")
  
  code_block <- paste0("runMetaBat.sh ",ASM_DIR,"/",reads1,".asm/scaffolds_filtered.fasta ",BAM_DIR,"/",sub(paste0("_",DATASET),"",reads1),".sorted.bam")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=12000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=10", sh_name, append = TRUE)
  write ("#SBATCH --time=00:20:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load GCC/11.2.0", sh_name, append = TRUE)
  write ("export PATH=$PATH:/storage/homefs/rj23k073/metabat/bin", sh_name, append = TRUE)
  write (paste0("mkdir ",reads_dir), sh_name, append = TRUE)
  write (paste0("cd ",reads_dir), sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo Finished MetaBAT $i", sh_name, append = TRUE)
  
}
