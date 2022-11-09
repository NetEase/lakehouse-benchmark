FROM ahanaio/prestodb-sandbox:0.274

WORKDIR /opt/presto-server
#You need to download flink-1.12.2-bin-scala_2.11.tgz by yourself and put it in the same directory as Dockerfile
COPY trino-presto-config/hudi.properties etc/catalog