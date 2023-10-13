#!/usr/bin/env bash

export LC_ALL=C

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/.. || exit

DOCKER_IMAGE=${DOCKER_IMAGE:-fuertecoin/fuertecoind-develop}
DOCKER_TAG=${DOCKER_TAG:-latest}

BUILD_DIR=${BUILD_DIR:-.}

rm docker/bin/*
mkdir docker/bin
cp $BUILD_DIR/src/fuertecoind docker/bin/
cp $BUILD_DIR/src/fuertecoin-cli docker/bin/
cp $BUILD_DIR/src/fuertecoin-tx docker/bin/
strip docker/bin/fuertecoind
strip docker/bin/fuertecoin-cli
strip docker/bin/fuertecoin-tx

docker build --pull -t $DOCKER_IMAGE:$DOCKER_TAG -f docker/Dockerfile docker
