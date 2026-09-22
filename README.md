# Use Case 3: Evaluating RAG on SAP HANA Cloud

## The scenario

A grounded RAG system is only as good as its retrieval. If the search returns the wrong context, the model gives a wrong answer with full confidence, and the citation makes it look trustworthy. Before a firm puts a grounded system in front of its people, it has to know the retrieval actually works.

The problem is that most teams never measure this. They build the pipeline, it looks fine on a few questions, and it ships. Then it quietly returns the wrong chunk on the questions that matter, and nobody knows until someone acts on a bad answer.

## What we are doing

We measure the retrieval layer properly, on SAP HANA Cloud, against a context store that spans several business domains: finance, HR, legal, and procurement. We run a fixed set of test questions with known correct answers and score how well retrieval does.

Here is what the evaluation runs:

* Retrieval with cosine similarity, L2 distance, and BM25, so you can compare methods on the same data.
* Context precision and context recall at different K values, to see how quality changes as you widen the context.
* Out of scope questions, to check the system knows when it has no good answer instead of forcing one.
* Metadata filtered queries, to test retrieval inside a narrowed slice of the store.

The point is not the specific numbers. It is the test harness. The numbers depend on your own data. The method moves from one corpus to the next.

## Why this matters for the client

* You know before you ship. Retrieval quality is measured, not assumed.
* You measure on your own data. The results reflect the client's real corpus, not a benchmark that looks nothing like it.
* You catch a wrong answer before it reaches a person. Out of scope handling means the system can say it does not know.
* You choose the right method for the data. Cosine, L2, and BM25 do not behave the same on every corpus, and now you can see which one fits.
* You have a baseline to defend. When retrieval changes, you can prove whether it got better or worse.

---

## What's in this pack

One file.

## companion_script.sql

Run this file in the SAP HANA Database Explorer against your HANA Cloud instance. It creates the context store, inserts the documents across the four domains, generates the embeddings, builds the HNSW vector index, and then runs the full evaluation: cosine similarity queries, L2 distance queries, BM25 setup and queries, out of scope queries for confidence calibration, and metadata filtered queries.

Run the blocks in sequence.

Prerequisites:

* SAP HANA Cloud instance with the Vector Engine enabled
* PAL (Predictive Analysis Library) enabled, for BM25
* Embedding model available: `SAP_NEB.20240715`


  Author: Junaid Ahmed
