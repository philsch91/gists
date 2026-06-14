# OpenCode

```
which opencode
/Users/<username>/.opencode/bin/opencode
opencode --print-logs
opencode upgrade
opencode run "Add error handling to the API calls in src/client.py"
```

## Files
```
/Users/<username>/.config/opencode/opencode.jsonc
/Users/<username>/.config/opencode/plugins/
/Users/<username>/.local/state/opencode/model.json
/Users/<username>/.local/share/opencode/auth.json
/Users/<username>/.local/share/opencode/project/
/Users/<username>/.local/share/opencode/log/
/Users/<username>/.cache/opencode/models.json
/Users/<username>/Library/Application Support
```

### opencode.jsonc
```
# /Users/<username>/.config/opencode/opencode.jsonc

{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio (local)",
      "options": {
        "baseURL": "http://127.0.0.1:1234/v1",
        "apiKey": "xyz"
      },
      "models": {
        "qwen3.6-27b": {
          "name": "mlx-community/Qwen3.6-27B-4bit (local)"
        }
      }
    }
  }
}
```

## Commands
```
/connect
/models
/skills
/exit
```
