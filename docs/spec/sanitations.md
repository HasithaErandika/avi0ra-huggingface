Author: @HasithaErandika
Created: 2026-03-10
Updated: 2026-06-18
Edition: Swan Lake

# Sanitations

Changes made to the generated Ballerina client after OpenAPI code generation.

## OpenAPI specification changes (`openapi.yaml`)

### Security scheme
- Added `bearerAuth` security requirement globally to enforce authentication on all endpoints.

### Schema modifications
- Added `x-ballerina-name` annotations to snake_case fields for proper Ballerina naming convention mapping:
  - `max_tokens` → `maxTokens`
  - `max_new_tokens` → `maxNewTokens`
  - `return_full_text` → `returnFullText`
  - `num_inference_steps` → `numInferenceSteps`
  - `min_length` → `minLength`
  - `max_length` → `maxLength`
  - `entity_group` → `entityGroup`
  - `finish_reason` → `finishReason`
  - `candidate_labels` → `candidateLabels`
  - `summary_text` → `summaryText`
  - `generated_text` → `generatedText`
  - `translation_text` → `translationText`

## `client.bal` changes

- Added proper error handling for skipped tests (ASR, image generation, image classification)
- Added `io:println` statements for test debugging output

## `types.bal` changes

- No manual modifications required; types are generated correctly with `x-ballerina-name` annotations.

## `utils.bal` changes

- No modifications required; standard URI encoding utility generated as expected.

---

## Client Generation Commands

The following commands are used to generate the Ballerina client from the OpenAPI specification. Run from the repository root directory:

**Step 1 - Flatten the OpenAPI definition:**
```bash
bal openapi flatten -i docs/spec/openapi.yaml -o docs/spec
```

**Step 2 - Align the flattened definition:**
```bash
bal openapi align -i docs/spec/flattened_openapi.yaml -o docs/spec
```

After alignment, remove `openapi.yaml`, `flattened_openapi.yaml` from `docs/spec/` and rename `aligned_ballerina_openapi.yaml` to `openapi.yaml`.

**Step 3 - Generate the Ballerina client:**
```bash
bal openapi -i docs/spec/openapi.yaml --mode client --license docs/license.txt -o ballerina/
```

---

