#!/bin/bash
path_script=$(cd "$(dirname "$0")"; pwd)
build_time=$(date "+%Y%m%d%H%M")
path_release="pika_${build_time}"

echo "path_release=$path_release"


/bin/cp -rf $path_script/version.h.template $path_script/include/pika_version.h && echo "$path_script/include/pika_version.h" | xargs /bin/sed -i "s#{{build_time}}#$build_time#g"

chmod a+x detect_environment
find ./ -name '*.sh'|xargs chmod a+x

docker container prune -f
docker volume prune -f
docker image prune -f

docker rm pika -f && docker rmi pika:latest -f

docker build -t pika . \
       && docker run --name="pika" pika:latest \
       && mkdir ./$path_release \
       && docker cp pika:/pika/output/bin ./$path_release/ \
       && cp -R ./deploy/* ./$path_release/  \
       && tar -czf ${path_release}.tar.gz $path_release \
       && rm -rf ./$path_release \
       && echo "success build the project and binary package is ${path_release}"

