
Read_list <- list.files(pattern="bam")

for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0(sub("\\.bam","",reads1),"_sort_index.sh")

  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=3000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=2:50:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write (paste0("i=",reads1), sh_name, append = TRUE)
  write ("file2=$(echo $i | perl -pe 's/bam/sorted.bam/')", sh_name, append = TRUE)
   write ("samtools sort $i > $file2", sh_name, append = TRUE)
  write ("samtools index $file2", sh_name, append = TRUE)  
}
