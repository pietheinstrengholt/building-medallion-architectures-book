# Silver layer

Refines, cleanses, and standardizes the raw data, preparing it for more complex operational and analytical tasks. In this layer, data undergoes quality checks, standardization, deduplication, and other enhancements
that improve its reliability and usability. The Silver layer acts as a transitional stage where data is still granular but has been processed to ensure quality and consistency.
Its key characteristics are that data in the Silver layer is more structured and query-friendly, making it easier for analysts and data scientists to work with.

## Cleaning Data Activities

The data cleansing process can be governed by specific ETL rules or, in some cases, through mapping tables.

- Reducing noise and removing inauthentic data
    Eliminate irrelevant data, such as unnecessary columns or rows, to enhance data quality and reduce storage requirements. This step also involves removing inauthentic data, which does not accurately reflect the true (golden) source.

- Handling missing values
    Assess missing data within your dataset and decide the approach for addressing it—options include removal, substitution with a default value, or employing imputation techniques to estimate missing values based on surrounding data.

- Removing duplicates
    Verify that your dataset is free of duplicate records unless specifically required (e.g., for retention compliance). Duplicates can distort analysis and lead to inaccurate models.

- Trimming spaces
    Remove unnecessary spaces in data entries, particularly in string data types where leading and trailing spaces could impact sorting, searching, and other string manipulation tasks.

- Error corrections
    Identify and rectify errors in data entry, such as typos, incorrect capitalization, or erroneous units. This category also covers the detection and correction of outliers—data points that deviate markedly from the norm.

- Consistency checks
    Confirm data consistency throughout your dataset. This includes standardizing abbreviations, terminologies, and units of measure (e.g., consistently using NL instead of alternating with NETHERLANDS).

- Standardizing formats
    Ensure date formats are consistent (e.g., using [YYYY]- [MM]-[DD]), recognizing that different locales may prefer alternative formats (like [DD]-[MM]-[YYYY]).

- Correcting types
    Ensure that columns are assigned correct data types, such as numeric, date, or floats, as appropriate.

- Fixing ranges
    Check that data in each column adheres to specified value ranges.

- Fixing uniqueness
    Ensure that data in each column maintains uniqueness, where required.

- Fixing constraints
    Validate that no column is orphaned; each child record must correspond to an existing parent record in the parent table.

- Masking sensitive data
    Conceal any PII appearing in clear text prior to data usage to protect privacy and comply with regulations.

- Anomaly detection
    Detect and fix anomalies that could indicate data quality issues. For instance, a sudden spike in sales data could be a sign of a data quality issue.

- Applying master data management
    Process data to ensure the accuracy, uniformity, and consistency of an organization’s shared critical data.

- Standardizing data
    Process data like addresses, phone numbers, locations, and reference codes to ensure consistency and accuracy across systems.

- Conforming data
    Conform data using a common data model to standardize and harmonize information across different systems.

After cleaning, the table structures are generally the same as in the Bronze layer. It’s important to note that incorrect or rejected data isn’t typically deleted. Instead, it’s flagged or filtered out and then stored in a sibling quarantine table within the Silver layer.


## Designing the Silver Layer’s Data Model
- Conforming and renaming columns
    consider renaming columns to apply consistent naming conventions a best practice in the Silver layer.

    Applying specific ranges or standardizing categorical data within Silver tables is an activity that can be closely related to master data management (MDM). MDM focuses on ensuring that an organization’s shared data—often called master data—is consistent and accurate. 
- Denormalization
    To optimize query performance in data modeling, you can consolidate data into fewer tables, and, by reducing the need for complex joins, queries can run faster. 

    occurs in the Silver layer and is even more common in the Gold layer.

    data is organized around commonly queried subject areas, eliminating the need for extensive joins and aligning well with distributed and column-based storage architectures.

    When applying denormalization, table volumes start to increase because redundant data is intentionally added to improve query performance. This redundancy results in more data being stored in the table, leading to a increased table volumes, which might impact performance depending on the scenario. In light of this, many organizations manage their tables via maintenance and optimization jobs.

