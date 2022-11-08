
FROM openjdk:17-slim

ARG VERSION=21-SNAPSHOT

RUN apt update \
    && apt-get install -y vim \
    && apt-get install -y net-tools \
    && apt-get install -y telnet

WORKDIR /usr/lib/oltpbench

COPY target/lakehouse-benchmark-${VERSION}.tar ./
RUN tar -xvf lakehouse-benchmark-${VERSION}.tar


