#!/bin/bash

# writemp3 -- make mp3 files from original mp3

# Usage
#  writemp3 original-file {1:MPEG 1 layer 3, 2:MPEG 2 layer 3, 3:MPEG 2.5 layer3}  
#  if number is not given, treat as 1

# Author:fu7mu4

# Licence:NEW BSD LICENCE

# Var
ORGMP3=$1     # source file
MPEGVER=$2     # 1: MPEG1 Layer3 2: MPEG2 Layer3 3:MPEG3 Layer3

suffix="mp3"

modes=("j" #joint streo
       "s" #simple :force LR on all frame
       "f" #force :force MS streo on all frame
       "d" #dual mono
       "m" # mono
       # "l" #left only
       # "r" #right only
      )

if [ $MPEGVER == "1" ] ; then
    head="MPEG1.0"
    samplerates=("32" "44.1" "48")
    bitrates=("32" "96" "320") #32 40 48 56 64 80 96 112 128 160 192 224 256 320
elif [ $MPEGVER == "2" ] ; then
    head="MPEG2.0"
    samplerates=("16" "22.05" "24")
    bitrates=("8" "96" "160") #8 16 24 32 40 48 56 64 80 96 112 128 144 160
else
    head="MPEG2.5"
    samplerates=("8" "11.025" "12")
    bitrates=("8" "48" "64")
fi

vbrs=("0" "4" "9") #0 ... 9 for quality


for m in ${modes[@]} ; do
    for s in ${samplerates[@]} ; do
	for b in ${bitrates[@]} ; do
	    
	    #CBR
	    output=${head}_${m}_${s}_${b}_cbr.${suffix}
	    lame -m $m  --resample $s -v -b $b $ORGMP3 $output


	    #ABR
	    output=${head}_${m}_${s}_${b}_abr.${suffix}
	    lame -m $m --resample $s -v --abr $b $ORGMP3 $output
	    
	done

	#VBR
	for v in ${vbrs[@]} ; do
	    output=${head}_${m}_${s}_${v}_vbr.${suffix}
	    lame -m $m --resample $s -v -V $v $ORGMP3 $output
	done
    done
done
