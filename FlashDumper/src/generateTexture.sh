#/bin/bash

echo 'Starting to generate the texture'

#init params
sheet=$1;
data=$2;
path=$3;
APP_PATH=$4
EXPORT_ATF1=$5
EXPORT_ATF2=$6

tmpFolder=$path/../tmpFolderForSpriteSheet
mkdir -p $tmpFolder

echo "copy all pngs to a tmp folder without folder structure"

find  $path/ -name "*.png" -exec cp {} $tmpFolder/ \;

echo "export path:",$path

output=$path/output
if [ ! -d $path ];then
mkdir $output
fi

mv $path/*.json $output

numOfPngs=`ls -A $tmpFolder | wc -l`

if test $numOfPngs -eq 0
then
    echo 'No images found, Texture generate aborted'
    rm -r $tmpFolder
    exit 0
fi

echo 'detect if the user installed texturepacker'
/usr/bin/command -v TexturePacker >/dev/null 2>&1 || { echo "Need TexturePacker installed. Aborting." >&2; exit 1; }

echo 'find TexturePacker at: `/usr/bin/command -v TexturePacker`'

echo 'start to generate texture'

if [ -e $output/${sheet} ];then
echo 'file $output/${sheet} exists, removed.'
rm $output/${sheet}
fi

squareSize=(64 128 256 512 1024 2048)

for size in "${squareSize[@]}";
do
	echo "Try size $size * $size"
	echo "TexturePacker --width $size --height $size --sheet $output/${sheet} --data $output/${data} --format sparrow  --shape-padding 2 ${path}"
	TexturePacker --width $size --height $size --sheet $output/${sheet} --data $output/${data} --format sparrow --shape-padding 2 ${tmpFolder} 2> $path/result.txt
	if [[ ! -s $path/result.txt ]] 
	then
        break
	else  
    	rm $path/result.txt
    fi
done

pngName=$output/${sheet}

if [ "$EXPORT_ATF1" = "atf-ios" ]
then
echo 'Generating ios atf files'
echo 'Waiting, it will last seconds'
$APP_PATH/png2atf -c p -r -e -i $output/${sheet} -o ${pngName%.*}_ios.atf
fi

if [ "$EXPORT_ATF1" = "atf-android" ] || [ "$EXPORT_ATF2" = "atf-android" ]
then
echo 'Generating android atf files'
echo 'Waiting, it will last seconds'
$APP_PATH/png2atf -c e -r -e -i $output/${sheet} -o ${pngName%.*}_android.atf
fi

rm -r $tmpFolder

echo 'Generation finished'