from airflow import DAG
from apache_airflow_microsoft_fabric_plugin.operators.fabric \
import FabricRunItemOperator
from airflow.utils.dates import days_ago
from airflow.operators.python import PythonOperator

# Define default arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'email_on_failure': False
}

def my_python_callable():
    pass

with DAG('fabric_dag',
    description="An ELT workflow with medallion architecture",
    start_date = days_ago(2),
    schedule_interval = None,
    default_args = default_args
) as dag:

     clean_data = FabricRunItemOperator(
         task_id="clean_data",
         workspace_id="92187CE0-B7EB-4FDF-80CE-EFF76639EED8",
         item_id="27de4fe9-666d-40bb-8c71-cff017976d7",
         fabric_conn_id="fabric_conn_id",
         job_type="RunNotebook",
         wait_for_termination=True,
         deferrable=True,
     )

     clean_data_failure = PythonOperator(
        task_id="clean_data_failure",
        python_callable=my_python_callable,
        trigger_rule="all_failed",
     )

     # Set the task dependencies  
     clean_data >> clean_data_failure