
## BIN REFINER
DATASET=RAS

INDIR=/storage/scratch/users/rj23k073/01_RAS/10_Consolidate_Bins/05_FINAL_BINS
OUTDIR=/storage/scratch/users/rj23k073/01_RAS/11_dRep/01_Bin_Ref

cd $INDIR

for i in *RAS
 do
 cd "$i"
 for j in *fa
  do
  header2=asm_$(echo "$i" | perl -pe 's/_"$DATASET"//')_$(echo "$j" | perl -pe 's/.fa//')
  rename="$i"_"$j"
  sed "s/>.*/&_$header2/" $j > "$OUTDIR"/"$rename"
  done
 cd $INDIR
done


## DASTOOLS
DATASET=deer

INDIR=/storage/scratch/users/rj23k073/04_DEER/10_DAS_Tool
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/11_dRep/01_Pre_Bins

cd $INDIR

for i in *deer
 do
 cd "$i"/*_DASTool_bins
 for j in *fa
  do
  header2=asm_$(echo "$i" | perl -pe 's/_"$DATASET"//')_$(echo "$j" | perl -pe 's/.fa//')
  rename="$i"_"$j"
  sed "s/>.*/&_$header2/" $j > "$OUTDIR"/"$rename"
  done
 cd $INDIR
done



