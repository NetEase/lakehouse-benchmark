
FROM trinodb/trino:380

ARG ARCTIC_VERSION=0.3.2-SNAPSHOT
ARG RELEASE=v0.3.2-rc1

WORKDIR /usr/lib/trino/plugin/arctic
#You need to download flink-1.12.2-bin-scala_2.11.tgz by yourself and put it in the same directory as Dockerfile
COPY trino-arctic-${ARCTIC_VERSION}.tar.gz ./

RUN tar -zxvf trino-arctic-${ARCTIC_VERSION}.tar.gz  \
    && rm -f trino-arctic-${ARCTIC_VERSION}.tar.gz  \
    && mv trino-arctic-${ARCTIC_VERSION}/lib/* . \
    && rm -rf trino-arctic-${ARCTIC_VERSION}

COPY local_catalog.properties /etc/trino/catalog/
COPY iceberg.properties /etc/trino/catalog/


