# ollama

## Files
```
# Linux
/usr/share/ollama/.models/
# macOS
/Users/<username>/.ollama/models
# Windows
C:\Users\<username>\.ollama\models\
```

## Variables
```
export OLLAMA_HOST="0.0.0.0:11434" # server
export OLLAMA_HOST="http://localhost:11434" # client
export OLLAMA_ORIGINS="localhost, 127.0.0.1, 0.0.0.0., app://, file://"
export OLLAMA_MODELS="$HOME/.ollama/models"
export OLLAMA_KEEP_ALIVE="24h"
export OLLAMA_NUM_PARALLEL="0" # 0 = unlimited
export OLLAMA_MAX_QUEUE="512" # default 512
export OLLAMA_MAX_LOADED_MODELS="0" # 0 = unlimited
export OLLAMA_FLASH_ATTENTION="1" # reduce VRAM usage during inference, experimental
export OLLAMA_LLM_LIBRARY=""
export OLLAMA_TMPDIR=""
export OLLAMA_MAX_VRAM="0" # 0 = unlimited
export OLLAMA_DEBUG=1
```

## install
```
# macOS
brew install ollama

# Linux
## Linux 1
curl -fsSL https://ollama.ai/install.sh | sh
## Linux 2
curl --show-error --location https://github.com/ollama/ollama/releases/download/v0.30.10/ollama-linux-amd64.tar.zst --output /tmp/ollama-linux-amd64.tar.zst
mkdir -pv /tmp/ollama
tar -C /tmp/ollama -xvf /tmp/ollama-linux-amd64.tar.zst
rm -v /tmp/ollama-linux-amd64.tar.zst
ls -lah /tmp/ollama
ls -lah /tmp/ollama/bin/
ls -lah /tmp/ollama/lib/ollama/
cp -v /tmp/ollama/bin/ollama /usr/bin/
cp -rv /tmp/ollama/lib/ollama /usr/lib/
rm -rv /tmp/ollama

# Windows
# Download from ollama.ai

# check version
ollama --version
ollama -h
ollama help <command>
# start Ollama (runs in background)
export OLLAMA_HOST="0.0.0.0:11434"
ollama serve
# verify if ollama is running
curl -iSs http://localhost:11434
curl -iSs http://localhost:11434/api/ps
curl -iSs http://localhost:11434/api/tags
```

## run
```
export OLLAMA_HOST="http://localhost:11434"
ollama ps
ollama run <model-name> [--think=false|true]
>>> /set nothink|think
>>> /save <model-name>-nothink

kubectl logs -l app.kubernetes.io/name=ollama -f|--tail 500 | grep -i "slots"
kubectl logs -l app.kubernetes.io/name=ollama -f|--tail 500 | grep -i "runner.parallel"

curl https://<hostname>/api/chat \
    -d '{"model": "<model-name>", "messages": [{"role": "user", "content": "Hello, describe the images", "images": ["'$(base64 -w0 image1.jpg)'"]}], "tools": [], "think": false, "stream": false, "options": []}'

# default: stream: false
curl https://<hostname>/v1/chat/completions \
    -d '{"model": "<model-name>", "messages": [{"role": "user", "content": "Hello, describe the images", "images": ["'$(base64 -w0 image1.jpg)'"]}], "tools": [], "tool_choice": "auto", "reasoning_effort": "none|low|medium|high", "stream": true, "options": [], "extra_body": {}}'
```

## list
```
ollama list
ollama rm <model-name>

curl -s https://ollama.com/library | grep -oP 'href="/library/\K[^"]+'
curl -s https://ollama.com/library/qwen3.5/tags | grep -o "$1:[^\" ]*q[^\" ]*" | grep -E -v 'text|base|fp|q[45]_[01]'
curl -s https://ollama.com/library/qwen3.6/tags | grep -o "$1:[^\" ]*q[^\" ]*" | grep -E -v 'text|base|fp|q[45]_[01]'
curl -X DELETE https://<hostname> -d '{"name": "<model-name>"}'
```

## pull
```
ollama pull deepseek-r1:latest  # latest/default version
ollama pull deepseek-r1:32b     # 32B parameter version
ollama pull qwen2.5-coder:1.5b
ollama pull qwen3.5:2b-q4_K_M
ollama pull qwen3.5:2b-q8_0
ollama pull qwen3.5:4b-q4_K_M
ollama pull qwen3.5:4b-q8_0
ollama pull qwen3.5:9b-q4_K_M
ollama pull qwen3.6:35b-a3b-q4_K_M
ollama pull mistral:latest

# list downloaded models
ollama list
```

## show
```
ollama show --modelfile <model-name> ./Modelfile

curl https://<hostname>/api/show -H 'Content-Type: application/json' -d '{"model": "<model-name>"}' | jq -r '.modelfile' >./Modelfile

curl -s $(echo $OLLAMA_HOST)/api/show -H 'Content-Type: application/json' -d '{"name": "qwen3.5-2b-q4_K_M-nothink-v1"}' | jq '{context_length: .model_info["llama.context_length"], parameters: .parameters, details: .details}'
```

