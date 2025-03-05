#!/usr/bin/bash

# Do updates
apt update -y

# Install required helper apps
apt install -y unzip awscli jq

# Set the StrongDM admin token variable with key value from Secrets Manager
# where <SECRET_ID> = ARN of the secret, <REGION> is your AWS region, and <SECRET_KEY> is the name of the key that stores the StrongDM admin token
# Example:  aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-west-2:123456789012:secret:sdm/secrets-4hJMIj --region us-west-2 --query SecretString --output text| jq -r ".admintoken”)

ADMIN_TOKEN=$(aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-west-2:018555789501:secret:sdm_token-NG1TWJ --region us-west-2 --query SecretString --output text | jq -r ".sdm_token")

# Set the StrongDM admin token variable in a way that systemctl can use it

systemctl set-environment SDM_ADMIN_TOKEN="$ADMIN_TOKEN"

# Restart the StrongDM gateway setup script (the script included with the StrongDM Gateway AMI)
systemctl restart sdm-relay-setup

# Unset the SDM_ADMIN_TOKEN in systemctl because sdm-proxy fails to start if it has this and SDM_RELAY_TOKEN
systemctl unset-environment SDM_ADMIN_TOKEN

# Enable and restart sdm-proxy
systemctl enable sdm-proxy
systemctl restart sdm-proxy