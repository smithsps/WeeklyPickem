#!/bin/sh
echo "Building weekly_pickem in docker.."

docker build \
    -t weekly-pickem-jessie:build . -f Dockerfile

echo "Extracting build from docker to ./target."

mkdir -p target

docker create --name extract weekly-pickem-jessie:build 
docker cp extract:/weekly_pickem ./target
docker rm -f extract

# echo "Copying static files into new build.."
# mix phx.digest
# cp -r priv ./target/weekly_pickem/lib/weekly_pickem-*/