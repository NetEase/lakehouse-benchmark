ARG BENCHMARK_VERSION

FROM arctic163/benchmark-base:${BENCHMARK_VERSION}

ARG ARCTIC_VERSION
ARG ARCTIC_RELEASE
ARG ARCTIC_HADOOP_VERSION

ARG MAVEN_MIRROR

ENV ARCTIC_HOME=/opt/arctic
ENV HADOOP_CONF_DIR=/etc/hadoop/conf

RUN set -x && \
    wget -q https://github.com/NetEase/arctic/releases/download/${ARCTIC_RELEASE}/arctic-${ARCTIC_VERSION}-bin.zip && \
    unzip arctic-${ARCTIC_VERSION}-bin.zip -d /opt && \
    rm arctic-${ARCTIC_VERSION}-bin.zip && \
    ln -s /opt/arctic-${ARCTIC_VERSION} ${ARCTIC_HOME}


WORKDIR ${ARCTIC_HOME}

CMD ["bash","-c","./bin/ams.sh start && tail -f /dev/null"]
