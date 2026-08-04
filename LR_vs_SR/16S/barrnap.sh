

for f in MAGs/*.fa
do
    base=$(basename "$f" .fa)
    barrnap --kingdom bac "$f" > "barrnap/${base}.gff"
done
