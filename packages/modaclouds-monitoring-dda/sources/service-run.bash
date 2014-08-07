#!/bin/bash

set -e -E -u -o pipefail -o noclobber -o noglob +o braceexpand || exit 1
trap 'printf "[ee] failed: %s\n" "${BASH_COMMAND}" >&2' ERR || exit 1

exec </dev/null >&2

MODACLOUDS_MONITORING_DDA_HOME='@{package:root}'
CSPARQL_HOME='@{definitions:environment:CSPARQL_HOME}'
CSPARQL_CONF='@{definitions:environment:CSPARQL_CONF}'
JAVA_HOME='@{definitions:environment:JAVA_HOME}'

test -n "${MODACLOUDS_MONITORING_DDA_ENDPOINT_IP}"
test -n "${MODACLOUDS_MONITORING_DDA_ENDPOINT_PORT}"

test -n "${MODACLOUDS_KNOWLEDGEBASE_ENDPOINT_IP}"
test -n "${MODACLOUDS_KNOWLEDGEBASE_ENDPOINT_PORT}"

export JAVA_HOME
export PATH="${JAVA_HOME}/bin:${PATH}"

cd -- "${CSPARQL_HOME}"

sed -r \
		-e "s#%\{CSPARQL_IP\}#${MODACLOUDS_MONITORING_DDA_ENDPOINT_IP}#g" \
		-e "s#%\{CSPARQL_PORT\}#${MODACLOUDS_MONITORING_DDA_ENDPOINT_PORT}#g" \
	>|"${CSPARQL_CONF}/setup.properties" \
	<"${CSPARQL_CONF}/setup.properties-template"

exec java -jar ./main.jar

exit 1
