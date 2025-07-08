Data Governance
Data governance in a large federated architecture is complex. It requires a structured approach to ensure data quality, integrity, and security is managed accordingly across all domains. To achieve this, you need to establish clear guidelines for managing data effectively within each Medallion architecture instance. This involves defining roles, setting boundaries, and managing data across the Bronze, Silver, and Gold layers. Let’s further explore how to implement data governance effectively in a Medallion architecture and look into the specifics of managing data within each layer. After that, we will discuss Unity Catalog, a critical component for data governance in Medallion architectures.


Layer Governance-related objectives
Bronze
- Report issues with technical validation Label and classify data
- Optionally encrypt data
- Define access controls for raw data

Silver
- Report functional data quality issues Avoid integrating data sources Conduct regular audits
- Apply MDM
- Ensure inclusion of security metadata Define allowance of operational usage Ensure alignment with Bronze layer Sign-offs for operationally aligned data products

Gold
- Focus on nuances for usage
- Ensure uniformity across datasets Transformation of your data model Sign-offs for data products


Unity Catalog

 Not to use hive_metastore: A major drawback was that each workspace required its own metastore for configuration management, which necessitated either painful replication or the implementation of a broader-scoped external metastore. 

Unity Catalog also acts as a security gatekeeper, as each object in the catalog can be individually secured. These privileges are assigned by the object’s owner, typically the creator of the data asset. In this context, Unity Catalog also integrates with identity providers, such as Microsoft Entra ID.

GRANT USE CATALOG ON CATALOG <catalog_name> TO <
GRANT USE SCHEMA ON SCHEMA <catalog_name>.<schem
TO <group_name>;
GRANT
SELECT
  ON <catalog_name>.<schema_name>.<table_name>;
TO <group_name>;





