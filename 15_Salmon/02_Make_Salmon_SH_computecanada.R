
INDIR="/home/russjasp/scratch/deer/03_Trim"
OUTDIR="/home/russjasp/scratch/deer/15_Salmon"
REF_DIR="/home/russjasp/scratch/deer/REFERENCES/dRep_ONLY_bin_ref_fastANI_index"

DATASET="deer"


setwd(INDIR)

Read_list <- list.files(pattern="R1.dedup.fastq.gz")


setwd(OUTDIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  reads2 <- gsub("_R1","_R2",reads1)
  
  sub_reads <- gsub("_R1.*","",reads1)
  
  sh_name <- paste0(sub_reads,"_Salmon.sh")
  
  code_block <- paste0("salmon quant -i ",REF_DIR," --libType IU -1 ",INDIR,"/",reads1," -2 ",INDIR,"/",reads2," -o ",OUTDIR,"/",DATASET,"_",sub_reads,".quant --meta -p 1")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=60000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=02:30:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load StdEnv/2023", sh_name, append = TRUE)
  write ("module load gcc/12.3", sh_name, append = TRUE)
  write ("module load openmpi/4.1.5", sh_name, append = TRUE)
  write ("module load salmon/1.10.2", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo 'Finished Salmon'", sh_name, append = TRUE)
  
}
