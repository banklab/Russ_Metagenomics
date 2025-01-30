#!/bin/bash
#SBATCH --mem=200M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:40:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
fimo --oc collect /storage/scratch/users/rj23k073/04_DEER/20_Meme/motif_databases/PROKARYOTE/collectf.meme *fa
fimo --oc fan /storage/scratch/users/rj23k073/04_DEER/20_Meme/motif_databases/PROKARYOTE/fan2020.meme *fa
fimo --oc prodoric /storage/scratch/users/rj23k073/04_DEER/20_Meme/motif_databases/PROKARYOTE/prodoric_2021.9.meme *fa
fimo --oc regtransbase /storage/scratch/users/rj23k073/04_DEER/20_Meme/motif_databases/PROKARYOTE/regtransbase.meme *fa