- Slowly changing dimensions
    To build a comprehensive historical record of all changes over time, it’s necessary to reprocess data into what are known as slowly changing dimensions type 2 (SCD2). 
    
    This involves changing tables by adding additional columns such as start_date , end_date , and is_current to track changes more effectively.

    Creating business keys or generating hashes are crucial in this process, as they help in making comparisons that determine how to handle the source data.

    - A business key
        a business key refers to an attribute or set of attributes that can be used to uniquely identify a business concept or entity. Business keys are also often referred to as natural keys. Examples include CustomerID as a primary key in a customer relationship management (CRM) system or a Social Security number.
    - A hash
        In data handling, a hash refers to a fixed-size result generated from input data of arbitrary size, using a hashing algorithm. This unique result, or “hash value,” serves as a digital fingerprint for data.
    
    Most engineers argue that the Gold layer is more appropriate for SCD2, as these tables are expensive to create and store and are generally underused. Thus, Silver tables should mainly contain current records.

    If your Gold layer involves consolidating and merging various data sources, there might be value in creating a historical perspective in the Silver layer, especially when the authentic context from the source is crucial. This is often the case when building machine learning models that depend on historical data in its original context.

    Additionally, for operational reporting, maintaining historical data in its original form could eliminate the need for an operational data store close to the source. This is increasingly applicable where organizations have decreasing access to authentic data in operational systems, such as SaaS, outsourced services, and NoSQL solutions, and so on. Ultimately, deciding whether or not to implement SCDs in the Silver layer involves nuances and depends on specific project requirements.

- Surrogate keys
    A surrogate key is a unique identifier assigned to records, which has no inherent business meaning but serves to uniquely identify a record within a table. 

    typically generated using the auto increment feature, or alternatively, by hashing or concatenating multiple columns to create a unique identifier.

    Their primary advantage is their stability and permanence— they never change.

    helpful for tracking changes in dimension attributes over time because its value doesn’t change even if the business key changes.

    My perspective is that surrogate keys do not typically belong in the Silver layer. The subsequent stage, where data from different sources is combined and merged to build dimensional and fact tables, is where surrogate keys should first be created.

    At this stage, tables are joined using natural/business keys to look up and add surrogate keys.

    However, if there is a strong preference for using surrogate keys in all SCDs, it’s possible to implement them in both the Silver and Gold layers. In this scenario, the surrogate key generated in the Silver layer could be used as a lookup key to find the corresponding surrogate key in the Gold layer. This approach can work, but it requires careful implementation to ensure data consistency and integrity across layers.

    Additionally, the underlying storage is optimized to enhance performance. Despite these modifications, the data typically maintains its source-oriented nature. At this stage, it is not (yet) integrated with data from other sources.

- Harmonization with Other Sources
    Generally, my advice is to keep things separate for easier management and clearer isolation of concerns. To facilitate this, I recommend you don’t merge or integrate data from different source systems prematurely. 

    Thus, if your goal is to maintain an isolated design, it’s better to move the integration or combination of data from different sources to the Gold layer. This strategy aligns with maintaining clear boundaries and minimizing dependencies between different systems. 

    However, I’ve also seen organizations that prefer to integrate data from different sources in the Silver layer. In this scenario, the Silver layer acts more as traditional data integration layer, enabling the data to be combined and harmonized across entities before moving it to the Gold layer for final consumption. In this approach, I generally see more traditional data modeling techniques being used, such as the 3NF or data vault. Let’s explore these models in more detail.

