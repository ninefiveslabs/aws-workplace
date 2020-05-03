#!/bin/bash
set -ue
MYDIR=$(readlink -f "$(dirname "${0}")")
cd "${MYDIR}"
read -rsp 'Enter your AWS_ACCESS_KEY_ID: ' INIT_ACCESS_KEY
echo
read -rsp 'Enter your AWS_SECRET_ACCESS_KEY: ' INIT_SECRET_KEY
echo
read -rp 'Enter your MFA device ARN (see: https://console.aws.amazon.com/iam/home#/security_credentials): ' INIT_MFA_ARN
read -rp 'Enter default region [us-east-1]: ' INIT_DEFAULT_REGION
INIT_DEFAULT_REGION="${INIT_DEFAULT_REGION:-us-east-1}"
echo 'Now comes the GPG encryption password prompt:'
gpg \
--cipher-algo aes256 \
--s2k-cipher-algo aes256 \
--digest-algo sha512 \
--s2k-digest-algo sha512 \
--force-mdc \
--symmetric \
--no-symkey-cache \
--pinentry-mode loopback \
--armor \
--output credentials.asc \
--s2k-count 65011712 <<EOF
AWS_ACCESS_KEY_ID=${INIT_ACCESS_KEY}
AWS_SECRET_ACCESS_KEY=${INIT_SECRET_KEY}
AWS_MFA_ARN=${INIT_MFA_ARN}
EOF
echo "AWS_DEFAULT_REGION=${INIT_DEFAULT_REGION}" > config.sh