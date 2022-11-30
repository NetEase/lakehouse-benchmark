ARG BENCHMARK_VERSION
FROM arctic163/benchmark-base:${BENCHMARK_VERSION}

RUN set -x && \
    mkdir -p /usr/lib/lakehouse_benchmark_ingestion && \
    wget -q https://github.com/NetEase/lakehouse-benchmark-ingestion/releases/download/beta-1.0-arctic-0.4/lakehouse_benchmark_ingestion.tar.gz && \
    tar -xzf lakehouse_benchmark_ingestion.tar.gz -C /usr/lib/lakehouse_benchmark_ingestion && \
    rm lakehouse_benchmark_ingestion.tar.gz

WORKDIR /usr/lib/lakehouse_benchmark_ingestion/
