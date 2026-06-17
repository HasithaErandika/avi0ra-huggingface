# Ballerina HuggingFace Connector

[![Build](https://github.com/HasithaErandika/module-ballerinax-huggingface/actions/workflows/ci.yml/badge.svg)](https://github.com/HasithaErandika/module-ballerinax-huggingface/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/HasithaErandika/module-ballerinax-huggingface.svg)](https://github.com/HasithaErandika/module-ballerinax-huggingface/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/HasithaErandika/module-ballerinax-huggingface.svg?label=Open%20Issues)](https://github.com/HasithaErandika/module-ballerinax-huggingface/issues)

## Overview

The `avi0ra/huggingface` Ballerina connector provides type-safe access to the [Hugging Face Inference API](https://huggingface.co/docs/inference-providers) via the router at `https://router.huggingface.co`.

The client is **OpenAPI-generated** and exposes resource methods with strongly-typed request and response records for core inference operations:

- Chat completion
- Text generation
- Text and token classification
- Feature extraction (embeddings)
- Summarization, translation, question answering, zero-shot classification
- Text-to-image, image classification, automatic speech recognition

See [`ballerina/Package.md`](ballerina/Package.md) for the full operation table and API reference.

## Setup guide

1. Create a free account at [Hugging Face](https://huggingface.co/join).
2. Go to your [Access Tokens page](https://huggingface.co/settings/tokens).

   ![Hugging Face access tokens page](https://raw.githubusercontent.com/HasithaErandika/module-ballerinax-huggingface/main/docs/setup-huggingface/get-token.png)

3. Click **New token**, choose **Fine-grained**, and enable the **Inference Providers** permission. Copy this token.

   ![Create fine-grained token](https://raw.githubusercontent.com/HasithaErandika/module-ballerinax-huggingface/main/docs/setup-huggingface/type_fine-grained.png)

   or else, choose **Type == Read**

   ![Create read token](https://raw.githubusercontent.com/HasithaErandika/module-ballerinax-huggingface/main/docs/setup-huggingface/type_read.png)

4. Add the connector to your Ballerina project:

   ```bash
   bal pull avi0ra/huggingface
   ```

5. Configure the token in `Config.toml` or environment variables:

   ```toml
   token = "<YOUR_HF_TOKEN>"
   ```

   ```bash
   export HF_TOKEN="<YOUR_HF_TOKEN>"
   ```

## Quickstart

### Chat completion

```ballerina
import ballerina/io;
import avi0ra/huggingface;

public function main() returns error? {
    huggingface:Client hf = check new ({auth: {token: "<HF_TOKEN>"}});

    huggingface:ChatCompletionResponse resp = check hf->/v1/chat/completions.post({
        model: "Qwen/Qwen2.5-7B-Instruct",
        messages: [{role: "user", content: "What is Ballerina?"}],
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
huggingface:SummarizationResult[] results = check hf->/hf\-inference/models/[modelId]/summarization.post({
    inputs: "Long article text here...",
    parameters: {maxLength: 130, minLength: 30}
});
io:println(results[0].summaryText ?: "");
```

> **Note:** Path segments containing hyphens must be escaped in resource access (e.g. `hf\-inference`, `text\-classification`).

## Regenerating the client

The connector client is generated from `docs/spec/openapi.yaml`:

```bash
bal openapi flatten -i docs/spec/openapi.yaml -o docs/spec
bal openapi align -i docs/spec/flattened_openapi.yaml -o docs/spec
# Replace docs/spec/openapi.yaml with aligned_ballerina_openapi.yaml
bal openapi -i docs/spec/openapi.yaml --mode client -o ballerina
```

See [`docs/spec/sanitations.md`](docs/spec/sanitations.md) for spec modifications.

## Building from source

1. Clone the repository and build the package:

   ```bash
   git clone https://github.com/HasithaErandika/module-ballerinax-huggingface.git
   cd module-ballerinax-huggingface/ballerina
   bal build
   ```

2. Run unit tests (no token required):

   ```bash
   bal test --groups unit
   ```

3. Run live integration tests:

   ```bash
   export HF_TOKEN="<YOUR_HF_TOKEN>"
   bal test --groups live
   ```

4. Build with Gradle from the repository root:

   ```bash
   ./gradlew clean build
   ```

## Changelog

### Unreleased
- Regenerated connector from OpenAPI specification using the Ballerina OpenAPI tool.
- Removed higher-level abstractions (`Conversation`, `ragQuery`, `ModelRunner`) from the connector package to align with Ballerina platform connector guidelines.
- Client now uses resource methods mapped directly to inference API paths.

### 1.1.0
- Previous handwritten connector with extended helpers and abstractions.

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

- [`huggingface` on Ballerina Central](https://central.ballerina.io/avi0ra/huggingface/latest)
- [Create your first connector with Ballerina](https://ballerina.io/learn/create-your-first-connector-with-ballerina/)
- [Discord server](https://discord.gg/ballerinalang)
