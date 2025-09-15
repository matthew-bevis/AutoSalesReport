#!/bin/bash
# -----------------------------------------------------------------
# Full automation: start Hadoop+Spark, load data, run Spark job
# -----------------------------------------------------------------

# 1. Start cluster
echo "[INFO] Starting Hadoop + Spark cluster..."
docker compose up -d

# 2. Wait a few seconds for containers to initialize
echo "[INFO] Waiting for cluster to initialize..."
sleep 15

# 3. Copy data.csv into namenode
echo "[INFO] Copying data.csv into namenode..."
docker cp data.csv namenode:/data.csv

# 4. Put data.csv into HDFS
echo "[INFO] Creating HDFS input directory..."
docker exec -it namenode bash -c "hdfs dfs -mkdir -p /input"

echo "[INFO] Copying data.csv into HDFS..."
docker exec -it namenode bash -c "hdfs dfs -put -f /data.csv /input/data.csv"

# 5. Copy auto_data.py into spark-master
echo "[INFO] Copying auto_data.py to spark-master:/app/auto_data.py"
docker cp auto_data.py spark-master:/app/auto_data.py

# 6. Remove previous output (if exists)
echo "[INFO] Cleaning old HDFS output..."
docker exec -it namenode bash -c "hdfs dfs -rm -r -f /output/auto_data_results"

# 7. Run Spark job
echo "[INFO] Running spark-submit on spark-master..."
docker exec -it spark-master bash -c "/spark/bin/spark-submit \
  --master 'spark://spark-master:7077' \
  --deploy-mode client \
  /app/auto_data.py"

# 8. Fetch results from HDFS
echo "[INFO] Fetching Spark job results..."
docker exec -it namenode bash -c "hdfs dfs -cat /output/auto_data_results/part-00000" || {
  echo "[ERROR] No results found. Check Spark logs."
  exit 1
}

echo "[INFO] Pipeline completed successfully"
