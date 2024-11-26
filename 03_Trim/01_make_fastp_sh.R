
## choose input & output directories
INDIR="/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/raw/merged"
OUTDIR="/storage/scratch/users/rj23k073/01_RAS/03_Trim"


setwd(INDIR)

## make list of samples
Read_list <- list.files(pattern="R1.fastq.gz")


setwd(OUTDIR)


for(i in 1:length(Read_list)){ ## loop over each sample, make an sh script to trim
  
  reads1 <- Read_list[i]
  reads2 <- gsub("_R1","_R2",reads1)
  
  sub_reads <- gsub("_R1.*","",reads1)
  
  sh_name <- paste0(sub_reads,"_fastp.sh")
  
  decompress1 <- paste0("gunzip -cd ",INDIR,"/",reads1," > ",OUTDIR,"/",sub("\\.gz","",reads1)) ## decompress into output dir before input into fastp
  decompress2 <- paste0("gunzip -cd ",INDIR,"/",reads2," > ",OUTDIR,"/",sub("\\.gz","",reads2))

  ## fastp code block
  fastp_code <- paste0("fastp -w 1 -i ",OUTDIR,"/",sub("\\.gz","",reads1)," -I ",OUTDIR,"/",sub("\\.gz","",reads2)," -o ",OUTDIR,"/",sub("fastq.gz","trim.fastq",reads1)," -O ",OUTDIR,"/",sub("fastq.gz","trim.fastq",reads2)," -h ",sub_reads,"_fastp.html")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=8000M", sh_name, append = TRUE) ## adjust MEM, time, cpus etc
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=02:10:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE) ## adjust email for job finish/fail etc
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load vital-it/7", sh_name, append = TRUE) ## adjust modules as whatever server requires
  write ("module load UHTS/Quality_control/fastp/0.19.5", sh_name, append = TRUE) ## adjust modeules
  write (decompress1, sh_name, append = TRUE)
  write (decompress2, sh_name, append = TRUE)
  write (fastp_code, sh_name, append = TRUE)
  write (paste0("gzip ",OUTDIR,"/",sub("fastq.gz","trim.fastq",reads1)), sh_name, append = TRUE) ## compress fastq's after trimming
  write (paste0("gzip ",OUTDIR,"/",sub("fastq.gz","trim.fastq",reads2)), sh_name, append = TRUE)
  write (paste0("wc -l ",OUTDIR,"/",sub("\\.gz","",reads1)), sh_name, append = TRUE)
  write (paste0("wc -l ",OUTDIR,"/",sub("\\.gz","",reads2)), sh_name, append = TRUE)
  write (paste0("rm ",OUTDIR,"/",sub("\\.gz","",reads1)), sh_name, append = TRUE)
  write (paste0("rm ",OUTDIR,"/",sub("\\.gz","",reads2)), sh_name, append = TRUE)
  write ("echo 'Finished fastp'", sh_name, append = TRUE)
  
}
