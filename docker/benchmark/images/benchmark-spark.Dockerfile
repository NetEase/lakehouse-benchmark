
FROM openjdk:8u332-jdk

ARG APACHE_MIRROR
ARG MAVEN_MIRROR
ARG SPARK_VERSION
ARG SPARK_BINARY_VERSION
ARG ARCTIC_VERSION
ARG ARCTIC_RELEASE
ARG SCALA_BINARY_VERSION

ENV SPARK_HOME=/opt/spark

RUN apt update && \
    apt-get install -y vim && \
    apt-get install -y net-tools && \
    apt-get install -y telnet && \
    apt-get install -y default-mysql-client && \
    apt-get clean

RUN wget ${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.2.tgz -C /opt && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop3.2 ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.2.tgz

RUN wget https://github.com/NetEase/arctic/releases/download/${ARCTIC_RELEASE}/arctic-spark_3.1-runtime-${ARCTIC_VERSION}.jar -P ${SPARK_HOME}/jars && \
    wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_BINARY_VERSION}_${SCALA_BINARY_VERSION}/1.0.0/iceberg-spark-runtime-${SPARK_BINARY_VERSION}_${SCALA_BINARY_VERSION}-1.0.0.jar -P ${SPARK_HOME}/jars && \
    wget https://repo1.maven.org/maven2/org/apache/hudi/hudi-spark${SPARK_BINARY_VERSION}-bundle_${SCALA_BINARY_VERSION}/0.12.1/hudi-spark${SPARK_BINARY_VERSION}-bundle_${SCALA_BINARY_VERSION}-0.12.1.jar -P ${SPARK_HOME}/jars && \
    wget https://repo1.maven.org/maven2/io/delta/delta-core_${SCALA_BINARY_VERSION}/1.0.0/delta-core_${SCALA_BINARY_VERSION}-1.0.0.jar -P ${SPARK_HOME}/jars

RUN mkdir -p -m 777 /tmp/hive
RUN mkdir -p -m 777 /tmp/arctic
WORKDIR ${SPARK_HOME}
COPY scripts/benchmark-spark-entrypoint.sh ${SPARK_HOME}
RUN chmod a+x ${SPARK_HOME}/benchmark-spark-entrypoint.sh

CMD ["bash","-c","/opt/spark/benchmark-spark-entrypoint.sh && tail -f /dev/null"]


