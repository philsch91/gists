# OpenCode

```
which opencode
# /Users/<username>/.opencode/bin/opencode
# /home/<username>/.local/bin/opencode
opencode --print-logs
opencode --log-level DEBUG
opencode upgrade
opencode run "Add error handling to the API calls in src/client.py"
```

## Files
```
# Linux
/home/<username>/.config/opencode/opencode.json
/home/<username>/.local/state/opencode/log/opencode.log
# macOS
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

# /home/<username>/.config/opencode/opencode.json
{
  "provider": {
    "ollama-remote": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "https://ollama.subdomain.tld/v1",
        "extraParams": {
          "reasoning_effort": "none"
        }
      },
      "models": {
        "qwen3.5:4b-q4_K_M": {
          "name": "qwen3.5:4b-q4_K_M"
        },
        "qwen3.5:9b-q4_K_M": {
          "name": "qwen3.5:9b-q4_K_M"
        },
        "frob/qwen3.5-instruct:4b": {
          "name": "frob/qwen3.5-instruct:4b"
        }
      }
    }
  }
}
```

## Install
```
# opencode 1
curl -fsSL https://opencode.ai/install | bash
# opencode 2
curl -o "/tmp/opencode-linux-x64.tar.gz" -L https://github.com/anomalyco/opencode/releases/download/v1.17.12/opencode-linux-x64.tar.gz
mkdir -pv /tmp/opencode
tar -C /tmp/opencode -xvf /tmp/opencode-linux-x64.tar.gz
rm -v /tmp/opencode-linux-x64.tar.gz
ls -lah /tmp/opencode
cp -v /tmp/opencode/opencode ~/.local/bin/
rm -rv /tmp/opencode
# opencode Desktop
apt install ./opencode-desktop-linux-amd64.deb
apt remove opencode
```

## Commands
```
/connect
/models
/sessions
/skills
/exit
[Tab] # switch between "Build" and "Plan" modes
```
