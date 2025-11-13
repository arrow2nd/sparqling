# SPARQLing プロジェクトルール

## データ記述の原則

### **変化する可能性のあるデータは取り扱わない**

このプロジェクトでは、Linked Open
Dataとして長期的に信頼できるデータのみを記述します。
ストーリーの進行によって変化する可能性のあるデータは、一切記述しないでください。

## 記述してはいけないデータ（例）

以下は**記述禁止**です：

### キャラクター関連

- ❌ 年齢（`schema:age`）
- ❌ 学年・所属（`schema:affiliation`）
- ❌ 学部・学科
- ❌ 寮の部屋番号
- ❌ 役職（寮長など）

## 既存ボキャブラリの活用

独自プロパティを作る前に、以下の既存ボキャブラリで表現できないか検討してください：

- `foaf:` (Friend of a Friend) - 人物・名前
- `schema:` (Schema.org) - 一般的な属性
- `dbo:` (DBpedia Ontology) - 百科事典的データ

## データ形式

- RDF/XML形式（`.rdf`）を使用
- UTF-8エンコーディング
- 日本語には`xml:lang="ja"`を明記
- 英語には`xml:lang="en"`を明記

## 外部リンク（owl:sameAs、schema:birthPlace、schema:author等）の優先順位

外部のLinked Dataリソースへのリンクは、以下の優先順位に従って記述してください。

**このルールは全てのURIリソース参照に適用されます：**

- `owl:sameAs`（作品や場所への同一性リンク）
- `schema:birthPlace`（出身地）
- `schema:author`（著者）
- その他のrdf:resource属性を持つプロパティ

1. **ja.dbpedia.org（日本語DBpedia）を最優先**
   - 日本語のリソースが存在する場合は、必ずこれを使用
   - 他のリソース（wikidata、英語版dbpedia）は記述しない

2. **ja.dbpedia.orgが存在しない場合は wikidata.org を使用**
   - Wikidataのリソースを記述
   - 英語版DBpediaは記述しない

3. **ja.dbpedia.orgもwikidataも存在しない場合のみ dbpedia.org（英語版）を使用**
