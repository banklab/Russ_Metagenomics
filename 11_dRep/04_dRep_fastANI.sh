
**fastANI algorithm = conda activate fastani

#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load Python/3.10.8-GCCcore-12.2.0
module load vital-it/7
module load SequenceAnalysis/GenePrediction/prodigal/2.6.3
module load UHTS/Analysis/Mash/2.0
dRep dereplicate dRep_ONLY_bin_ref_fastANI -g 01_Bin_Ref_Bins/*fa -comp 70 -con 10 --S_algorithm fastANI --gen_warnings -ms 10000 -pa 0.8 -sa 0.95 -nc 0.30 --genomeInfo genomeInformation_ASM_bin_ref.csv -p 16 --run_tertiary_clustering -sizeW 1
