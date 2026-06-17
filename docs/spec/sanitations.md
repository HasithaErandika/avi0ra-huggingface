_Author_: Hasitha Erandika \
_Created_: 2026-06-03 \
_Updated_: 2026-06-03 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the Hugging Face Inference API OpenAPI specification used to generate the Ballerina client.

**Source:** Curated OpenAPI definition aligned with the [Hugging Face Inference Providers](https://huggingface.co/docs/inference-providers) router API at `https://router.huggingface.co`.

## Sanitation changes

1. **Server URL** — Set to `https://router.huggingface.co` (current Inference Providers router base URL).
2. **Path prefix** — Prefixed all model inference paths with `/hf-inference` (e.g. `/models/{model}/summarization` → `/hf-inference/models/{model}/summarization`) to match the live router API.
3. **Scope** — Initial connector scope covers core stable endpoints: chat completion, text generation, classification, embeddings, summarization, translation, zero-shot classification, question answering, text-to-image, image classification, and automatic speech recognition. Additional endpoints (streaming, fill-mask, sentence-similarity, text-to-speech, image-to-text, batch) will be added as they are confirmed in the official OpenAPI specification.
4. **Schema naming** — Applied `x-ballerina-name` extensions for snake_case JSON fields (`summary_text`, `generated_text`, etc.) before alignment.

## OpenAPI CLI commands

The following commands were used to generate the Ballerina client from the repository root:

```bash
bal openapi flatten -i docs/spec/openapi.yaml -o docs/spec
bal openapi align -i docs/spec/flattened_openapi.yaml -o docs/spec
# Replace docs/spec/openapi.yaml with aligned_ballerina_openapi.yaml
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```
