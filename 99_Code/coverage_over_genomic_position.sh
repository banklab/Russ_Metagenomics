


reads <- list.files(pattern="bam")

for(i in 1:length(reads)){
  
  read_var <- reads[i]
  
  sh_name <- paste0(gsub("\\.bam","",read_var),"_coverage.sh")
  
  code_block <- paste0("samtools sort ",read_var," > ",gsub("bam","sorted.bam",read_var))
  
  code_block2 <- paste0("samtools index ",gsub("bam","sorted.bam",read_var))
  
  code_block3 <- paste0("mosdepth -b 1000 ",gsub("\\.bam","",read_var), " ",gsub("bam","sorted.bam",read_var))
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=01:20:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write (code_block2, sh_name, append = TRUE)
  write (code_block3, sh_name, append = TRUE)
  
}




