# Hugging Face Connector for Ballerina

Connects Ballerina applications to the [Hugging Face Inference API](https://huggingface.co/docs/inference-providers) via the router at `https://router.huggingface.co`.

This package provides a type-safe, OpenAPI-generated `Client` with strongly-typed request and response records for core inference operations.

---

## Supported operations

| Operation | Resource path | Example model |
|---|---|---|
| Chat completion | `/v1/chat/completions` | `Qwen/Qwen2.5-7B-Instruct` |
| Text generation | `/hf-inference/models/{model}` | `openai-community/gpt2` |
| Text classification | `/hf-inference/models/{model}/text-classification` | `distilbert-base-uncased-finetuned-sst-2-english` |
| Token classification (NER) | `/hf-inference/models/{model}/token-classification` | `dslim/bert-base-NER` |
| Feature extraction (embeddings) | `/hf-inference/models/{model}/feature-extraction` | `sentence-transformers/all-MiniLM-L6-v2` |
| Question answering | `/hf-inference/models/{model}/question-answering` | `deepset/roberta-base-squad2` |
| Summarization | `/hf-inference/models/{model}/summarization` | `facebook/bart-large-cnn` |
| Translation | `/hf-inference/models/{model}/translation` | `Helsinki-NLP/opus-mt-en-fr` |
| Zero-shot classification | `/hf-inference/models/{model}/zero-shot-classification` | `facebook/bart-large-mnli` |
| Text-to-image | `/hf-inference/models/{model}/text-to-image` | `black-forest-labs/FLUX.1-schnell` |
| Image classification | `/hf-inference/models/{model}/image-classification` | `google/vit-base-patch16-224` |
| Automatic speech recognition | `/hf-inference/models/{model}/automatic-speech-recognition` | `openai/whisper-large-v3-turbo` |

---

## Setup

1. Create a free account at [Hugging Face](https://huggingface.co/join).
2. Generate an access token at [Settings → Access Tokens](https://huggingface.co/settings/tokens).
3. Add the dependency:

```toml
[dependencies]
avi0ra/huggingface = "1.1.0"
```

4. Import and initialize the client:

```ballerina
import avi0ra/huggingface;

public function main() returns error? {
    huggingface:Client hf = check new ({auth: {token: "<HF_TOKEN>"}});
    // Use resource methods on the client
}
```

---

## Quickstart

### Chat completion

```ballerina
import avi0ra/huggingface;

public function main() returns error? {
    huggingface:Client hf = check new ({auth: {token: "<HF_TOKEN>"}});

    huggingface:ChatCompletionResponse resp = check hf->/v1/chat/completions.post({
        model: "Qwen/Qwen2.5-7B-Instruct",
        messages: [{role: "user", content: "Hello!"}],
        maxTokens: 100
    });

    huggingface:ChatCompletionChoice[] choices = resp.choices ?: [];
    if choices.length() > 0 {
        io:println(choices[0].message?.content ?: "");
    }
}
```

### Summarization

```ballerina
string modelId = "facebook/bart-large-cnn";
huggingface:SummarizationResult[] results = check hf->/hf-inference/models/[modelId]/summarization.post({
    inputs: "Long article text here...",
    parameters: {maxLength: 130, minLength: 30}
});
io:println(results[0].summaryText ?: "");
```

### Feature extraction (embeddings)

```ballerina
string modelId = "sentence-transformers/all-MiniLM-L6-v2";
float[][] embeddings = check hf->/hf-inference/models/[modelId]/feature-extraction.post({
    inputs: "Hello world"
});
```

---

## Examples

See the [examples directory](https://github.com/HasithaErandika/module-ballerinax-huggingface/tree/main/examples) for additional use cases.

---

## Client generation

The client is generated from the OpenAPI specification in `docs/spec/openapi.yaml` using the Ballerina OpenAPI tool. See `docs/spec/sanitations.md` for spec modifications and regeneration commands.
