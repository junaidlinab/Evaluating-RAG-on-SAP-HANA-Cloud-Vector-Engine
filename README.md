Evaluating RAG on SAP HANA Cloud Vector Engine

Companion code for Article 3 in the Espresso Tutorials series on SAP HANA Cloud Vector Engine.

What This Covers

This evaluation builds a multi-domain enterprise context store on SAP HANA Cloud, runs retrieval using cosine similarity and BM25 across 20 test queries spanning finance, HR, legal, and procurement, and measures retrieval quality through context precision and context recall at different K values.

Prerequisites
SAP HANA Cloud instance with Vector Engine enabled
PAL (Predictive Analysis Library) enabled for BM25
Embedding model: SAP_NEB.20240715
Files

Companion script covers:

Context store creation
27 document inserts
Embedding generation
HNSW index creation
Cosine similarity queries
L2 distance queries
BM25 setup and queries
Out-of-scope queries for confidence calibration
Metadata-filtered queries
