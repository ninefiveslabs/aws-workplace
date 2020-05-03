#!/bin/bash
# this file is meant to be sourced
MYDIR=$(readlink -f "$(dirname "${BASH_SOURCE[0]}")")
"${MYDIR}/setup.sh"
OLDPATH="${PATH}"

function cleanup() {
    echo 'Cleaning up after error...'
    # shellcheck source=clear-env.sh
    . "${MYDIR}/clear-env.sh"
}

export PATH="${MYDIR}/bin/aws/dist:${MYDIR}/bin/dist:${MYDIR}/bin/cdk/bin:${PATH}"
while IFS='=' read -r NAME VALUE; do
    export "${NAME}=${VALUE}"
done < <(cat "${MYDIR}/config.sh"; gpg -d --no-symkey-cache --pinentry-mode loopback "${MYDIR}/credentials.asc")
[ -z "${AWS_SECRET_ACCESS_KEY+x}" ] && cleanup && return 0
[ -z "${AWS_ACCESS_KEY_ID+x}" ] && cleanup && return 0
read -rp 'Enter current MFA token: ' 'AWS_MFA_TOKEN'
read -r _ AWS_ACCESS_KEY_ID EXPIRES AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN < <(aws --output text sts get-session-token --serial-number "${AWS_MFA_ARN}" --duration-seconds 3600 --token-code "${AWS_MFA_TOKEN}")

if [ x"${?}" == x"0" ]; then
    echo "Session expires at: ${EXPIRES}"
    # shellcheck disable=SC2034
    export 'AWS_SESSION_TOKEN'
    # shellcheck disable=SC2034
    export 'AWS_DEFAULT_REGION'
    export OLDPS1="${PS1}"
    export PS1="AWS ${PS1}"
    export 'OLDPATH'
else
    echo 'Session creation failed.'
    cleanup
fi
