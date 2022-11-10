# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM trinodb/trino:380

ARG ARCTIC_VERSION=0.3.2-SNAPSHOT
ARG RELEASE=v0.3.2-rc1

WORKDIR /usr/lib/trino/plugin/arctic
#You need to download trino-arctic-${ARCTIC_VERSION}.tar.gz by yourself and put it in the trino-presto-config directory
COPY trino-presto-config/trino-arctic-${ARCTIC_VERSION}.tar.gz ./

RUN tar -zxvf trino-arctic-${ARCTIC_VERSION}.tar.gz  \
    && rm -f trino-arctic-${ARCTIC_VERSION}.tar.gz  \
    && mv trino-arctic-${ARCTIC_VERSION}/lib/* . \
    && rm -rf trino-arctic-${ARCTIC_VERSION}

COPY trino-presto-config/local_catalog.properties /etc/trino/catalog/
COPY trino-presto-config/iceberg.properties /etc/trino/catalog/
COPY trino-presto-config/delta-lake.properties /etc/trino/catalog/


