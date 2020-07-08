#!/bin/bash
if [[ $1 == "" ]]
then
    echo "Plase input compress quality!"
    exit 1
fi
if [ "$1" -gt 0 ] 2>/dev/null;then
	echo "Compress quality is "$1"."
else
	echo "First parameter must be an integer between 0 and 100."
	exit 1
fi
compressDir=$2
if [[ $2 == "" ]] 
then
	compressDir="."
    cp . -r ~/Desktop/backupImage
else
    cp $compressDir -r $compressDir""_bak
fi
picNums=`find $compressDir | grep -iE "*.jpg|*.png|*.jpeg" | wc -l`
if [[ $picNums == 0 ]]
then
	echo "No pictures found."
else
	originalPic=`find $compressDir | grep -iE "*.jpg|*.png|*.jpeg"`
	minRatio=1
	maxRatio=0
	totalRatio=0
	for i in $originalPic 
	do
		originalSize=`ls -l $i | awk '{print $5}'`
		convert -quality $1 $i $i
		compressedSize=`ls -l $i | awk '{print $5}'`
		ratio=$(printf "%.2f" `echo "scale=2;$compressedSize/$originalSize"|bc`)
		if [[ `echo "$ratio<$minRatio" | bc` == 1 ]]
		then
			minRatio=$ratio
		fi
		if [[ `echo "$ratio>$maxRatio" | bc` == 1 ]]
		then
			maxRatio=$ratio
		fi
		totalRatio=`echo "$totalRatio+$ratio"|bc`
	done
	echo "Compress finished."
	echo "Max compressed ratio : $maxRatio"
	echo "Min compressed ratio : $minRatio"
	echo "Average compressed ratio :" $(printf "%.2f" `echo "scale=2;$totalRatio/$picNums" | bc`)
fi

