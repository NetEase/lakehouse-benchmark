# Ch-Benchmark for Data-Lake
Base on https://github.com/timveil-cockroach/oltpbench with a focus on chbenchmark for data lake. Support Trino and Presto.
## Data Lake Ch-Benchmarks
![design](benchmark-design.png)

- Generate the initial data set to mysql. The cofig of mysql is config/mysql/sample_chbenchmark_config.xml. User need to
  modify config. The param "scalefactor" is the number of  warehouses to determine the size of data. The shell to generate
  data is 
  ```
  java -jar lakehouse-benchmark.jar -b tpcc,chbenchmark -c config/mysql/sample_chbenchmark_config.xml --create=true --load=true
  ```
- Synchronize the static data from mysql to data lake through flink CDC tools [cdc-porject]()
- Turn on the TPC-C and generate incremental data to mysql. Shell is 
  ```
  java -jar lakehouse-benchmark.jar -b tpcc,chbenchmark -c config/mysql/sample_chbenchmark_config.xml --execute=true -s 5
  ```
- Perform TPC-H queries through Trino/Presto. The config of Trino/Presto is config/trino/sample_chbenchmark_config.xml, 
  The param "terminals" is the query parallelism. "works.work.time" is the 
  duration to run TPC-H query. The shell is
  ```
  java -jar lakehouse-benchmark.jar -b chbenchmarkForTrino -c config/trino/trino_chbenchmark_config.xml --create=false --load=false --execute=true
  ```

Notices:
1. Trino for Arctic and Delta-Lake, Presto for Hudi.
2. Need java 17
3. Many table will with suffix like "oorder_rt, oorder_ro, oorder#base", User can set "export tpcc_name_suffix=_rt" to config suffix. 
4. Presto jdbc client need two PR [Allow committing empty transaction](https://github.com/prestodb/presto/pull/18136), [Allow AutoCommit](https://github.com/prestodb/presto/pull/18135)
   We supply a can use client in presto-client/ dir, You need to modify and compile code by yourself when you want to use other version
5. The config trino/trino_chbenchmark_config.xml is for trino, If you use presto you need to use trino/presto_chbenchmark_config.xml:
   ```
   java -jar lakehouse-benchmark.jar -b chbenchmarkForTrino -c config/trino/presto_chbenchmark_config.xml --create=false --load=false --execute=true
   ```


## How to Build
Run the following command to build the distribution:
```bash
./mvnw clean package
```

The following files will be placed in the `./target` folder, `lakehouse-benchmark-x.y.z.tar` and `lakehouse-benchmark-x.y.z.zip`.  Pick your poison.

The resulting `.zip` or `.tar` file will have the following contents: 

```text
├── CONTRIBUTORS.md
├── LICENSE
├── README.md
├── config
│   ├── cockroachdb
│   │   ├── sample_auctionmark_config.xml
│   │   ├── sample_chbenchmark_config.xml
│   │   ├── sample_epinions_config.xml
│   │   ├── sample_noop_config.xml
│   │   ├── sample_resourcestresser_config.xml
│   │   ├── sample_seats_config.xml
│   │   ├── sample_sibench_config.xml
│   │   ├── sample_smallbank_config.xml
│   │   ├── sample_tatp_config.xml
│   │   ├── sample_tpcc_config.xml
│   │   ├── sample_tpcds_config.xml
│   │   ├── sample_tpch_config.xml
│   │   ├── sample_twitter_config.xml
│   │   ├── sample_voter_config.xml
│   │   ├── sample_wikipedia_config.xml
│   │   └── sample_ycsb_config.xml
│   ├── plugin.xml
│   └── postgres
│       └── ...
├── data
│   ├── tpch
│   │   ├── customer.tbl
│   │   ├── lineitem.tbl
│   │   ├── nation.tbl
│   │   ├── orders.tbl
│   │   ├── part.tbl
│   │   ├── partsupp.tbl
│   │   ├── region.tbl
│   │   └── supplier.tbl
│   └── twitter
│       ├── twitter_tweetids.txt
│       └── twitter_user_ids.txt
├── lib
│   └── ...
└── lakehouse-benchmark.jar
```

## How to Run
Once you build and unpack the distribution, you can run `lakehouse-benchmark` just like any other executable jar.  The following examples assume you are running from the root of the expanded `.zip` or `.tgz` distribution.  If you attempt to run `oltpbench2` outside of the distribution structure you may encounter a variety of errors including `java.lang.NoClassDefFoundError`.

To bring up help contents:
```bash
java -jar lakehouse-benchmark.jar -h
```

To execute the `tpcc` benchmark:
```bash
java -jar lakehouse-benchmark.jar -b tpcc -c config/cockroachdb/sample_tpcc_config.xml --create=true --load=true --execute=true -s 5
```

For composite benchmarks like `chbenchmark`, which require multiple schemas to be created and loaded, you can provide a comma separated list: `
```bash
java -jar lakehouse-benchmark.jar -b tpcc,chbenchmark -c config/cockroachdb/sample_chbenchmark_config.xml --create=true --load=true --execute=true -s 5
```

The following options are provided:

```text
usage: lakehouse-benchmark
 -b,--bench <arg>               [required] Benchmark class. Currently
                                supported: [tpcc, tpch, tatp, wikipedia,
                                resourcestresser, twitter, epinions, ycsb,
                                seats, auctionmark, chbenchmark, voter,
                                sibench, noop, smallbank, hyadapt]
 -c,--config <arg>              [required] Workload configuration file
    --clear <arg>               Clear all records in the database for this
                                benchmark
    --create <arg>              Initialize the database for this benchmark
 -d,--directory <arg>           Base directory for the result files,
                                default is current directory
    --dialects-export <arg>     Export benchmark SQL to a dialects file
    --execute <arg>             Execute the benchmark workload
 -h,--help                      Print this help
 -im,--interval-monitor <arg>   Throughput Monitoring Interval in
                                milliseconds
    --load <arg>                Load data using the benchmark's data
                                loader
 -s,--sample <arg>              Sampling window
```

## How to see Postgres Driver logging
To enable logging for the PostgreSQL JDBC driver, add the following JVM property when starting...
```
-Djava.util.logging.config.file=src/main/resources/logging.properties
```
To modify the logging level you can update `logging.properties`

## How to Release
```
./mvnw -B release:prepare
./mvnw -B release:perform
```
