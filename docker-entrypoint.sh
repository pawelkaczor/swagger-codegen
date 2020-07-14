#!/usr/bin/env bash

set -euo pipefail

GEN_DIR=/opt/swagger-codegen
JAVA_OPTS=${JAVA_OPTS:-"-Xmx1024M -DloggerPath=conf/log4j.properties"}

cli="${GEN_DIR}/modules/swagger-codegen-cli"
codegen="${cli}/target/swagger-codegen-cli.jar"
cmdsrc="${cli}/src/main/java/io/swagger/codegen/cmd"

command=$1
shift
exec java ${JAVA_OPTS} -jar "${codegen}" "${command}" "$@"
