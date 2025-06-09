# AWS Energy Data Pipeline
A fully serverless, auto-deploying energy monitoring pipeline using Terraform, Lambda, S3, DynamoDB, and FastAPI with CI/CD integration.

---

## 📌 Features
- Real-time data generation using Open-Meteo + mock data
- S3 ingestion + Lambda-triggered transformation
- DynamoDB storage with anomaly flagging
- FastAPI endpoints to access energy data
- Plotly visualization script
- GitHub Actions CI/CD with Terraform auto-deploy

---

## 🧰 Tech Stack
- AWS: Lambda, S3, DynamoDB, CloudWatch, IAM
- Python 3.10: FastAPI, boto3, requests, plotly
- Terraform v1.6+
- GitHub Actions for CI/CD

---

## 🛠️ Setup Instructions

### 1. Install Prerequisites
- Python ≥ 3.8
- Terraform ≥ 1.6
- AWS CLI (`aws configure`)
- GitHub Account

### 2. Clone & Prepare
```bash
git clone https://github.com/yourname/aws-energy-data-pipeline.git
cd aws-energy-data-pipeline
```

### 3. Export Your S3 Bucket for Local Testing
```bash
export ENERGY_BUCKET_NAME=your-bucket-name
```

### 4. Zip Lambda Files
```bash
cd lambda && zip lambda_function.zip lambda_function.py && cd ..
cd data_generator && zip generate_data.zip generate_data.py && cd ..
```

### 5. Deploy Infrastructure
```bash
cd terraform
terraform init
terraform apply -auto-approve
```

---

## ⚙️ CI/CD with GitHub Actions
### 🔐 Add GitHub Secrets
Go to **Settings → Secrets → Actions**:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### 🚀 CI/CD Trigger
Push to the `main` branch:
```bash
git add .
git commit -m "Initial deploy"
git push origin main
```

GitHub will auto-deploy your Terraform setup.

---

## 🧪 API Usage
Run locally:
```bash
uvicorn api.main:app --reload
```
- GET `/site/{site_id}?start=...&end=...`
- GET `/site/{site_id}/anomalies`

---

## 📊 Visualize Data
```bash
python visualization/visualize.py
```

---

## 🧹 Cleanup
```bash
cd terraform
terraform destroy -auto-approve
```

---

## 🤖 Optional Enhancements
- Alerts via SNS for anomalies
- Grafana for dashboards
- Kinesis for streaming ingestion

---

## 📁 Final Structure
```
aws-energy-data-pipeline/
├── .github/workflows/deploy.yml
├── api/main.py
├── data_generator/generate_data.py
├── lambda/lambda_function.py
├── visualization/visualize.py
├── terraform/*.tf
├── .gitignore
├── README.md
```

---

Made with ❤️ for scalable data engineering.
