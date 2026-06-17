# Examples

The `avi0ra/huggingface` connector examples demonstrate usage of the OpenAPI-generated client against the Hugging Face Inference API.

Each example is a separate Ballerina package with its own `Ballerina.toml`, `main.bal`, and configuration.

## Prerequisites

1. A Hugging Face account with an access token that has **Inference Providers** permissions.
2. Java 21 and Ballerina Swan Lake installed.
3. The `avi0ra/huggingface` module built or pulled from Ballerina Central.

Set your token in `Config.toml`:

```toml
HF_TOKEN = "<YOUR_HF_TOKEN>"
```

## Running an example

From an example package directory:

```bash
bal run
```

## Building examples against the local module

From the `examples/` directory:

```bash
./build.sh build   # build all examples
./build.sh run     # run all examples
```

## Using custom models

Replace the model ID in the resource path. Path segments with hyphens must be escaped:

```ballerina
string modelId = "your-org/your-model";
check hfClient->/hf\-inference/models/[modelId]/summarization.post({inputs: "..."});
```

Ensure the model supports the selected task on the Hugging Face Inference Providers router.
