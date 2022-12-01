## 介绍
Docker 的全套 Benchmark 容器只支持单机版本，主要是为了让用户熟悉 Benchmark 流程。其中 HDFS 文件系统用本地文件系统代替，所以确保运行目录有足够存储空间。相关配置文件已挂载到宿主机，修改主机中的配置文件即可同步到容器。

## 使用
本 Docker 环境使用介绍仅为引导用户进行简单入门，熟悉之后建议配合 Arctic 官方 [Benchmark流程](https://github.com/NetEase/arctic/blob/master/site/docs/ch/benchmark/benchmark-step.md) 文档以及本项目主页文档进行更为深入的测试与使用。  
进入 docker/benchmark 目录下
远程仓库 DockerHub 中已上传构建好的镜像，如需自己构建镜像需要先执行一下命令构建镜像：
```
   ./build-image.sh
```

如果不构建镜像也可以从远程仓库下载，不过需要初始化环境变量
```
   source .env
```

然后使用 docker-compose 启动容器：
```
    docker-compose up -d
```
即可通过 docker-compose (如果没有 docker-compose 那么需要安装)拉起全部容器，主要有 mysql，hive, ams, trino, presto, spark, lakehouse-benchmark, lakehouse-benchmark-ingestion
其中 hive 是测试 iceberg 和 hudi 时需要的，presto 是专门测试 hudi 用的。

 - 使用如下命令生成静态数据到 mysql :
   ```
   docker exec -it lakehouse-benchmark \
     java -jar lakehouse-benchmark.jar \
     -b tpcc,chbenchmark \
     -c config/mysql/sample_chbenchmark_config.xml \
     --create=true --load=true
   ```
   
 - 使用如下命令开启数据同步程序，将数据库的数据实时同步到数据湖
   ```
   docker exec -it lakehouse-benchmark-ingestion \
     java -cp lakehouse-benchmark-ingestion-1.0-SNAPSHOT.jar \
     com.netease.arctic.benchmark.ingestion.MainRunner \
     -confDir /usr/lib/lakehouse_benchmark_ingestion/conf \
     -sinkType [arctic/iceberg/hudi] \
     -sinkDatabase [arctic/iceberg/hudi]
   ```
   上述命令需要选择 sinkType 及 sinkDatabase 参数，命令行参数的具体说明请参考 [lakehouse-benchmark-ingestion](https://github.com/NetEase/lakehouse-benchmark-ingestion)。  
   可以通过宿主机上的 `localhost:8081` 页面打开 [Flink Web UI](http://localhost:8081)，观察数据同步情况。  
   观察 Flink Web UI ，通过 source 算子的 Records Sent 指标观察数据同步的情况，当该指标不再增加时，表示全量数据同步完成。
 - 等 lakehouse-benchmark-ingestion 容器同步完数据以后，保留此窗口以便后续使用以及观察日志。再新建一个窗口执行命令进入lakehouse-benchmark 容器，进行静态数据查询性能测试，推荐使用 Trino 进行测试：
   - Arctic
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForTrino \
       -c config/trino/trino_arctic_config.xml \
       --create=false --load=false --execute=true
     ```
   - Iceberg
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForTrino \
       -c config/trino/trino_iceberg_config.xml \
       --create=false --load=false --execute=true
     ```
   - Hudi
     ```
     docker exec -it lakehouse-benchmark \
       java -Dtpcc_name_suffix=_rt -jar lakehouse-benchmark.jar \
       -b chbenchmarkForTrino \
       -c config/trino/presto_hudi_config.xml \
       --create=false --load=false --execute=true
     ```
 - 本 Docker 环境也支持使用 Spark 进行测试：
   - Arctic
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForSpark \
       -c config/spark/spark_arctic_config.xml \
       --create=false --load=false --execute=true
     ```
   - Iceberg
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForSpark \
       -c config/spark/spark_iceberg_config.xml \
       --create=false --load=false --execute=true
     ```
   - Hudi
     ```
     docker exec -it lakehouse-benchmark \
      java -Dtpcc_name_suffix=_rt -jar lakehouse-benchmark.jar \
        -b chbenchmarkForSpark \
        -c config/spark/spark_hudi_config.xml \
        --create=false --load=false --execute=true
     ```

      
 - 上述测试的是静态数据，数据中不包含 update，delete，如果想测试动态数据需要边向 Mysql 造数据边测试查询，
   进入 lakehouse-benchmark 容器执行命令向 Mysql 里生产增量数据，这些数据会通过已经运行的数据同步工具源源不断写入数据湖：
   ```
   docker exec -it lakehouse-benchmark \
     java -jar lakehouse-benchmark.jar \
     -b tpcc,chbenchmark \
     -c config/mysql/sample_chbenchmark_config.xml \
     --execute=true -s 5
   ```
 - 再新建一个窗口，然后同时执行 TPCH 性能查询的命令 (Trino) ：
   - Arctic
     ```
     docker exec -it lakehouse-benchmark \
      java -jar lakehouse-benchmark.jar \
      -b chbenchmarkForTrino \
      -c config/trino/trino_arctic_config.xml \
      --create=false --load=false --execute=true
     ```
   - Iceberg
     ```
     docker exec -it lakehouse-benchmark \
      java -jar lakehouse-benchmark.jar \
      -b chbenchmarkForTrino \
      -c config/trino/trino_iceberg_config.xml \
      --create=false --load=false --execute=true
     ```
   - Hudi
     ```
     docker exec -it lakehouse-benchmark \
      java -Dtpcc_name_suffix=_rt -jar lakehouse-benchmark.jar \
      -b chbenchmarkForTrino \
      -c config/trino/presto_hudi_config.xml \
      --create=false --load=false --execute=true
     ```
     
 - 也可以使用 Spark ：
   - Arctic
      ```
      docker exec -it lakehouse-benchmark \
        java -jar lakehouse-benchmark.jar \
        -b chbenchmarkForSpark \
        -c config/spark/spark_arctic_config.xml \
        --create=false --load=false --execute=true
      ```
   - Iceberg
      ```
      docker exec -it lakehouse-benchmark \
        java -jar lakehouse-benchmark.jar \
        -b chbenchmarkForSpark \
        -c config/spark/spark_iceberg_config.xml \
        --create=false --load=false --execute=true
      ```
   - Hudi
     ```
     docker exec -it lakehouse-benchmark \
      java -Dtpcc_name_suffix=_rt -jar lakehouse-benchmark.jar \
        -b chbenchmarkForSpark \
        -c config/spark/spark_hudi_config.xml \
        --create=false --load=false --execute=true
     ```
## 测试结果
测试跑完以后会在 `lakehouse-benchmark` 容器 `/usr/lib/lakehouse-benchmark/` 目录下生成一个 `results` 目录，测试结果都在里面，主要关注两个文件，第一：`xxx.summary.json` 文件， 这里面的 Average Latency 项显示的是本次性能测试的平均响应时间，第二：`xxx.statistic.csv` 文件，里面记录了每个 Query 类型的最大，最小，平均耗时。