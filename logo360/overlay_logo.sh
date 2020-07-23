

src=/media/trolleway/2020/xiaomi360/uploaded/2g
out=$src/logo
mkdir $out

ls $src/*.JPG | parallel -j 50% --bar  convert -composite {} logo.tif -gravity center $out/{/}    

#parallel write overlay to file in subfolder

