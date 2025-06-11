import json
import os
import random
from uuid import uuid4
from datetime import datetime
import boto3
import os

bucket_name = os.environ["ENERGY_BUCKET_NAME"]
s3 = boto3.client("s3")
BUCKET_NAME = os.environ.get('ENERGY_BUCKET_NAME', 'energy-data-${random_pet.suffix.id}')

SITES = [
    { "site_id": "site_nyc", "lat": 40.7128, "lon": -74.0060 },
    { "site_id": "site_sfo", "lat": 37.7749, "lon": -122.4194 },
    { "site_id": "site_chi", "lat": 41.8781, "lon": -87.6298 }
]

def generate_record(site):
    is_anomaly = random.random() < 0.1
    energy_generated = round(random.uniform(10, 100), 2)
    energy_consumed = round(random.uniform(5, 95), 2)

    if is_anomaly:
        if random.random() < 0.5:
            energy_generated *= -1
        else:
            energy_consumed *= -1

    return {
        "site_id": site["site_id"],
        "timestamp": datetime.utcnow().isoformat(),
        "energy_generated_kwh": energy_generated,
        "energy_consumed_kwh": energy_consumed
    }

def lambda_handler(event, context):
    data = [generate_record(site) for site in SITES]
    filename = f"energy_data_{uuid4()}.json"
    s3.put_object(
        Bucket=BUCKET_NAME,
        Key=filename,
        Body=json.dumps(data)
    )
    return {"message": f"Uploaded {filename}", "record_count": len(data)}
