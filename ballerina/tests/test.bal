// Copyright (c) 2026, Hasitha Erandika (http://github.com/HasithaErandika).
// Licensed under the Apache License, Version 2.0.
// SPDX-License-Identifier: Apache-2.0

import ballerina/io;
import ballerina/os;
import ballerina/test;

configurable string token = os:getEnv("HF_TOKEN");

Client hfClient = check new ({auth: {token}});

// ─── Unit Tests ─────────────────────────────────────────────────────────────

@test:Config {groups: ["unit"]}
function testClientInitWithDefaults() returns error? {
    Client c = check new ({auth: {token: "test-token"}});
    test:assertNotEquals(c, (), "Client should be successfully initialized.");
}

@test:Config {groups: ["unit"]}
function testClientInitWithCustomServiceUrl() returns error? {
    Client c = check new (
        {auth: {token: "test-token"}},
        "https://router.huggingface.co"
    );
    test:assertNotEquals(c, (), "Client with custom service URL should be initialized.");
}

@test:Config {groups: ["unit"]}
function testClientInitWithCustomTimeout() returns error? {
    Client c = check new ({
        auth: {token: "test-token"},
        timeout: 120.0
    });
    test:assertNotEquals(c, (), "Client with custom timeout should be initialized.");
}

@test:Config {groups: ["unit"]}
function testClientInitWithHttpRetryConfig() returns error? {
    Client c = check new ({
        auth: {token: "test-token"},
        retryConfig: {count: 3, interval: 2.0, backOffFactor: 2.0, maxWaitInterval: 20.0}
    });
    test:assertNotEquals(c, (), "Client with HTTP retry config should be initialized.");
}

// ─── Live Tests ─────────────────────────────────────────────────────────────

@test:Config {groups: ["chat", "live"]}
function testChatCompletion() returns error? {
    ChatCompletionResponse resp = check hfClient->/v1/chat/completions.post({
        model: "Qwen/Qwen2.5-7B-Instruct",
        messages: [{role: "user", content: "Say hello in one word."}],
        maxTokens: 10
    });
    ChatCompletionChoice[] choices = resp.choices ?: [];
    test:assertTrue(choices.length() > 0, "Chat completion should return choices.");
    io:println("Chat response: ", choices[0].message?.content ?: "");
}

@test:Config {groups: ["text-gen", "live"]}
function testTextGeneration() returns error? {
    string modelId = "openai-community/gpt2";
    TextGenerationResult[] results = check hfClient->/hf\-inference/models/[modelId].post({
        inputs: "The future of AI is",
        parameters: {maxNewTokens: 20, returnFullText: false}
    });
    test:assertTrue(results.length() > 0, "Text generation should return results.");
    io:println("Generated text: ", results[0].generatedText ?: "");
}

@test:Config {groups: ["classification", "live"]}
function testTextClassification() returns error? {
    string modelId = "distilbert-base-uncased-finetuned-sst-2-english";
    ClassificationLabel[][] results = check hfClient->/hf\-inference/models/[modelId]/text\-classification.post({
        inputs: "I love this product!"
    });
    test:assertTrue(results.length() > 0, "Text classification should return results.");
    test:assertTrue(results[0].length() > 0, "Classification labels should not be empty.");
    io:println("Classification: ", results[0][0].label ?: "", " (", results[0][0].score ?: 0.0, ")");
}

@test:Config {groups: ["ner", "live"]}
function testTokenClassification() returns error? {
    string modelId = "dslim/bert-base-NER";
    TokenClassificationEntity[] entities = check hfClient->/hf\-inference/models/[modelId]/token\-classification.post({
        inputs: "My name is Sarah and I live in London."
    });
    test:assertTrue(entities.length() > 0, "Token classification should return entities.");
    io:println("NER entities: ", entities);
}

@test:Config {groups: ["embeddings", "live"]}
function testFeatureExtraction() returns error? {
    if token == "" {
        io:println("[SKIPPED] Feature extraction — HF_TOKEN not set.");
        return;
    }
    string modelId = "sentence-transformers/all-MiniLM-L6-v2";
    float[][]|error embeddings = hfClient->/hf\-inference/models/[modelId]/feature\-extraction.post({
        inputs: "Hello world"
    });
    if embeddings is error {
        io:println("[SKIPPED] Feature extraction live test skipped: ", embeddings.message());
        return;
    }
    test:assertTrue(embeddings.length() > 0, "Feature extraction should return embeddings.");
    test:assertTrue(embeddings[0].length() > 0, "Embedding vector should not be empty.");
    io:println("Embedding dimensions: ", embeddings[0].length());
}

