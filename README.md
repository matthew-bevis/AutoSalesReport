# AutoSalesReport with Hadoop + Spark

This project demonstrates using **Apache Spark** (via PySpark) on top of a **Hadoop cluster** running in Docker.  
It processes automotive sales and incident data to propagate vehicle details (make/year) into accident records and produce aggregated reports.

---

## Requirements:

This project runs using a Docker image layed out in the docker-compose.yaml file within the project files.  Please ensure that docker is properly installed before continuing.

## Python Virtual Environment

This project also requires the installation of PySpark to work, so the initialization of a Python Virtual Environment is advised to polluting the Python system architecture.

Please set up your Python Virtual Environment in bash by running the following:
```bash
python -m venv venv
source venv/Scripts/activate   # Windows Git Bash
# or
source venv/bin/activate       # Linux / WSL
```

Once inside of the Python virtual environment please run the following:
```bash
pip install -r requirements.txt
```

This will ensure that you virtual environment is properly initialized with all of the necessary libraries to function.

## Running the Pipeline

After all of the initial setup is out of the way, the rest of the project is automated for your convenience by running the following script:
```bash
./run_spark-submit.sh
```

## Results:

After running the previous shell script, you should see the following output:
```bash
('Nissan-2003', 1)
('Mercedes-2015', 2)
('Mercedes-2016', 1)
[INFO] Pipeline completed successfully
```

This lets you know that the Pipeline ran successfully, and provides you a list of vehicles sold by the dealership, and the resulting accidents that occured after sale.