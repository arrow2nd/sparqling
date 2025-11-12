#!/bin/bash

FUSEKI_URL="http://localhost:3030"
DATASET="sparqling"

echo "Waiting for Fuseki to start..."
until curl -s ${FUSEKI_URL}/$/ping > /dev/null; do
  sleep 1
done

echo "Fuseki is ready!"

echo "Clearing existing data..."
curl -X DELETE ${FUSEKI_URL}/${DATASET}/data?default

echo "Loading schema..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @URIs/sparqling-schema.rdf

echo "Loading characters..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @RDFs/characters.rdf

echo "Loading drinks..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @RDFs/drinks.rdf

echo "Loading tobacco..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @RDFs/tobacco.rdf

echo "Loading books..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @RDFs/books.rdf

echo "Loading music..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @RDFs/music.rdf

echo "Loading places..."
curl -X POST ${FUSEKI_URL}/${DATASET}/data \
  -H "Content-Type: application/rdf+xml" \
  --data-binary @RDFs/places.rdf

echo "Data loaded successfully!"
