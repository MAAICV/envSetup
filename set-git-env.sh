#!/bin/bash
# cd /opt; bash -c "$(curl -fsSL https://github.com/MAAICV/envSetup/raw/master/set-git-env.sh)"
today=`date "+%Y-%m-%d"`
while true; do
    read -p "Are you sure? [y|n]" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
apt install silversearcher-ag

# backup data
tar zcf bakdata-${today}.tgz face_server/face_image* face_server/datadir

mkdir -p data/face data/food
cd data/face; mv ../../face_server/face_image* .; mv ../../face_server/models .; mv ../../face_server/face_server.ini .; cd -
cd data; mv ../face_server/datadir .; cd -

cd face_server; ./down.sh; cd -;
mv face_server face_server_tmp 
git clone git@github.com:MAAICV/face_server.git
icdiff data/face/face_server.ini face_server/face_server.ini_
./face_server/config.py data/face/face_server.ini face_server/face_server.ini_ 
rm face_server/face_server.ini_

tar zcf bakcode-${today}.tgz face_server_tmp
rm -r face_server_tmp

# cd data/food; mv ../../food_server/debug_detected_images .; mv ../../food_server/food_data .; mv ../../food_server/models .; cd -

