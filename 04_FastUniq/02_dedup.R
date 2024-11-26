## Adjust for loop for parallelization, ie, I have 7 deer
for(d in 1:7){

  sh_name <- paste0("FastUniq_Deer",d,".sh")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=80000M", sh_name, append = TRUE) ## adjust MEM, time, cpus etc
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=1:20:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE) ## adjust email for script finishing etc
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write (paste0("for i in ",d, "_*txt"), sh_name, append = TRUE)
  write ("do", sh_name, append = TRUE)
  write (" read1=$(echo $i | perl -pe 's/_fastq_list.txt/.R1.dedup.fastq/')", sh_name, append = TRUE) 
  write (" read2=$(echo $i | perl -pe 's/_fastq_list.txt/.R2.dedup.fastq/')", sh_name, append = TRUE)
  write (" ./fastuniq -i $i -o $read1 -p $read2", sh_name, append = TRUE) ## run FastUniq here
  write ("done", sh_name, append = TRUE)

}





