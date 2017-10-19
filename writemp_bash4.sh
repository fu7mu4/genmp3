#!/bin/bash

# writemp3 -- make mp3 files from original mp3

# Usage
#  writemp3 original-file {1:MPEG 1 layer 3, 2:MPEG 2 layer 3, 3:MPEG 2.5 layer3}  
#  if number is not given, treat as 1

# Author:fu7mu4

# Licence:NEW or Revisited BSD LICENCE

# Var
ORGMP3=$1     # source file
MPEGVER=$2     # 1: MPEG1 Layer3 2: MPEG2 Layer3 3:MPEG3 Layer3

suffix="mp3"

declare -A modes
declare -A heads
declare -A samplerates
declare -A bitrates
declare -A qualities

modes=(["m"]="mono_" ["j"]="joint" ["s"]="streo" ["f"]="force" ["d"]="dual_")
heads=(["1.0"]="MPEG1.0" ["2.0"]="MPEG2.0" ["2.5"]="MPEG2.5")

if [ $MPEGVER == "1.0" ] ; then
    samplerates=(["32"]="ls" ["44.1"]="ms" ["48"]="hs")
    bitrates=(["32"]="lb" ["96"]="mb" ["320"]="hb")
    #32 40 48 56 64 80 96 112 128 160 192 224 256 320
elif [ $MPEGVER == "2.0" ] ; then
    samplerates=(["16"]="ls" ["22.05"]="ms" ["24"]=hs)
    bitrates=(["8"]="lb" ["96"]="mb" ["160"]="hb")
    #8 16 24 32 40 48 56 64 80 96 112 128 144 160
elif [ $MPEGVER == "2.5" ] ; then
    samplerates=(["8"]="ls" ["11.025"]="ms" ["12"]="hs")
    bitrates=(["8"]="lb" ["48"]="mb" ["64"]="hb")
else
    echo "second arg must be 1.0, 2.0 or 2.5"
    exit 1
fi

qualities=(["0"]="lq" ["4"]="mq" ["9"]="hq")
# 0 1 2 3 4 5 6 7 8 9

for m in ${!modes[@]} ; do
    for s in ${!samplerates[@]} ; do
	for b in ${!bitrates[@]} ; do
	    
	    #CBR
	    output=${heads[$MPEGVER]}${modes[$m]}${samplerates[$s]}${bitrates[$b]}"CBR"${s}_${b}.${suffix}
	    lame -m $m  --resample $s -v -b $b $ORGMP3 $output


	    #ABR
	    output=${heads[$MPEGVER]}${modes[$m]}${samplerates[$s]}${bitrates[$b]}"ABR"${s}_${b}.${suffix}
	    lame -m $m --resample $s -v --abr $b $ORGMP3 $output
	    
	done

	#VBR
	for q in ${!qualities[@]} ; do
	    output=${heads[$MPEGVER]}${modes[$m]}${samplerates[$s]}${qualities[$q]}"VBR"${s}_${q}.${suffix}
	    lame -m $m --resample $s -v -V $q $ORGMP3 $output
	done
    done
done
