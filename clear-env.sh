#!/bin/bash
mapfile -t VARS < <(env | grep '^AWS_' | awk -F= '{print $1}')
unset "${VARS[@]}"
PS1="${OLDPS1}"
PATH="${OLDPATH}"
