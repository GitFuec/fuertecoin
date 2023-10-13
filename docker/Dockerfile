FROM debian:stretch
LABEL maintainer="Fuertecoin Developers <dev@fuertecoin.org>"
LABEL description="Dockerised Fuertecoin, built from Travis"

RUN apt-get update && apt-get -y upgrade && apt-get clean && rm -fr /var/cache/apt/*

COPY bin/* /usr/bin/
