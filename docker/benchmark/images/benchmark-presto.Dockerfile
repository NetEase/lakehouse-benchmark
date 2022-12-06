ARG PRESTO_VERSION

FROM ahanaio/prestodb-sandbox:${PRESTO_VERSION}

ARG PRESTO_VERSION

WORKDIR /opt/presto-server/plugin/hive-hadoop2

COPY ./trino-presto-config/presto-hive-0.274.1-SNAPSHOT.jar ./

RUN rm presto-hive-${PRESTO_VERSION}.jar

WORKDIR /
COPY scripts/wait-for-it.sh /
RUN chmod a+x ./wait-for-it.sh