# SPARQLing

🥂 上伊那ぼたんに登場するあれこれのRDFデータ集

## ローカル開発環境のセットアップ

1. リポジトリをクローン

```bash
git clone <repository-url>
cd sparqling
```

2. Fusekiを起動

```bash
docker compose up -d
```

3. データを投入

```bash
./tools/load-data.sh
```

4. ブラウザでアクセス

```
http://localhost:3030
```

### コンテナの停止・削除

```bash
# コンテナを停止
docker compose down

# ボリュームも削除する場合（データが消えます）
docker compose down -v
```

## SPARQLエンドポイント

> [!WARNING]
> 適当に建てているのでめちゃ遅い、もしくは落ちてるかもです

> https://sparqling.arrow2nd.com/sparqling/sparql

サンプルクエリはこちらに
> https://space.pikopikopla.net/query/38c8c2f99c

## Thanks!

- https://github.com/imas/imasparql