## create
```
ollama create <model-name> -f ./Modelfile

curl https://<hostname> \
    -d '{
        "name": "<model-name>",
        "modelfile": "FROM qwen3.5:2b-q4_K_M\nPARAMETER thinking_mode off"
    }'
```

## Modelfile
```
FROM qwen3.5:4b-q4_K_M

# deactivate reasoning
PARAMETER thinking_mode "off"

# set context window length
# important for "finish_reason": "length"
PARAMETER num_ctx 2048

# set number of threads
PARAMETER num_thread 4

# set number of tokens for answer length
PARAMETER num_predict 256

# repeat_penalty
PARAMETER repeat_penalty 1.1

PARAMETER top_p 0.95
PARAMETER presence_penalty 1.5
PARAMETER temperature 1
PARAMETER top_k 20

# stop tokens to abort generation
PARAMETER stop "<think>"
PARAMETER stop "</think>"

TEMPLATE """{{ if .System }}<|im_start|>system
{{ .System }}<|im_end|>
{{ end }}{{ if .Prompt }}<|im_start|>user
/nothink {{ .Prompt }}<|im_end|>
{{ end }}<|im_start|>assistant
{{ .Response }}<|im_end|>"""

# set default system prompt
SYSTEM "You are a helpful assistant. Provide direct, concise answers. Do not use reasoning, thoughts, or <think> tags. Answer immediately."
SYSTEM "You are a helpful assistant. You must NEVER generate a `<think>` tag. You must NEVER output your thought process. Start your response directly with the final answer. If you use a `<think>` tag, the system will crash."
```

## launch
```
ollama launch vscode [--model <model-name>:<tag>]
ollama launch vscode --model qwen3.5:cloud
ollama launch vscode --model deepseek-r1:32b
ollama launch vscode --model qwen2.5-coder:1.5b
```

## OpenAI Python SDK
```
from openai import OpenAI

client = OpenAI(
    base_url="http://127.0.0.1:11433/v1",
    api_key="ollama",
)

messages = [
    {"role": "user", "content": "Hello world!"}
]

# /v1/chat/completions
chat_response = client.chat.completions.create(
    model="qwen3.5:2b",
    messages=messages,
    max_tokens=32768,
    temperature=0.7,
    top_p=0.8,
    presence_penalty=1.5,
    stream=false,
    reasoning_effort="none",
    extra_body={},
    functions=[],
    function_call=[],
)

print(chat_response.choices[0].message.content)

# "finish_reason": "tool_calls"
{
    "comment_type": "ChatCompletion",
    "id": "chatcmpl-122",
    "object": "chat.completion",
    "model": "qwen3.5:4b-q4_K_M",
    choices: [
        {
            "comment_choice_type": "Choice",
            "index": 0,
            "finish_reason": "tool_calls",
            "message": {
                "comment_message_type": "ChatCompletionMessage",
                "content": "",
                "refusal": null,
                "role": "assistant",
                "function_call": null,
                "tool_calls": [
                    {
                        "comment_tool_call_type": "ChatCompletionMessageFunctionToolCall",
                        "index": 0,
                        "type": "function",
                        "id": "call_wn6l11xh",
                        "function": {
                            "comment_function_type": "Function",
                            "name": 'search_pages_and_get_text',
                            "arguments": '{"arg1":["test","ignore"],"arg2":"arg2_val","arg3":"arg3_val","arg4":1}'
                        }
                    }
                ]
            }
        }
    ]
}

# "finish_reason": "stop"
{
    "id": "chatcmpl-123",
    "object": "chat.completion",
    "created": 1782729029,
    "model": "qwen3.5:4b-q4_K_M",
    "system_fingerprint": "fp_ollama",
    "choices": [
        {
            "index": 0,
            "message": {
                "role": "assistant", "content": "Hello..."
            },
            "finish_reason": "stop"
        }
    ],
    "usage": {
        "prompt_tokens": 19,
        "completion_tokens": 116,
        "total_tokens": 135
    }
}

# stream /v1/chat/completions
response_stream = client.chat.completions.create(
    model="qwen3.5:2b",
    messages=messages,
    stream=true
    reasoning_effort="none",
)

for chunk in response_stream:
    if chunk.choices[0].delta.content is not None:
        print(chunk.choices[0].delta.content, end="", flush=True)
print()

# "finish_reason": null + "finish_reason": "stop"
{
    "id": "chatcmpl-124",
    "object": "chat.completion.chunk",
    "created": 1782728953,
    "model": "qwen3.5:4b-q4_K_M",
    "system_fingerprint": "fp_ollama",
    "choices": [
        {
            "index": 0,
            "delta": {
                "role": "assistant",
                "content": "."
            },
            "finish_reason": null
        }
    ]
}

{
    "id": "chatcmpl-124",
    "object": "chat.completion.chunk",
    "created": 1782728953,
    "model": "qwen3.5:4b-q4_K_M",
    "system_fingerprint": "fp_ollama",
    "choices": [
        {
            "index": 0,
            "delta":{
                "role": "assistant",
                "content": ""
            },
            "finish_reason": "stop"
        }
    ]
}
```
