import json
import boto3
import os
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")
TABLE_NAME = os.environ.get('ENERGY_TABLE_NAME', 'Energy_Data_Info-${random_pet.suffix.id}')
table = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    s3 = boto3.client("s3")
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        key = record["s3"]["object"]["key"]
        response = s3.get_object(Bucket=bucket, Key=key)
        content = response["Body"].read().decode("utf-8")
        records = json.loads(content)

        for item in records:
            gen = item["energy_generated_kwh"]
            con = item["energy_consumed_kwh"]
            net = gen - con
            anomaly = gen < 0 or con < 0

            table.put_item(Item={
                "site_id": item["site_id"],
                "timestamp": item["timestamp"],
                "energy_generated_kwh": Decimal(str(gen)),
                "energy_consumed_kwh": Decimal(str(con)),
                "net_energy_kwh": Decimal(str(net)),
                "anomaly": anomaly
            })

    return {"message": "Processing complete", "record_count": len(records)}
