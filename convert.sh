#!/bin/sh

infile="$1"
file="$2"
filep="$2.pruned"
#######################
## Convert to ped format

plink1.9 --geno 0 --bfile $infile --recode 12 --out $file

## Convert to ChromoPainter Format:
plink2chromopainter.pl -m=$file.map -p=$file.ped -o $file.phase -d=$file.ids

## Our plink file contained no recombination map
makeuniformrecfile.pl $file.phase $file.recomb

## Convert and thin for unlinked mode
plink1.9 --geno 0 --bfile $infile --indep-pairwise 50 10 0.05 --out $filep
plink1.9 --geno 0 --bfile $infile --exclude ${filep}.prune.out --recode 12 --out $filep

## Convert to ChromoPainter Format:
plink2chromopainter.pl -m=$filep.map -p=$filep.ped -o $filep.phase -d=$filep.ids
## Our plink file contained no recombination map
makeuniformrecfile.pl $filep.phase $filep.recomb


## Run admixture:
time admixture -j8 -C 0.00001 $filep.ped 11

## Paint with fs3 (unlinked)
time badPainter ${filep}_ul_cp -c 8 -i $filep.ids -p $filep.phase

## Paint with fs3 (linked)
time badPainter ${filep}_cp -c 8 -i $filep.ids -p $filep.phase -r $filep.recomb

## Paint with fs3 (linked)
time badPainter ${file}_cp -c 8 -i $file.ids -p $file.phase -r $file.recomb

## Run admixture on all the data:
time admixture  -j8 -C 0.0000001 $file.ped 11
