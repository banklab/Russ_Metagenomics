
INDIR="/storage/scratch/users/rj23k073/04_DEER/03_Trim"
OUTDIR="/storage/scratch/users/rj23k073/04_DEER/15_Salmon"
REF_DIR="/storage/scratch/users/rj23k073/04_DEER/12_Alignment/NoNorm_deer_index"

DATASET="deer"


setwd(INDIR)

Read_list <- list.files(pattern="R1.trim.fastq$")


setwd(OUTDIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  reads2 <- gsub("_R1","_R2",reads1)
  
  sub_reads <- gsub("_R1.*","",reads1)
  
  sh_name <- paste0(sub_reads,"_Salmon.sh")
  
  code_block <- paste0("salmon quant -i ",REF_DIR," --libType IU -1 ",INDIR,"/",reads1," -2 ",INDIR,"/",reads2," -o ",OUTDIR,"/",DATASET,"_",sub_reads,".quant --meta -p 1")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=80000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=03:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo 'Finished Salmon'", sh_name, append = TRUE)
  
}
