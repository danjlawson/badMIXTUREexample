#!/bin/sh
## This script converts a PLINK bim/bed/fam file into mixPainter/badMIXTURE format.
## YOU MUST HAVE INSTALLED THE badPAINTER R PACKAGE! See https://github.com/danjlawson/badMIXTURE

## These are the tools we need. You can either put them all in your path, or update the variables with their full path
plink="plink1.9" # Available from https://www.cog-genomics.org/plink2
plink2chromopainter="plink2chromopainter.pl" # included in the finestructure download: https://people.maths.bris.ac.uk/~madjl/finestructure/finestructure.html
convertrecfile="convertrecfile.pl" # included in the finestructure download
makeuniformrecfile="makeuniformrecfile.pl" # included in the finestructure download
admixture="admixture" # available from https://www.genetics.ucla.edu/software/admixture/download.html

## Location of mixPainter; you can either specify it manually or look it up. 
mixPainter=`Rscript -e "library(badMIXTURE); cat(mixPainter())"` # This asks badMIXTURE where mixPainter is hiding on your system. You can copy it out into your path.
## Or:
## mixPainter="mixPainter" # included in badMIXTURE, but you can put it into your path.

#######################
## This script operates on two things: an input bed file and an output file name
infile="$1" ## input bed file, as you'd provide to plink
file="$2" ## Output file name
filep="$2.pruned" ## Output file name for the pruned version of the results
#######################


## Convert to ped format
$plink --geno 0 --bfile $infile --recode 12 --out $file

## Convert to ChromoPainter Format:
$plink2chromopainter -m=$file.map -p=$file.ped -o $file.phase -d=$file.ids

## Our plink file contained no recombination map. But if you have one you would convert it with:
## convertrecfile.pl -M hap $file.phase genetic_map_GRCh37_chr1.txt $file.recomb
## See convertrecfile.pl -h for details since there are lots of map formats and you need to get it right.
$makeuniformrecfile $file.phase $file.recomb ## If you don't have a map

## If you are rnuning this on a local machine, this pruning step will save you lots of compute!
## Convert and thin for unlinked mode
$plink --geno 0 --bfile $infile --indep-pairwise 50 10 0.05 --out $filep
$plink --geno 0 --bfile $infile --exclude ${filep}.prune.out --recode 12 --out $filep

## Convert to ChromoPainter Format:
$plink2chromopainter -m=$filep.map -p=$filep.ped -o $filep.phase -d=$filep.ids
## Need to create a recombination map for the thinned dataset, as above
## Our plink file contained no recombination map
#makeuniformrecfile $filep.phase $filep.recomb


## Run admixture:
time $admixture -j8 -C 0.00001 $filep.ped 11

## -c option to mixPainter specifies the number of cores. Change this to what you have available. If you omit the option, it will use all the cores on your machine
## Paint with fs3 (unlinked, pruned data)
time $mixPainter ${filep}_ul_cp -c 8 -i $filep.ids -p $filep.phase

## Paint with fs3 (linked, pruned data)
time $mixPainter ${filep}_cp -c 8 -i $filep.ids -p $filep.phase -r $filep.recomb

## Paint with fs3 (linked, complete data)
time $mixPainter ${file}_cp -c 8 -i $file.ids -p $file.phase -r $file.recomb

## Run admixture on all the data:
time $admixture  -j8 -C 0.0000001 $file.ped 11
