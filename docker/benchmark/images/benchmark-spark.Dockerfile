
FROM openjdk:8u332-jdk

ARG APACHE_MIRROR
ARG MAVEN_MIRROR
ARG SPARK_VERSION
ARG SPARK_BINARY_VERSION
ARG ARCTIC_VERSION
ARG ARCTIC_RELEASE
ARG SCALA_BINARY_VERSION

ENV SPARK_HOME=/opt/spark

RUN wget ${APACHE_MIRROR}/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz && \
    tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.2.tgz -C /opt && \
    ln -s /opt/spark-${SPARK_VERSION}-bin-hadoop3.2 ${SPARK_HOME} && \
    rm spark-${SPARK_VERSION}-bin-hadoop3.2.tgz

RUN wget https://github.com/NetEase/arctic/releases/download/${ARCTIC_RELEASE}/arctic-spark-3.1-runtime-${ARCTIC_VERSION}.jar -P ${SPARK_HOME}/jars && \
    wget https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_BINARY_VERSION}_${SCALA_BINARY_VERSION}/1.0.0/iceberg-spark-runtime-${SPARK_BINARY_VERSION}_${SCALA_BINARY_VERSION}-1.0.0.jar -P ${SPARK_HOME}/jars && \
    wget https://repo1.maven.org/maven2/org/apache/hudi/hudi-spark${SPARK_BINARY_VERSION}-bundle_${SCALA_BINARY_VERSION}/0.11.1/hudi-spark${SPARK_BINARY_VERSION}-bundle_${SCALA_BINARY_VERSION}-0.11.1.jar -P ${SPARK_HOME}/jars

RUN mkdir -p -m 777 /tmp/hive
RUN mkdir -p -m 777 /tmp/arctic

COPY scripts/wait-for-it.sh /
RUN chmod a+x /wait-for-it.sh


