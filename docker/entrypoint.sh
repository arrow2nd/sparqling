#!/bin/bash

set -e

# 環境変数
TDB_DIR="${TDB_DIR:-/fuseki/databases/sparqling}"
JENA_BIN="${JENA_BIN:-/opt/jena/bin}"
FUSEKI_HOME="${FUSEKI_HOME:-/opt/fuseki}"

echo "========================================="
echo "起動準備"
echo "========================================="

# データベースディレクトリが存在しない、または空の場合はデータを投入
if [ ! -d "${TDB_DIR}" ] || [ -z "$(ls -A ${TDB_DIR})" ]; then
  echo "データベースが存在しません。初期データを投入します..."
  /init-data.sh
else
  echo "既存のデータベースを使用します: ${TDB_DIR}"
fi

echo ""
echo "========================================="
echo "Fusekiを起動します"
echo "========================================="

# JVMメモリを制限（Cloudflare Containers向け: 最大128MB）
export JAVA_OPTIONS="-Xmx128m -Xms64m -XX:+UseSerialGC -XX:MaxMetaspaceSize=64m"

cd ${FUSEKI_HOME}
exec ./fuseki-server --loc=${TDB_DIR} /sparqling
