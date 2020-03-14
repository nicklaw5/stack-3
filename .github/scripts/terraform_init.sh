#!/usr/bin/env bash

set -euo pipefail

TERRAFORM_STATE_KEY=${REPOSITORY}/terraform.tfstate
TERRAFORM_STATE_BUCKET=$(aws ssm get-parameter --name /stack-1/terraform_state_bucket | jq -r .Parameter.Value)
TERRAFORM_STATE_DYNAMODB_TABLE=$(aws ssm get-parameter --name /stack-1/terraform_lock_table | jq -r .Parameter.Value)

docker run --rm \
    --user $(id -u) \
    --env AWS_ACCESS_KEY_ID \
    --env AWS_SECRET_ACCESS_KEY \
    --volume ${PWD}/${TERRAFORM_DIR}:/app \
    --workdir /app \
    hashicorp/terraform:${TERRAFORM_VERSION} \
    init  \
    -backend-config "region=${AWS_DEFAULT_REGION}" \
    -backend-config "bucket=${TERRAFORM_STATE_BUCKET}" \
    -backend-config "key=${TERRAFORM_STATE_KEY}" \
    -backend-config "dynamodb_table=${TERRAFORM_STATE_DYNAMODB_TABLE}"
