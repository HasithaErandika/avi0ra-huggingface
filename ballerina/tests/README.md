Author: @HasithaErandika
Created: 2026-03-10
Updated: 2026-06-18
Edition: Swan Lake

# Tests

This directory contains unit and integration tests for the `avi0ra/huggingface` connector.

## Test Groups

Tests are organized into groups for selective execution:

| Group | Description |
|-------|-------------|
| `unit` | Unit tests that do not require a Hugging Face API token. Tests client initialization with various configurations. |
| `live` | Integration tests that make actual API calls to Hugging Face Inference API. Requires `HF_TOKEN` environment variable. |
| `chat` | Live test for chat completion endpoint. |
| `text-gen` | Live test for text generation. |
| `classification` | Live test for text classification. |
| `ner` | Live test for named entity recognition. |
| `embeddings` | Live test for feature extraction/embeddings. |
| `qa` | Live test for question answering. |
| `summarization` | Live test for text summarization. |
| `translation` | Live test for text translation. |
| `zero-shot` | Live test for zero-shot classification. |
| `image-gen` | Live test for text-to-image generation. |
| `image-classification` | Live test for image classification. |
| `asr` | Live test for automatic speech recognition. |

## Running Tests

### Unit Tests (no token required)

```bash
bal test --groups unit
```

### Live Integration Tests

```bash
export HF_TOKEN="<YOUR_HF_TOKEN>"
bal test --groups live
```

### All Tests

```bash
export HF_TOKEN="<YOUR_HF_TOKEN>"
bal test
```

## Test Resources

Place test media files in `tests/resources/`:

- `test.jpg` - For image classification tests
- `test.wav` - For automatic speech recognition tests