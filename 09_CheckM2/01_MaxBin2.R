INDIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/08_Binning/02_MaxBin2"
OUTDIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/09_CheckM2/02_MaxBin2"

DATASET="deer"


setwd(INDIR)

Read_list <- list.files(pattern=glob2rx(paste0("*",DATASET,"_maxbin")))

setwd(OUTDIR)
for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sub_reads1 <- sub(paste0("_",DATASET,".*"),"",reads1)
  
  sh_name <- paste0(sub_reads1,"_checkm2_maxbin2.sh")
  
  code_block <- paste0("checkm2 predict --input ",INDIR,"/",sub_reads1,"_deer_maxbin --output_directory ",sub_reads1,"_checkm2 --force -x fasta -t 1")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=60000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=03:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  
}
