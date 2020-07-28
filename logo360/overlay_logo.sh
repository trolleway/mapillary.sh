

src=$1
out=$src/logo
mkdir $out

scriptdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

ls $src/*.JPG | parallel -j 50% --bar  convert -composite {} $scriptdir/logo.tif -gravity center $out/{/}    

#parallel write overlay to file in subfolder

