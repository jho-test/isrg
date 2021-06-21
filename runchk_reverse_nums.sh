#!/bin/bash

###################################################################################################
# This is a wrapper script that will iterate through a testcase file to perform the string reversal 
# action defined in task2.sh
###################################################################################################

# Strip off any blank lines (empty, with only blanks, with only tabs) and lines starting with #
# Then loop through each valid testcase and provide as input and output string parameters to the
# task2.sh script
egrep -v '^[ 	]*$|^#' testcase2.dat | awk '{print $1, $2}' | while read strg ans;do ./task2.sh $strg $ans; done

