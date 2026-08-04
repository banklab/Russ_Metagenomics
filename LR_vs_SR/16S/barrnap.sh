
## predict 16S from MAGs


for f in MAGs/*.fa
do
    base=$(basename "$f" .fa)
    barrnap --kingdom bac "$f" > "barrnap/${base}.gff"
done