- 3NF and Data Vault
    The concept of the third normal form (3NF), as mentioned in “Inmon Methodology”, is a data modeling technique that is often used in operational or transactional database normalization to reduce redundancy and dependency.

    data vault introduces another normalized data modeling technique. It builds on the concepts of the 3NF by incorporating unique features such as hubs (unique business keys), links (data connections), and satellite tables (detailed descriptive information about the data).

    The practical application of data vault modeling concepts generally takes place in the Silver layer of the Medallion architecture. This layer hosts both the raw data vault and the business vault. The raw vault presents structured, normalized representations of raw data, mapped to a conceptual business model. It integrates various sources using business keys, ensuring resilience against schema drift and tracking historical changes. The Silver layer also includes business vault elements like harmonization and intermediate transformations, which enrich the data and align it with enterprise-wide definitions. Point-in-time (PIT) and bridge tables further improve performance and querying, preparing data for use in the Gold layer. The roles of the Bronze and Gold layers, in this setup, remain largely unchanged, with the Bronze layer serving as the raw data staging area and the Gold layer transforming data for business intelligence and analytics.

    The data vault structure is known for its adaptability, excelling in environments with frequent changes in data structures and business rules. This makes it particularly suitable for organizations with complex data needs. Several reasons might lead enterprises to prefer to use the 3NF or data vault structure in their Medallion architecture:
    - High integration needs
        Enterprises with multiple, disparate source systems benefit from the 3NF and data vault’s ability to create a unified, integrated, and consistent data model.
    - Complex enterprise environments
        Organizations operating across multiple domains or with distributed teams require the flexibility and modularity offered by the 3NF and data vault.
    - Rapidly changing requirements and schema drift
        The data vault’s resilience to change and ability to adapt to evolving schemas make it ideal for dynamic environments where business and technical needs evolve frequently. By addressing these challenges, the data vault provides a future-proof framework for managing and delivering high-quality data.
    - Effective management of complex time dimensions
        A data vault model can effectively manage multiple active timelines within the same records, such as creation time, functional processing time, and loading time. This capability enhances the ability to track and understand data evolution, which is crucial for audits, compliance, and detailed historical analysis.

    Despite these advantages, using the 3NF or data vault for the Silver layer has drawbacks. 
    - While these modeling techniques offer improved flexibility and aim to save on storage costs, they are generally less favored in cloud-based data architectures due to scalability concerns. 
    - Practitioners often opt for wide, nested, denormalized tables because this setup maximizes cloud infrastructure efficiency. Denormalized tables avoid computationally expensive joins and data shuffling between Spark compute nodes, which can significantly slow down query performance.
    - They also must adhere to stringent rules and structures in order to maintain their integrity and effectiveness. To address these challenges, organizations might consider frequently reviewing and implementing automation frameworks like VaultSpeed.

    Given the complexities and demands of models like the 3NF and data vault, organizations often choose larger denormalized tables for practical reasons. These tables offer better performance, ease of use, and simplify overall design, making them particularly appealing in environments where performance and simplicity are prioritized over strict data normalization. 

    Moreover, deciding whether to integrate source systems in the Silver layer doesn’t restrict you from applying some level of enterprise standardization to the data. Conforming to defined standards such as data types, centrally managed reference data, and naming conventions is encouraged. Some customers even implement basic business rules, like calculating new values. However, such activities should be kept to a minimum. The Silver layer should focus primarily on ensuring the data is clean and standardized rather than on heavily augmenting data and applying complex business rules.

## Operational Querying and Machine Learning

- If your goal is to enable operational reporting that necessitates data enrichment, I recommend beginning the enrichment process in the Silver layer. Although this approach may require extra adjustments during the merging process in the Gold stage, the increased flexibility is worth the effort.

- Alternatively, if you value maintaining flexibility and prefer to separate concerns for easier management, consider delaying the enrichment of data until the Gold layer. This strategy isolates concerns and simplifies management, making it an effective approach for handling complex data structures.

## Managing Overlapping Requirements

- Generally, I suggest keeping transformations minimal in the Silver layer. The Gold layer, which is designed for end use, is where you should place business rules. This allows for customizations that meet specific use case needs and makes it easier to manage updates and maintenance.

- However, this approach can lead to complications when the same integration needs to be reused often by other teams. If data in the Gold layer is made specific for one initial business unit, another team needing the same data might find themselves reconstructing the logic.

## Automation Tasks
- Once you’ve overcome this initial hurdle and the data is available in a standardized (Delta Lake) format in the Bronze and Silver layers, you can proceed with further standardization and automation. At this stage, tools and metadata-driven frameworks become crucial, facilitating more streamlined and automated processing. This approach helps to maximize scalability and efficiency across the data processing architecture.

- rely on metadata-driven frameworks with common scripts and/or notebooks. These frameworks enable you to define your data engineering tasks in a declarative manner. Essential elements like schema information, data quality rules, natural and business keys, and mapping rules are all stored within a metadata repository. This repository is then utilized to automatically generate the transformation code. By simply updating the metadata, you can effortlessly modify the transformations, which significantly automates the data engineering process.

- Other frameworks to consider include dbt, the open source command-line tool previously mentioned, which excels by allowing transformations to be defined using templates, with a syntax similar to SELECT statements in SQL. Another declarative data engineering framework to consider, especially for those working within the Databricks environment, is Delta Live Tables (DLT). It not only facilitates transformations but also manages task orchestration, cluster management, monitoring, data quality, and error handling.

## The Silver Layer in Practice
- Refine and transform source-aligned data in the Silver layer for operational consistency. This approach allows you to maintain a single source of truth, effectively replacing traditional operational data stores with a more dynamic and scalable lakehouse solution.

- The structure of the Silver layer itself, whether it constitutes a single physical layer or includes multiple stages, largely depends on specific organizational requirements. For instance, to enhance auditability, you might divide this layer into three distinct stages: one for cleansing, another for conforming to standards, and potentially a third for building SCDs.
- If you want to both align data ownership and integrate data, consider setting up separate layers: one for source system- aligned cleaned data and another for harmonized data. Whatever approach you take, keeping each stage clear and consistent is crucial.
