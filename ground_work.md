# Bronze


## Extra landing zones
Preliminary areas where raw data is ingested before it lands in the Medallion architecture

- might require sepecific ETL tools or deployment of integration runtime
- direct data ingestion into the Bronze layer is feasible depending on the requirements of the source system. For example, if the source system has robust security measures and stable direct ingestion techniques, it may be more efficient to bypass intermediate landing zones

## Raw data
The unprocessed data collected from various sources, which forms the basis for further transformations and analysis

- Preprocessing complex data or applying mediation happens before the data reaches the the first layer. This is not considered a transformation within the Medallion architecture.

choose between: batch processing or real-time data processing

## Batch processing 
A method of data processing where data is collected, processed, and then output in batches at scheduled

- cost-effective method
- reduce the need fo continuous processing and keeps components from running nonstop
- setting up robust error handling mechanisms is essential for the resilience of the Bronze layer


## Real-time data processing
In contrast to batch processing, this involves processing data as soon as it becomes available, enabling immediate analysis and decision making

3 options:
- park Structured Streaming

    - the continuous processing of data streams, allowing data ingestion from diverse sources such as event log files, IoT devices, and real-time messaging systems like Apache Kafka

- change data feed
    - capture changes to Delta tables as they occur, enabling you to process these changes in (near) real time.
    - set the delta.enableChangeDataFeed property to true on the Delta table

- change data capture (CDC)

    - Change data capture (CDC) is a technique employed to identify and capture changes made to data in real time.

The key takeaway for streaming and real-time data ingestion is that the decision to implement real-time data ingestion or replication, and to classify this data within the Bronze layer or an intermediate area, is fundamentally driven by distinct usage requirements and strategic objectives.




## ETL and orchestration tools
Integral for extracting, transforming, and loading data, and play a crucial role in orchestrating and automating workflows within the data ecosystem

- Apache Airflow
    - This is an open source platform that allows you to programmatically author, schedule, and monitor workflows. It’s particularly useful for orchestrating complex data pipelines and managing dependencies between tasks.
    
- Azure Data Factory
    - This is widely used among organizations that have adopted Synapse Analytics, Azure Databricks, and Microsoft Fabric. It is effective at creating, scheduling, and orchestrating data workflows. Within Microsoft Fabric, Azure Data Factory (ADF) is simply referred to as Data Factory, but the functionality largely remains the same. Another important feature of ADF is its support for numerous connectors, which enable the extraction of data from a wide variety of sources.

- Databricks Auto Loader
    - This is specifically designed for the Databricks ecosystem. It excels at incrementally processing new files as they arrive in cloud object storage. One of its standout features
    is its handling of schema evolution. We discuss Auto Loader further in Chapter 5.

- Databricks LakeFlow Connect
    - This is another Databricks-specific service. It provides built-in connectors for various sources, including Salesforce and SQL Server, facilitating data ingestion.

- Databricks Workflows
    - This is a managed orchestration service as part of Databricks. It lets you define, manage, and monitor multitask workflows for ETL, analytics, and machine learning pipelines.

- For broader compatibility and feature sets, third-party tools such as Fivetran, Qlik, StreamSets, Syncsort, Informatica, and Stitch are also popular choices. These tools offer extensive connectors and orchestration capabilities and are often used in conjunction with other tools to enhance functionality.

## Manage Delta Tables

- Z-Ordering: boosts data retrieval efficiency by grouping related information within the same files
This method ensures that your data is optimally arranged for quicker access and processing.

- V-Ordering: V-ordering is a write-time optimization for the Parquet file format. Basically, it’s an optimization that logically organizes data based on the same storage algorithm used in Power BI’s VertiPaq engine. This enables faster reads under Microsoft Fabric compute engines, such as Power BI and Warehouse. 
	•	Z-Order = Optimizes across dimensions (multi-column filtering), preserves locality
	•	V-Order = Optimizes within columns, helps with column pruning

- Table Partitioning: Table partitioning is an effective strategy for managing large datasets, typically those that are several hundred gigabytes (GBs) up to many terabytes (TBs) in size. 
    While you can combine Z-ordering and partitioning, it’s important to remember that Z-order clustering can only occur within a partition and cannot use the same field for both techniques.

- Liquid Clustering: This feature is set to replace traditional Z-ordering and partitioning. Liquid clustering simplifies the decision-making process for data layout and significantly boosts query performance by automatically optimizing the data layout. This means you no longer need to manually fine-tune the data arrangement for optimal performance.

- Compaction and Optimized Writes: Delta Lake offers an operation named OPTIMIZE , specifically engineered to address the small files problem. Over time, these smaller files accumulate and can slow down data retrieval processes. To tackle this issue, you can run an optimize job, which compacts the smaller files into larger, more manageable files, enhancing query performance.in Delta Lake version 3.1 and later. Simply set the delta.autoOptimize.optimizeWrite table property to true.

- DeltaLog: is a transaction log that carefully records every change made to data within a Delta table. This includes additions, alter statements, optimize jobs, modifications, and deletions of data. The log maintains a comprehensive history of the table and is stored as a series of JSON files in the _delta_log directory, located within the Delta table’s directory.

This feature supports crucial functions such as data auditing, rollbacks, and the replication of experiments or reports.

additional reading:
https://milescole.dev/data-engineering/2024/09/17/To-V-Order-or-Not.html