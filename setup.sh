#!/bin/bash
set -eu
MYDIR=$(readlink -f "$(dirname "${0}")")
pushd "${MYDIR}" > /dev/null
[ -d ./bin ] || mkdir ./bin
AWS_CLI_FILENAME="awscli-exe-linux-x86_64.zip"
pushd ./bin > /dev/null
echo "Updating aws-cli..."
curl -LsOz "${AWS_CLI_FILENAME}" 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip'
unzip -quo "${AWS_CLI_FILENAME}"
