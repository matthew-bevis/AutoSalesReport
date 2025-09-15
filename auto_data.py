from pyspark import SparkContext

def extract_vin_key_value(line):
    parts = line.split(",")
    # row_id, incident_type, vin, make, model, year, date, desc
    row_id = parts[0]
    incident_type = parts[1]
    vin = parts[2]
    make = parts[3] if parts[3] else None
    year = parts[5] if len(parts) > 5 and parts[5] else None
    return (vin, (incident_type, make, year))

def populate_make(records):
    make, year = None, None
    # First, look for incident record with make/year
    for incident_type, m, y in records:
        if incident_type == "I" and m and y:
            make, year = m, y
            break

    results = []
    for incident_type, m, y in records:
        if incident_type == "A" and make and year:
            results.append((make, year))
    return results

def extract_make_key_value(record):
    (make, year) = record
    return ("{}-{}".format(make, year), 1)

if __name__ == "__main__":
    sc = SparkContext("local", "AutoDataApp")
    raw_rdd = sc.textFile("hdfs://namenode:9000/input/data.csv")

    vin_kv = raw_rdd.map(extract_vin_key_value)
    enhance_make = vin_kv.groupByKey().flatMap(lambda kv: populate_make(kv[1]))
    make_kv = enhance_make.map(extract_make_key_value)
    result = make_kv.reduceByKey(lambda a, b: a + b)

    result.saveAsTextFile("hdfs://namenode:9000/output/auto_data_results")
