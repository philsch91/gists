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
curl -fsSL https://ollama.ai/install.sh | sh
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
```

## run
```
export OLLAMA_HOST="http://localhost:11434"
ollama ps
ollama list
ollama run <model-name>
```

## pull
```
ollama pull deepseek-r1:latest  # latest/default version
ollama pull deepseek-r1:32b     # 32B parameter version
ollama pull qwen2.5-coder:1.5b
ollama pull mistral:latest

# list downloaded models
ollama list
```

## launch
```
ollama launch vscode [--model <model-name>:<tag>]
ollama launch vscode --model qwen3.5:cloud
ollama launch vscode --model deepseek-r1:32b
ollama launch vscode --model qwen2.5-coder:1.5b
```
