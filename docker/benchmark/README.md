## 介绍
Docker 的全套 Benchmark 容器只支持单机版本，主要是为了让用户熟悉 Benchamrk 流程。其中 Hdfs 文件系统用本地文件系统代替，所以确保运行目录有足够存储空间

## 使用
进入 docker/benchmark 目录下
如果需要自己build镜像需要先执行
```
   ./build-image.sh
```
构建镜像
如果不构建镜像也可以从远程仓库下载，不过需要初始化环境变量
```
   source .env
```

然后使用 docker-compose 启动容器：
```
    docker-compose up -d
```
即可通过 docker-compose (如果没有 docker-compose 那么需要安装)拉起全部容器，主要有 mysql，hive,ams,trino,presto,spark,lakehouse-benchmark,lakehouse-benchmark-ingestion
其中 hive 是测试 iceberg 和 hudi 时需要的，presto 是专门测试 hudi 用的。其中 lakehouse-benchmark,lakehouse-benchmark-ingestion 两个是静态容器
只有配置好的环境信息，用户需要执行特定的命令触发运行。

 - 使用如下命令进入
   ```
   docker exec -it lakehouse-benchmark \
     java -jar lakehouse-benchmark.jar \
     -b tpcc,chbenchmark \
     -c config/mysql/sample_chbenchmark_config.xml \
     --create=true --load=true
   ```
   生成静态数据进入 mysql。
 - 使用如下命令进入
   ```
   docker exec -it benchmark-lakehouse-ingestion \
     java -cp lakehouse-benchmark-ingestion-1.0-SNAPSHOT.jar \
     com.netease.arctic.benchmark.ingestion.MainRunner \
     -confDir /usr/lib/lakehouse_benchmark_ingestion/conf \
     -sinkType [arctic/iceberg/hudi] \
     -sinkDatabase [arctic/iceberg/hudi]
   ```
   上述命令需要选择 sinkType 及 sinkDatabase 参数，命令行参数的具体说明请参考[lakehouse-benchmark-ingestion](https://github.com/NetEase/lakehouse-benchmark-ingestion)
   ingestion 服务可以通过宿主机上的localhost:8081页面打开 Flink Web UI，观察数据同步情况。
 - 等 lakehouse-benchmark-ingestion 容器同步完数据以后在进入lakehouse-benchmark 容器，进行静态数据查询性能测试
   - arctic
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForTrino \
       -c config/trino/trino_arctic_config.xml \
       --create=false --load=false --execute=true
     ```
   - iceberg
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForTrino \
       -c config/trino/trino_iceberg_config.xml \
       --create=false --load=false --execute=true
     ```
   - hudi
     ```
     docker exec -it lakehouse-benchmark \
       java -jar lakehouse-benchmark.jar \
       -b chbenchmarkForTrino \
       -c config/trino/presto_hudi_config.xml \
       --create=false --load=false --execute=true
     ```
 - 上述测试的是静态数据，数据中不包含 update，delete，如果想测试动态数据需要边向 Mysql 造数据边测试查询，进入 lakehouse-benchmark 容器
   先执行产生tpcc数据的命令：
   ```
   docker exec -it lakehouse-benchmark \
     nohup java -jar lakehouse-benchmark.jar \
     -b tpcc,chbenchmark \
     -c config/mysql/sample_chbenchmark_config.xml \
     --execute=true -s 5 >> run.log1 2>&1 &
   ```
   然后同时执行tpch性能查询的命令：
   - arctic
   ```
   docker exec -it lakehouse-benchmark \
     nohup java -jar lakehouse-benchmark.jar \
     -b chbenchmarkForTrino \
     -c config/trino/trino_arctic_config.xml \
     --create=false --load=false --execute=true >> run.log2 2>&1 &
   ```
   - iceberg
   ```
   docker exec -it lakehouse-benchmark \
     nohup java -jar lakehouse-benchmark.jar \
     -b chbenchmarkForTrino \
     -c config/trino/trino_iceberg_config.xml \
     --create=false --load=false --execute=true >> run.log2 2>&1 &
   ```
   - hudi
   ```
   docker exec -it lakehouse-benchmark \
     nohup java -jar lakehouse-benchmark.jar \
     -b chbenchmarkForTrino \
     -c config/trino/presto_hudi_config.xml \
     --create=false --load=false --execute=true >> run.log2 2>&1 &
   ```
   
 进入 lakehouse-benchmark 容器，配置放在 config 目录下，如果想要测试 hudi 需要使用 config/trino/presto_chbenchmark_config.xml 配置文件，
 如果需要测试 iceberg 等库需要修改 config/trino/trino_chbenchmark_config.xml 里面的 catalog 和 database 名称。