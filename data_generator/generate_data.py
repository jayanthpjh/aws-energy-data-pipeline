import json
import time
import requests
import random
import boto3
from datetime import datetime
from uuid import uuid4
import os

s3 = boto3.client('s3')
BUCKET_NAME = os.getenv('ENERGY_BUCKET_NAME', 'energy-data-bucket-info-demo')
SITES = [
    {"site_id": "site_sfo", "lat": 37.7749, "lon": -122.4194},
    {"site_id": "site_nyc", "lat": 40.7128, "lon": -74.0060},
    {"site_id": "site_chi", "lat": 41.8781, "lon": -87.6298}
]

def get_temp_openmeteo(lat, lon):
    url = f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&current=temperature_2m"
    try:
        r = requests.get(url, timeout=10)
        r.raise_for_status()
        return float(r.json().get("current", {}).get("temperature_2m", 25))
    except:
        return 25.0

def get_temp_mock(lat, lon):
    return 20.0 + (lat + lon) % 10

def get_energy_generated(lat, lon):
    temps = [get_temp_openmeteo(lat, lon), get_temp_mock(lat, lon)]
    return round(sum(temps) / len(temps) * 0.8, 2)

def generate_record(site):
    generated = get_energy_generated(site["lat"], site["lon"])

    choice = random.choice(["pos", "neg", "zero"])
    diff = round(random.uniform(0.1, 5.0), 2)
    if choice == "pos":
        consumed = round(generated - diff, 2)
    elif choice == "neg":
        consumed = round(generated + diff, 2)
    else:  # zero difference
        consumed = generated

    return {
        "site_id": site["site_id"],
        "timestamp": datetime.utcnow().isoformat(),
        "energy_generated_kwh": generated,
        "energy_consumed_kwh": consumed,
    }

def upload_data():
    data = [generate_record(site) for site in SITES]
    filename = f"energy_data_{uuid4()}.json"
    s3.put_object(Bucket=BUCKET_NAME, Key=filename, Body=json.dumps(data))
    print(f"Uploaded {filename} to {BUCKET_NAME}")

upload_data()
