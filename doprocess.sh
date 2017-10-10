#!/bin/sh

mkdir -p painting
rm -f convert_cmds.txt
# These jobs need 8 cores
echo "convert.sh Recent_admix painting/Recent_admix &> painting/Recent_admix.log" >> convert_cmds.txt
echo "convert.sh Marginalisation_admix painting/Marginalisation_admix &> painting/Marginalisation_admix.log" >> convert_cmds.txt
echo "convert.sh Remnants_admix painting/Remnants_admix &> painting/Remnants_admix.log" >> convert_cmds.txt
#qsub_run.sh -f convert_cmds.txt -n 8 -j 1 -m 1
