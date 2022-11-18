
FROM openjdk:17-slim

ARG VERSION=21-SNAPSHOT

RUN apt update \
    && apt-get install -y vim \
    && apt-get install -y net-tools \
    && apt-get install -y telnet \
    && apt-get install -y wget

WORKDIR /usr/lib/

RUN wget https://github.com/NetEase/lakehouse-benchmark/releases/download/21/lakehouse-benchmark-${VERSION}.tar \
    && tar -xvf lakehouse-benchmark-${VERSION}.tar \
    && rm lakehouse-benchmark-${VERSION}.tar \
    && ln -s lakehouse-benchmark-${VERSION} lakehouse-benchmark

WORKDIR /usr/lib/lakehouse-benchmark/

CMD ["/bin/bash"]


