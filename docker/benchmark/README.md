## 介绍
Docker 的全套 Benchmark 容器只支持单机版本，主要是为了让用户熟悉 Benchamrk 流程。其中 Hdfs 文件系统用本地文件系统代替，所以确保运行目录有足够存储空间

## 使用
进入 docker/benchmark 目录下，执行：
```
    docker-compose up -d
```
即可通过 docker-compose (如果没有 docker-compose 那么需要安装)拉起全部容器，主要有 mysql，hive,ams,trino,presto,spark,lakehouse-benchmark,lakehouse-benchmark-ingestion
其中 hive 是测试 iceberg 和 hudi 时需要的，presto 是专门测试 hudi 用的。其中 lakehouse-benchmark,lakehouse-benchmark-ingestion 两个是静态容器
只有配置好的环境信息，用户需要执行特定的命令触发运行。

 - 使用如下命令进入 lakehouse-benchmark 容器。
   ```
   docker exec -it lakehouse-benchmark /bin/bash
   ```
   进入容器后执行
   ```
    java -jar /usr/lib/oltpbench/lakehouse-benchmark-21-SNAPSHOT/lakehouse-benchmark.jar -b tpcc,chbenchmark -c /usr/lib/oltpbench/lakehouse-benchmark-21-SNAPSHOT/config/mysql/sample_chbenchmark_config.xml --create=true --load=true
   ```
   生成静态数据进入 mysql。
 - 使用如下命令进入 lakehouse-benchmark-ingestion 容器。
   ```
   docker exec -it lakehouse-benchmark-ingestion /bin/bash
   ```
   .
   . 
   .
   .
 - 等 lakehouse-benchmark-ingestion 容器同步完数据以后在进入lakehouse-benchmark 容器，进行查询性能测试
   ```
   
   ```
   
   