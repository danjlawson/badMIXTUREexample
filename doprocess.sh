#!/bin/sh
convert="badMIXTUREexample/convert.sh"

mkdir -p painting
rm -f convert_cmds.txt
# These jobs need 8 cores
echo "convert.sh Recent_admix painting/Recent_admix &> painting/Recent_admix.log" >> convert_cmds.txt
echo "convert.sh Marginalisation_admix painting/Marginalisation_admix &> painting/Marginalisation_admix.log" >> convert_cmds.txt
echo "convert.sh Remnants_admix painting/Remnants_admix &> painting/Remnants_admix.log" >> convert_cmds.txt

echo "To run using the tools provided with finestructure, process with:"
echo "qsub_run.sh -f convert_cmds.txt -n 8 -j 1 -m 1"
echo "Or if you don't use finestructure, or you are working on a local machine:"
echo "./convert_cmds.txt"
echo "NOTE: This is slow and will use all your cores! Don't run this on your main computer unless you are happy to have it use all your CPU resource."
echo "If you are in this situation, you are better off examining convert.sh"
