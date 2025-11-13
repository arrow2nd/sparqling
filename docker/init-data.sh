#!/bin/bash

set -e

# JVMメモリを制限（データ投入時も省メモリで）
export JAVA_OPTIONS="-Xmx96m -Xms64m -XX:+UseSerialGC"

TDB_DIR="${TDB_DIR:-/fuseki/databases/sparqling}"
JENA_BIN="${JENA_BIN:-/opt/jena/bin}"

# tdb2.tdbloaderコマンドの存在確認
if [ ! -x "${JENA_BIN}/tdb2.tdbloader" ]; then
  echo "Error: tdb2.tdbloader not found at ${JENA_BIN}"
  echo "Please set JENA_BIN environment variable to your Jena installation path"
  echo "Example: JENA_BIN=/usr/bin ./init-data.sh"
  exit 1
fi

echo "========================================="
echo "SPARQLing データ初期投入"
echo "========================================="

# TDB2にデータを投入
echo "1. スキーマを投入中..."
${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} /data/URIs/sparqling-schema.rdf

echo "2. キャラクターデータを投入中..."
${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} /data/RDFs/characters.rdf

echo "3. ジャンル別データを投入中..."

# drinks
if [ -d "/data/RDFs/drinks" ]; then
  echo "   - drinks"
  for file in /data/RDFs/drinks/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

# foods
if [ -d "/data/RDFs/foods" ]; then
  echo "   - foods"
  for file in /data/RDFs/foods/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

# books
if [ -d "/data/RDFs/books" ]; then
  echo "   - books"
  for file in /data/RDFs/books/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

# tobacco
if [ -d "/data/RDFs/tobacco" ]; then
  echo "   - tobacco"
  for file in /data/RDFs/tobacco/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

# music
if [ -d "/data/RDFs/music" ]; then
  echo "   - music"
  for file in /data/RDFs/music/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

# movies
if [ -d "/data/RDFs/movies" ]; then
  echo "   - movies"
  for file in /data/RDFs/movies/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

# places
if [ -d "/data/RDFs/places" ]; then
  echo "   - places"
  for file in /data/RDFs/places/*.rdf; do
    [ -f "$file" ] && ${JENA_BIN}/tdb2.tdbloader --loc=${TDB_DIR} "$file"
  done
fi

echo ""
echo "========================================="
echo "データ投入完了"
echo "========================================="
