
## for each fasta in each sample, add the sample id and bin id to fasta header
## copy each bin to OUTDIR and rename it according to the sample it came from

DATASET=deer

INDIR=/storage/scratch/users/rj23k073/04_DEER/10_Consolidate_Bins/05_FINAL_BINS
OUTDIR=/storage/scratch/users/rj23k073/04_DEER/11_dRep/01_input_bins

cd $INDIR

for i in *deer
 do
 cd "$i"
 for j in *fa
  do
  header2=asm_$(echo "$i" | perl -pe 's/_'$DATASET'//')_$(echo "$j" | perl -pe 's/.fa//')
  rename="$i"_"$j"
  sed "s/>.*/&_$header2/" $j > "$OUTDIR"/"$rename"
  done
 cd $INDIR
done

