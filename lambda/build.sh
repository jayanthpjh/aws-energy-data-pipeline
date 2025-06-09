#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"
rm -rf package
mkdir package
pip install -r requirements.txt -t package
cp lambda_function.py package/
cd package
zip -r ../lambda_function.zip .
cd ..
rm -rf package
