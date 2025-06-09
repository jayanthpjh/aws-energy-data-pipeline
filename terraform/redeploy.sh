#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

terraform init
# Destroy existing resources to avoid naming collisions
terraform destroy -auto-approve || true
terraform apply -auto-approve
