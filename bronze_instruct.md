# Bronze layer

Acts as the zone for raw data collected from various sources. Data in the Bronze layer is stored in its original structure without any transformation, serving as a historical record and a single source of truth. It ensures data is reliably captured and stored, making it available for further processing.
Its key characteristics are high volume, variety, and veracity. The data is immutable to maintain the integrity of its original state.

## Processing Hierarchy

Traditional source systems often dictate the format in which data must be exported, typically using formats like CSV or JSON. Consider a legacy application that exports data only to a local file storage location. In this scenario, you would integrate the data into your Medallion architecture through batch processing.

### Processing Full Data Loads
large batches of data are typically handled at fixed intervals, often with the optional use of landing zones. After validation, the data is stored in its raw form and accumulated in folders alongside all previous data deliveries. At this stage, minimal transformations are usually performed

### Processing Incremental Data Loads
The pattern of loading increments, or “delta loads,” is often employed in scenarios where only changes or updates to the data need to be processed, allowing for more efficient data handling and reduced processing time compared to full data loads.

- append mode
    new data is added to an existing Delta table without modifying or deleting the existing data.
    This is useful for scenarios where you want to continuously add new records to a dataset, such as logging or streaming data, without affecting the existing data.

- merge operations
    perform upserts (a combination of updates and inserts) to a Delta table. This is particularly useful when you need to update existing records and insert new ones in a single operation, based on a specified condition.

    Furthermore, incremental loading is also essential for efficiently updating data in any layers, such as the Silver and Gold layers, without reprocessing the entire dataset. A consideration for incremental loading is to combine it with a change data feed to push incremental changes to your next layers.

    source system tables need to have unique incremental identifiers or updated_at columns. These markers allow you to detect any new or updated records since the last load. 

    Furthermore, it’s crucial to ensure that the source system does not update records that are older than the last fetched increment. If updates on older records are possible, standard incremental loading might miss these changes. In such cases, using CDC or similar tools might be necessary.

    Maintaining a metadata control table that tracks processed records is another recommendation. This helps manage data flow and ensures consistency, particularly in complex systems.

## Schema Evolution and Management
- Schema-on-read

This method applies the schema dynamically as you read the data. With this, data is stored without a strict schema in place. The schema is only inferred or applied when the data is accessed during processing (reading). This flexible approach requires the system to recognize and possibly adapt to various data schemas right after the point of ingestion. This approach is particularly useful for semi- structured or unstructured data or structured data without any built-in schema enforcement, such as CSV or Parquet files.

- Schema-on-write
This approach involves defining the schema—like the table and column names, the data types, and the primary keys—as you write the data into storage. With this method, you must define the schema up front, making sure that the data conforms to this schema right from the start, before writing. It’s a more rigid approach compared to schema-on-read, as it enforces schema consistency from the beginning. When applied, it’s generally used for structured data.
When using Delta Lake, if there is no predefined schema, the system will establish an initial schema by using the
StructType from the DataFrame that is being converted to Delta format. In Apache Spark, StructType refers to a container that defines the structure and types of columns in a DataFrame.


In the Bronze layer, schema-on-read is a common approach where data is stored in its original format without enforcing a schema during ingestion. 

Secondly, defining a data update method is essential, especially for historization and integration of data. Options include continuously appending to or merging with existing datasets, completely overwriting them, or applying time-based partitioning. 
For instance, appending is commonly used for transactional data because this type of data grows incrementally with each new transaction. 

Overwriting might be chosen for datasets that receive regular source corrections, or where only the most recent data snapshot is relevant. 

Time-based partitioning can be implemented to enhance query performance and manage large datasets effectively, especially when data access is time-sensitive.

Therefore, the Bronze layer often combines schema-on-read and schema-on-write techniques. Initially, schema-on-read is applied in the landing or pre-Bronze layer. Hence, you first read data without explicitly declaring the data schema. Then, as you move the data to a layer where it becomes “queryable,” you switch to schema-on-write. For this critical layer, it’s wise to choose a storage format like Delta Lake that supports schema evolution. Delta Lake allows the data schema to adapt as it evolves, eliminating the need to overhaul or reload the entire dataset. This capability keeps the data current and usable, even as changes occur. We’ll revisit this feature shortly.

## MergeSchema and Schema Enforcement

.option("mergeSchema", "true").Delta Lake then takes care of adjusting the table schema in the following ways:

- If a column exists in the source DataFrame but not in the Delta table, Delta adds the new column. All existing rows will have a null value in this new column.

- If a column is in the Delta table but not in the source DataFrame, it remains unchanged. New records will have null values for these missing columns.

- Adding a NullType column sets all existing rows to null for that column.

- If a column with the same name but a different data type exists, Delta Lake tries to convert the data to the new type.4 If the conversion fails, Delta Lake throws an error.

To handle schema changes more strictly, you can use the Delta constraints feature, which is closely aligned with the schema- on-write approach.

If you encounter changes that affect compatibility, for example, changes that cannot be handled via the mergeSchema option, you’ll need to reconcile the schemas. When adjusting a Delta table’s schema, you have several options:

- Using SQL ALTER COLUMN statements
- Automated schema evolution
- Using a metadata-driven framework
-Restricting disruptive changes


## Technical Validation Checks
The design of the Bronze layer centers on strong data validation controls because it acts as the primary shield for technical validation checks and observability. You have different options: perform these checks in one go, break them into segments, or integrate them during data transfer to the Silver layer.

intrusive data integrity processing: If you anticipated a failure in downstream processes or if data consumers cannot handle these issues, you should halt the pipeline.

nonintrusive data quality processing: both validated and incorrect data are stored directly in the target Bronze-layer folder or table. This allows you to proceed with data processing, but be mindful that you may need to address these issues in another layer (typically Silver) later on.


In this way, the Bronze layer not only serves as a repository for raw data but also as a critical checkpoint for data integrity and accuracy, ensuring only data that meets predefined quality standards progresses further into the lakehouse architecture.

## Usage and Governance

To ensure proper governance, implement strict access controls to prevent unauthorized data access, manipulation, or deletion.

It’s crucial to set up alerts to monitor any anomalies in data size, format, or arrival times to maintain the integrity of data pipelines.

In essence, the Bronze layer serves as a foundational staging area in the Medallion architecture. It collects raw data from diverse sources and processes it by validating and converting it into the preferred format, such as Parquet or Delta
