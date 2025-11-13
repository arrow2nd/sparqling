#!/bin/bash

# SPARQLingプロジェクトのRDFデータをApache Jena Fusekiに投入するスクリプト

set -e

# Fusekiサーバーの設定
FUSEKI_URL="${FUSEKI_URL:-http://localhost:3030}"
DATASET="${DATASET:-sparqling}"

# プロジェクトのルートディレクトリ（このスクリプトの親ディレクトリ）
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

echo "========================================="
echo "SPARQLing データ投入スクリプト"
echo "========================================="
echo "プロジェクトルート: $PROJECT_ROOT"
echo "Fuseki URL: $FUSEKI_URL"
echo "データセット: $DATASET"
echo ""

# Fusekiサーバーの起動待ち
echo "Fusekiサーバーの起動を待機中..."
MAX_RETRIES=30
RETRY_COUNT=0

until curl -s ${FUSEKI_URL}/\$/ping > /dev/null 2>&1; do
  RETRY_COUNT=$((RETRY_COUNT + 1))
  if [ $RETRY_COUNT -ge $MAX_RETRIES ]; then
    echo "エラー: Fusekiサーバーに接続できません"
    echo "以下を確認してください:"
    echo "  1. Fusekiサーバーが起動しているか"
    echo "  2. URL ${FUSEKI_URL} が正しいか"
    exit 1
  fi
  echo "  待機中... ($RETRY_COUNT/$MAX_RETRIES)"
  sleep 1
done

echo "✓ Fusekiサーバーに接続しました"
echo ""

# 既存データのクリア
echo "既存データをクリア中..."
curl -s -X DELETE ${FUSEKI_URL}/${DATASET}/data?default > /dev/null 2>&1 || true
echo "✓ クリア完了"
echo ""

# 1. スキーマの投入
echo "1. オントロジーを投入中..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @"$PROJECT_ROOT/URIs/sparqling-schema.rdf" \
  -w "  HTTP %{http_code}\n" -o /dev/null -s
echo "✓ オントロジー投入完了"
echo ""

# 2. キャラクターデータの投入
echo "2. キャラクターデータを投入中..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @"$PROJECT_ROOT/RDFs/characters.rdf" \
  -w "  HTTP %{http_code}\n" -o /dev/null -s
echo "✓ キャラクターデータ投入完了"
echo ""

# 3. ジャンル別データの投入
echo "3. ジャンル別データを投入中..."

# drinks
if [ -d "$PROJECT_ROOT/RDFs/drinks" ]; then
  echo "   - drinks"
  for file in "$PROJECT_ROOT/RDFs/drinks"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

# foods
if [ -d "$PROJECT_ROOT/RDFs/foods" ]; then
  echo "   - foods"
  for file in "$PROJECT_ROOT/RDFs/foods"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

# books
if [ -d "$PROJECT_ROOT/RDFs/books" ]; then
  echo "   - books"
  for file in "$PROJECT_ROOT/RDFs/books"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

# tobacco
if [ -d "$PROJECT_ROOT/RDFs/tobacco" ]; then
  echo "   - tobacco"
  for file in "$PROJECT_ROOT/RDFs/tobacco"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

# music
if [ -d "$PROJECT_ROOT/RDFs/music" ]; then
  echo "   - music"
  for file in "$PROJECT_ROOT/RDFs/music"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

# movies
if [ -d "$PROJECT_ROOT/RDFs/movies" ]; then
  echo "   - movies"
  for file in "$PROJECT_ROOT/RDFs/movies"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

# places
if [ -d "$PROJECT_ROOT/RDFs/places" ]; then
  echo "   - places"
  for file in "$PROJECT_ROOT/RDFs/places"/*.rdf; do
    if [ -f "$file" ]; then
      echo "     投入中: $(basename "$file")"
      curl -X POST ${FUSEKI_URL}/${DATASET}/data \
        -H "Content-Type: application/rdf+xml" \
        --data-binary @"$file" \
        -w "     HTTP %{http_code}\n" -o /dev/null -s
    fi
  done
fi

echo ""
echo "========================================="
echo "データ投入が完了しました!"
echo "========================================="
echo ""
echo "FusekiのWebインターフェースでデータを確認できます:"
echo "  ${FUSEKI_URL}/#/dataset/${DATASET}/query"
echo ""
echo "コマンドラインからクエリを実行:"
echo "  curl -X POST ${FUSEKI_URL}/${DATASET}/sparql \\"
echo "    --data-urlencode query@queries/botan_chichibu_drinks.rq"
echo ""
