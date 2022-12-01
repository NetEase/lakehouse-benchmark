#!/usr/bin/env bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Set Mirror:
# APACHE_MIRROR=mirrors.cloud.tencent.com/apache
# MAVEN_MIRROR=mirrors.cloud.tencent.com/maven


set -e

APACHE_MIRROR=${APACHE_MIRROR:-https://dlcdn.apache.org}
MAVEN_MIRROR=${MAVEN_MIRROR:-https://mirrors.cloud.tencent.com/maven}
BUILD_CMD="docker build"

if [ $BUILDX ]; then
  echo "Using buildx to build cross-platform images"
  BUILD_CMD="docker buildx build --platform=linux/amd64,linux/arm64 --push"
fi

SELF_DIR="$(cd "$(dirname "$0")"; pwd)"

source "${SELF_DIR}/.env"

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --build-arg APACHE_MIRROR=${APACHE_MIRROR} \
  --build-arg MAVEN_MIRROR=${MAVEN_MIRROR} \
  --file "${SELF_DIR}/images/benchmark-base.Dockerfile" \
  --tag arctic163/benchmark-base:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --build-arg APACHE_MIRROR=${APACHE_MIRROR} \
  --build-arg MAVEN_MIRROR=${MAVEN_MIRROR} \
  --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
  --file "${SELF_DIR}/images/benchmark-hadoop.Dockerfile" \
  --tag arctic163/benchmark-hadoop:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --build-arg APACHE_MIRROR=${APACHE_MIRROR} \
  --build-arg MAVEN_MIRROR=${MAVEN_MIRROR} \
  --build-arg HIVE_VERSION=${HIVE_VERSION} \
  --build-arg MYSQL_VERSION=${MYSQL_VERSION} \
  --file "${SELF_DIR}/images/benchmark-metastore.Dockerfile" \
  --tag arctic163/benchmark-metastore:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --build-arg MAVEN_MIRROR=${MAVEN_MIRROR} \
  --build-arg ARCTIC_VERSION=${ARCTIC_VERSION} \
  --build-arg ARCTIC_RELEASE=${ARCTIC_RELEASE} \
  --build-arg ARCTIC_HADOOP_VERSION=${ARCTIC_HADOOP_VERSION} \
  --file "${SELF_DIR}/images/benchmark-ams.Dockerfile" \
  --tag arctic163/benchmark-ams:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --file "${SELF_DIR}/images/benchmark-lakehouse.Dockerfile" \
  --tag arctic163/lakehouse-benchmark:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@


${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --file "${SELF_DIR}/images/benchmark-lakehouse-ingestion.Dockerfile" \
  --tag arctic163/benchmark-lakehouse-ingestion:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg APACHE_MIRROR=${APACHE_MIRROR} \
  --build-arg MAVEN_MIRROR=${MAVEN_MIRROR} \
  --build-arg SPARK_VERSION=${SPARK_VERSION} \
  --build-arg SPARK_BINARY_VERSION=${SPARK_BINARY_VERSION} \
  --build-arg ARCTIC_VERSION=${ARCTIC_VERSION} \
  --build-arg ARCTIC_RELEASE=${ARCTIC_RELEASE} \
  --build-arg SCALA_BINARY_VERSION=${SCALA_BINARY_VERSION} \
  --file "${SELF_DIR}/images/benchmark-spark.Dockerfile" \
  --tag arctic163/benchmark-spark:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --build-arg ARCTIC_VERSION=${ARCTIC_VERSION} \
  --build-arg ARCTIC_RELEASE=${ARCTIC_RELEASE} \
  --file "${SELF_DIR}/images/benchmark-trino.Dockerfile" \
  --tag arctic163/benchmark-trino:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@

${BUILD_CMD} \
  --build-arg BENCHMARK_VERSION=${BENCHMARK_VERSION} \
  --build-arg PRESTO_VERSION=${PRESTO_VERSION} \
  --file "${SELF_DIR}/images/benchmark-presto.Dockerfile" \
  --tag arctic163/benchmark-presto:${BENCHMARK_VERSION} \
  "${SELF_DIR}/images" $@


