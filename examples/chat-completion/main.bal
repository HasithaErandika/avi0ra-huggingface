import ballerina/io;
import avi0ra/huggingface;

configurable string HF_TOKEN = ?;

public function main() returns error? {
    huggingface:Client hf = check new ({auth: {token: HF_TOKEN}});

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