# ollama

## Variables
```
export OLLAMA_HOST="0.0.0.0:11434" # server
export OLLAMA_HOST="http://localhost:11434" # client
export OLLAMA_ORIGINS="localhost, 127.0.0.1, 0.0.0.0., app://, file://"
export OLLAMA_MODELS="$HOME/.ollama/models"
export OLLAMA_KEEP_ALIVE="24h"
export OLLAMA_NUM_PARALLEL="0" # 0 = unlimited
export OLLAMA_MAX_LOADED_MODELS="0" # 0 = unlimited
export OLLAMA_FLASH_ATTENTION="1" # reduce VRAM usage during inference, experimental
export OLLAMA_LLM_LIBRARY=""
export OLLAMA_TMPDIR=""
export OLLAMA_MAX_QUEUE="512"
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
ollama list
ollama run <model-name>
```

## list
```
curl -s https://ollama.com/library | grep -oP 'href="/library/\K[^"]+'
curl -s https://ollama.com/library/qwen3.5/tags | grep -o "$1:[^\" ]*q[^\" ]*" | grep -E -v 'text|base|fp|q[45]_[01]'
curl -s https://ollama.com/library/qwen3.6/tags | grep -o "$1:[^\" ]*q[^\" ]*" | grep -E -v 'text|base|fp|q[45]_[01]'
```

## pull
```
ollama pull deepseek-r1:latest  # latest/default version
ollama pull deepseek-r1:32b     # 32B parameter version
ollama pull qwen2.5-coder:1.5b
ollama pull qwen3.5:9b-q4_K_M
ollama pull qwen3.6:35b-a3b-q4_K_M
ollama pull mistral:latest

# list downloaded models
ollama list
```

## create
```
ollama create <name> -f ./Modelfile
```

## launch
```
ollama launch vscode [--model <model-name>:<tag>]
ollama launch vscode --model qwen3.5:cloud
ollama launch vscode --model deepseek-r1:32b
ollama launch vscode --model qwen2.5-coder:1.5b
```
