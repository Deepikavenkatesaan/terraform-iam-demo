#!/usr/bin/env bash

set -euo pipefail

IAM_USERNAME="$1"
IAM_GROUP="$2"
TFVARS_FILE="users.auto.tfvars.json"

if [[ ! "$IAM_USERNAME" =~ ^demo-[A-Za-z0-9_+=,.@-]+$ ]]; then
  echo "IAM username must begin with demo-"
  exit 1
fi

case "$IAM_GROUP" in
  cb-auth-development|cb-auth-sandbox|cb-auth-production)
    ;;
  *)
    echo "Invalid cb-auth group"
    exit 1
    ;;
esac

TEMP_FILE="$(mktemp)"

jq \
  --arg user "$IAM_USERNAME" \
  --arg group "$IAM_GROUP" \
  '.iam_users[$user] = ((.iam_users[$user] // []) + [$group] | unique)' \
  "$TFVARS_FILE" > "$TEMP_FILE"

mv "$TEMP_FILE" "$TFVARS_FILE"

echo "Added $IAM_USERNAME to $IAM_GROUP"
