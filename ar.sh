# ./ar.sh libtarget source1.a source2.o source3.lib source4.o source5.a

#! /bin/sh

AR=ar

if [ $# -lt 1 ]
then
  echo error: no parameter
	exit 1
fi

if [ $# -eq 1 ]
then
	echo error: no input file
	exit 1
fi

libtarget=$1
shift

while [ $# -ne 0 ]
do
	if [ ! -f $1 ]
	then
		echo file not exist: $1
		exit 1
	fi

	if [ ${1##*.} = "o" ]
	then
		fileo="${fileo} $1"
	elif [ ${1##*.} = "a" ] || [ ${1##*.} = "lib" ] 
	then
		filelib="${filelib} $1"
		echo $filelib
	else
		echo file format err: $1
		exit 1
	fi
	shift
done
	
#echo $fileo
#echo $filelib

if [ ! -z "$filelib" ]
then
	echo "CREATE $libtarget">>tmp
	for file in $filelib
	do
		echo "ADDLIB $file" >>tmp
	done
	echo "SAVE">>tmp
	${AR} -M <tmp
	rm tmp
fi


if [ ! -z "$fileo" ]
then
	${AR} -crs $libtarget $fileo
fi
