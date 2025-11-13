# Apache Jena Fuseki Dockerfile for Cloudflare Containers

FROM eclipse-temurin:17-jre-jammy

# Jenaのバージョン
ENV JENA_VERSION=5.6.0
ENV FUSEKI_VERSION=5.6.0
ENV JENA_HOME=/opt/jena
ENV FUSEKI_HOME=/opt/fuseki
ENV FUSEKI_BASE=/fuseki

# 必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y curl wget && \
    rm -rf /var/lib/apt/lists/*

# Apache Jenaをダウンロードして展開（tdb2.tdbloaderなどのツールが必要）
RUN mkdir -p ${JENA_HOME} && \
    wget -q https://dlcdn.apache.org/jena/binaries/apache-jena-${JENA_VERSION}.tar.gz && \
    tar -xzf apache-jena-${JENA_VERSION}.tar.gz -C ${JENA_HOME} --strip-components=1 && \
    rm apache-jena-${JENA_VERSION}.tar.gz

# Fusekiをダウンロードして展開
RUN mkdir -p ${FUSEKI_HOME} && \
    wget -q https://dlcdn.apache.org/jena/binaries/apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz && \
    tar -xzf apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz -C ${FUSEKI_HOME} --strip-components=1 && \
    rm apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz

# Fusekiのデータディレクトリを作成
RUN mkdir -p ${FUSEKI_BASE}/databases/sparqling

# プロジェクトのRDFデータをコピー
COPY URIs/ /data/URIs/
COPY RDFs/ /data/RDFs/

# データを初期投入するスクリプト
COPY docker/init-data.sh /init-data.sh
RUN chmod +x /init-data.sh

# ビルド時にデータを投入
RUN /init-data.sh

# エントリポイントスクリプト
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ポート3030を公開
EXPOSE 3030

# Fusekiサーバーを起動
WORKDIR ${FUSEKI_HOME}
ENTRYPOINT ["/entrypoint.sh"]
