#!/bin/bash

#########################################################################
# This script will take a string with characters to be reversed starting 
# with innermost matching left/right parentheses.
# EX:  Input string :  (u(love)i)
#      Output string:  iloveu
#
# The deepest left parenthesis and corresponding right parenthesis index
# values are computed.  The working string is then segmented into 3 parts.
# The middle part is reversed and then the 3 parts are re-combined.  This
# process is iterated until no further parentheses exist.  The resulting
# string is then compared to the expected output string value to determine
# SUCCESS or FAILURE.  If no expected output string is specified, then
# the resulting string value is printed to output.
#
# USAGE:  task2.sh <input_string> <expected_output_string>
#########################################################################

# Set debug=1 to print debug output.  Set debug=0 for no debugging output.
debug=0

# Confirm mandatory arg is provided
if [[ -z $1 ]];then
  echo "ERROR:  Mandatory arg is missing."
  exit 1
fi

init_str=$1
wrk_str=$init_str
output_str=$2

while [[ $wrk_str == *"("* ]];do

  # find index position of deepest leftmost left parenthesis
  sidx=`echo $wrk_str | awk 'BEGIN{ORS="\n"}{for(i=1;i<=length;i++)print substr($0,i,1)}' | awk 'BEGIN{lpcnt=0;lplevel=0;lpidx=0}{if($1=="(") lpcnt+=1; if($1==")") lpcnt-=1; if(lpcnt>lplevel){lplevel=lpcnt; lpidx=NR}}END{print lpidx}'`

  # find index position of deepest right parenthesis that corresponds with the calculated sidx value
  eidx=`echo $wrk_str | awk 'BEGIN{ORS="\n"}{for(i=1;i<=length;i++)print substr($0,i,1)}' | awk -v base=$sidx '{if(NR>base && $1==")"){rpidx=NR; exit}}END{print rpidx}'`

  # find the starting and ending index values for each of the 3 segments
  # constants:  sidx1=1, eidx3=end_of_string
  eidx1=`expr $sidx - 1`
  sidx2=`expr $sidx + 1`
  eidx2=`expr $eidx - 1`
  sidx3=`expr $eidx + 1`

  # form the character range spec for the cut command
  cstr1="1-$eidx1"
  cstr2="$sidx2-$eidx2"
  cstr3="$sidx3-"

  if [[ $debug -eq 1 ]];then
    echo "------ wrk_str = $wrk_str"
    echo "sidx = $sidx"
    echo "eidx = $eidx"
    echo "cstr1 = $cstr1"
    echo "cstr2 = $cstr2"
    echo "cstr3 = $cstr3"
  fi

  # define first segment of string
  if [[ $sidx -eq 1 ]];then
    p1=
  else
    p1=`echo $wrk_str | cut -c$cstr1`
  fi

  # define 2nd segment of string, reversed
  p2=`echo $wrk_str | cut -c$cstr2`
  p2r=`echo $p2 | awk 'BEGIN{ORS=""}{for(i=length;i>0;i--) print substr($0,i,1)}'`

  # define 3rd segment of string
  if [[ $sidx -eq 1 ]];then
    p3=
  else
    p3=`echo $wrk_str | cut -c$cstr3`
  fi

  if [[ $debug -eq 1 ]];then
    echo "p1 = $p1"
    echo "p2 = $p2"
    echo "p2r = $p2r"
    echo "p3 = $p3"
  fi

  # recombine segments after reversing substring within deepest matching parentheses
  wrk_str="$p1$p2r$p3"

done

  if [[ $debug -eq 1 ]];then
    echo "======>  RESULT: $wrk_str"
  fi


# output results for input string
if [[ -z $output_str ]];then
  echo "TESTCASE $init_str:  Result is \"$wrk_str\".  No expected output specified in testcase file."
else
  if [[ $output_str == $wrk_str ]];then
    echo "TESTCASE $init_str:  SUCCESS - Result \"$wrk_str\" matches expected output."
  else
    echo "TESTCASE $init_str:  FAILURE - Result \"$wrk_str\" does not match expected output, \"$output_str\"."
  fi  
fi

