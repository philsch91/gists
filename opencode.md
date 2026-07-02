# OpenCode

```
which opencode
# /Users/<username>/.opencode/bin/opencode
# /home/<username>/.local/bin/opencode
opencode -v
opencode debug paths
opencode --print-logs
opencode --log-level DEBUG
opencode -d # start with debug logging
opencode -c </path/to/directory> # start with specific current work dir
# opencode non-interactive prompt mode
# -q = quiet, -f = format
opencode -p "What is the tech stack of the current project" [-q] [-f text|json]
opencode run "Add error handling to the API calls in src/client.py"
# upgrade
opencode upgrade
```

## Files
```
# Linux
/home/<username>/.config/opencode/opencode.json
/home/<username>/.local/state/opencode/log/opencode.log
/home/<username>/.local/share/opencode/log/opencode.log
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

### opencode.json
```
# Linux: /home/<username>/.config/opencode/opencode.json
# macOS: /Users/<username>/.config/opencode/opencode.jsonc
## provider.<name>.options.timeout is in ms or false
## provider.<name>.options.chunkTimeout is in ms or disabled with 0
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
    },
    "ollama-remote": {
      "npm": "@ai-sdk/openai-compatible",
      "options": {
        "baseURL": "https://ollama.subdomain.tld/v1",
        "apiKey": ""
        "timeout": 9007199254740991,
        "headerTimeout": false,
        "chunkTimeout": 9007199254740991,
        "extraParams": {
          "reasoning_effort": "none",
          "num_ctx": 32768
        }
      },
      "models": {
        "qwen3.5:4b-q4_K_M": {
          "name": "qwen3.5:4b-q4_K_M"
        },
        "qwen3.5:9b-q4_K_M": {
          "name": "qwen3.5:9b-q4_K_M",
          "tools": true,
          "reasoning": true
        },
        "frob/qwen3.5-instruct:4b": {
          "name": "frob/qwen3.5-instruct:4b"
        }
      }
    }
  }
}
```

## Variables
```
export AI_TIMEOUT=600000
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
/init --model <model-name(frob/qwen3.5-instruct:4b)>
/skills
/exit
[Tab] # switch between "Build" and "Plan" modes
```
