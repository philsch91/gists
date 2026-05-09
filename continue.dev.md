# Continue

## Files
```
# macOS
/Users/<username>/.continue/config.yaml
```

## config.yaml
```yaml
name: "Main Local Config"
version: 0.0.1
schema: v1
# pre-configured models
models:
  - uses: ollama/deepseek-r1-32b
  - uses: ollama/qwen2.5-coder-7b
  - uses: ollama/gpt-oss-20b
# auto detect models
models:
  - name: Autodetect
    provider: ollama
    model: AUTODETECT
    apiBase: http://localhost:11434 # optional for remote
    roles:
      - chat
      - edit
      - apply
      - rerank
      - autocomplete
# custom-configured models
models:
  - name: DeepSeek R1 32B
    provider: ollama
    model: deepseek-r1:32b # must match exactly what `ollama list` shows
    apiBase: http://localhost:11434
    roles:
      - chat
      - edit
    capabilities: # add if not auto-detected
      - tool_use
  - name: Qwen2.5-Coder 1.5B
    provider: ollama
    model: qwen2.5-coder:1.5b
    roles:
      - autocomplete
```
