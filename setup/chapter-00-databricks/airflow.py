from airflow import DAG
from airflow.providers.databricks.operators.databricks import DatabricksRunNowOperator, DatabricksSubmitRunOperator
from airflow.operators.python import PythonOperator
from airflow.operators.email import EmailOperator
from airflow.utils.dates import days_ago

# Define default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False
}

def my_python_callable():
    pass

# Define the notebook path as a parameter
notebook_task_params1 = {
    "notebook_path": "/path/to/scripts/Join_data"
}

with DAG('databricks_dag',
    description="A ELT workflow with medallion architecture",
    start_date = days_ago(2),
    schedule_interval = None,
    default_args = default_args
) as dag:

    # Silver Layer: Run cleansing tasks
    clean_data = DatabricksRunNowOperator(
        task_id = 'clean_data',
        databricks_conn_id = 'databricks_default',
        job_id = 611956138725093,
        email_on_failure=True,
    )

    clean_data_failure = PythonOperator(  
        task_id="log_ingest_failure",  
        python_callable=my_python_callable,  
        trigger_rule="all_failed",  
    )

    # Silver Layer: Join tables
    join_data = DatabricksSubmitRunOperator(
        task_id="join_data",
        databricks_conn_id = 'databricks_default',
        notebook_task=notebook_task_params1
    )

    # Set the task dependencies  
    clean_data >> join_data
    clean_data >> clean_data_failure