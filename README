# badMIXTUREexample: checking a mixture decomposition from PLINK data

This example runs through the process of:
0. Getting the data
1. Converting plink data to mixPainter (chromopainter) format
2. Running ADMIXTURE
3. Running mixPainter in a way that allows comparisons to the ADMIXTURE run
4. Getting the data out of mixPainter and into the badMIXTURE R package.

# Step 0: Getting the data

From a linux or mac terminal, copy the example data from our repository:

```
## Get the data
 
## For linux:
alias mywget=wget
## For mac OSX:
if [ `uname` == "Darwin" ]; then
   alias mywget="curl -O"
fi
files="Recent_admix.bim Marginalisation_admix.bim Remnants_admix.bim Remnants_admix.fam Recent_admix.fam Marginalisation_admix.fam Marginalisation_admix.bed Recent_admix.bed Remnants_admix.bed"
for file in $files; do
    mywget https://people.maths.bris.ac.uk/~madjl/finestructure/badmixture/$file
done

## Get the scripts to process the data
git clone https://github.com/danjlawson/badMIXTUREexample.git
## Note that this stage requires git. You technically don't need it; you can download the scripts manually if you would prefer.  put them in a folder called "badMIXTUREexample" under your working directory for all the paths to work correctly.
```

## Step 1a: Get all the tools you need

### badMIXTURE:

Follow the instructions at https://github.com/danjlawson/badMIXTURE. Specifically:
```
install.packages("devtools")
library(devtools)
install_github("danjlawson/badMIXTURE")
```

### External tools:

```
## These are the tools we need. You can either put them all in your path, or update the variables with their full path
plink="plink1.9" # Available from https://www.cog-genomics.org/plink2
plink2chromopainter="plink2chromopainter.pl" # included in the finestructure download: https://people.maths.bris.ac.uk/~madjl/finestructure/finestructure.html
convertrecfile="convertrecfile.pl" # included in the finestructure download
makeuniformrecfile="makeuniformrecfile.pl" # included in the finestructure download
admixture="admixture" # available from https://www.genetics.ucla.edu/software/admixture/download.html
```


# Step 1b: Creating the commands to do the conversion

```
./doprocess.sh # This generates calls to "convert.sh" that will process the three datasets.
## AT THIS POINT YOU SHOULD READ AND CHECK convert.sh!! Understanding that is the point of this exercise!
## In particular, if you just run the scripts, they will use 8 cores of your machine for several days. You might not want this!
```

## Steps 2-4: Running everything

The included script "convert.sh" explains how we did everything for the paper. The process is:
1. Run plink to convert the file to ped/map
1a. (Optionally, prune the data down to fewer SNPs)
2. Run plink2chromopainter.pl to convert to chromopainter format
3. (Optionally, create a recombination map with either makeuniformrecfile.pl or convertrecfile.pl)
4. Run mixPainter

Each of these steps is a single command.

## Additional information

ADMIXTURE takes 147m using 8 cores to process the complete dataset.  mixPainter takes 1962m using 8 cores.  They scale similarly with the number of SNPs (linearly) and the number of individuals (mixPainter is quadratic).

