#!/bin/bash

set -e

# 環境変数
TDB_DIR="${TDB_DIR:-/fuseki/databases/sparqling}"
FUSEKI_HOME="${FUSEKI_HOME:-/opt/fuseki}"

cd ${FUSEKI_HOME}
exec ./fuseki-server --loc=${TDB_DIR} /sparqling
