# ollama

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
# start Ollama (runs in background)
export OLLAMA_HOST="0.0.0.0:11434"
ollama serve
# verify if ollama is running
curl -iSs http://localhost:11434
```

## run
```
export OLLAMA_HOST="http://localhost:11434"
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
