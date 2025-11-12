FROM eclipse-temurin:17-jre

ENV FUSEKI_VERSION=5.6.0
ENV FUSEKI_HOME=/opt/fuseki
ENV FUSEKI_BASE=/fuseki

WORKDIR /tmp

# Install wget and dependencies
RUN apt-get update && \
    apt-get install -y wget && \
    rm -rf /var/lib/apt/lists/*

# Download and install Fuseki
RUN wget -q https://archive.apache.org/dist/jena/binaries/apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz && \
    tar xzf apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz && \
    mv apache-jena-fuseki-${FUSEKI_VERSION} ${FUSEKI_HOME} && \
    rm apache-jena-fuseki-${FUSEKI_VERSION}.tar.gz

# Create fuseki base directory
RUN mkdir -p ${FUSEKI_BASE}/databases/sparqling ${FUSEKI_BASE}/configuration

# Copy RDF data
COPY ./RDFs ${FUSEKI_BASE}/RDFs

WORKDIR ${FUSEKI_HOME}

EXPOSE 3030

CMD ["/opt/fuseki/fuseki-server", "--update", "--loc=/fuseki/databases/sparqling", "/sparqling"]