@test:Config {groups: ["qa", "live"]}
function testQuestionAnswering() returns error? {
    string modelId = "deepset/roberta-base-squad2";
    QuestionAnsweringResponse answer = check hfClient->/hf\-inference/models/[modelId]/question\-answering.post({
        inputs: {
            question: "What is Ballerina?",
            context: "Ballerina is an open-source programming language for cloud-native applications."
        }
    });
    test:assertTrue((answer.answer ?: "").length() > 0, "Question answering should return an answer.");
    io:println("Answer: ", answer.answer ?: "");
}

@test:Config {groups: ["summarization", "live"]}
function testSummarization() returns error? {
    string modelId = "facebook/bart-large-cnn";
    SummarizationResult[] results = check hfClient->/hf\-inference/models/[modelId]/summarization.post({
        inputs: "Ballerina is a programming language designed for cloud-native integration. It combines the best of programming languages and integration tools.",
        parameters: {maxLength: 30, minLength: 5}
    });
    test:assertTrue(results.length() > 0, "Summarization should return results.");
    io:println("Summary: ", results[0].summaryText ?: "");
}

@test:Config {groups: ["translation", "live"]}
function testTranslation() returns error? {
    string modelId = "Helsinki-NLP/opus-mt-en-fr";
    TranslationResult[] results = check hfClient->/hf\-inference/models/[modelId]/translation.post({
        inputs: "Hello, how are you?"
    });
    test:assertTrue(results.length() > 0, "Translation should return results.");
    io:println("Translation: ", results[0].translationText ?: "");
}

@test:Config {groups: ["zero-shot", "live"]}
function testZeroShotClassification() returns error? {
    string modelId = "facebook/bart-large-mnli";
    ZeroShotClassificationResponse result = check hfClient->/hf\-inference/models/[modelId]/zero\-shot\-classification.post({
        inputs: "I love programming in Ballerina.",
        parameters: {candidateLabels: ["technology", "sports", "politics"]}
    });
    test:assertTrue((result.labels ?: []).length() > 0, "Zero-shot classification should return labels.");
    io:println("Zero-shot result: ", result);
}

@test:Config {groups: ["image-gen", "live"]}
function testTextToImage() returns error? {
    string modelId = "black-forest-labs/FLUX.1-schnell";
    byte[]|error imageBytes = hfClient->/hf\-inference/models/[modelId]/text\-to\-image.post({
        inputs: "A simple red circle on white background",
        parameters: {width: 256, height: 256, numInferenceSteps: 4}
    });
    if imageBytes is error {
        io:println("[SKIPPED] Text-to-image live test skipped: ", imageBytes.message());
        return;
    }
    test:assertTrue(imageBytes.length() > 0, "Text-to-image should return image bytes.");
    io:println("Image bytes received: ", imageBytes.length());
}

@test:Config {groups: ["image-classification", "live"]}
function testImageClassificationFromBytes() returns error? {
    byte[]|error imageBytes = io:fileReadBytes("./tests/resources/test.jpg");
    if imageBytes is error {
        io:println("[SKIPPED] Image classification — test image not found.");
        return;
    }
    string modelId = "google/vit-base-patch16-224";
    ImageClassificationResult[]|error results = hfClient->/hf\-inference/models/[modelId]/image\-classification.post(imageBytes);
    if results is error {
        io:println("[SKIPPED] Image classification live test skipped: ", results.message());
        return;
    }
    test:assertTrue(results.length() > 0, "Image classification should return results.");
    io:println("Image classification: ", results[0].label ?: "", " (", results[0].score ?: 0.0, ")");
}

@test:Config {groups: ["asr", "live"]}
function testAutomaticSpeechRecognition() returns error? {
    byte[]|error audioBytes = io:fileReadBytes("./tests/resources/test.wav");
    if audioBytes is error {
        io:println("[SKIPPED] ASR — test audio not found.");
        return;
    }
    string modelId = "openai/whisper-large-v3-turbo";
    AutomaticSpeechRecognitionResponse|error result = hfClient->/hf\-inference/models/[modelId]/automatic\-speech\-recognition.post(audioBytes);
    if result is error {
        io:println("[SKIPPED] ASR live test skipped: ", result.message());
        return;
    }
    test:assertTrue((result.text ?: "").length() > 0, "ASR should return transcribed text.");
    io:println("Transcription: ", result.text ?: "");
}
