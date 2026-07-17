# Claude Code

```
which claude
claude --version
claude --resume
claude --continue
claude --max-steps 50
claude --add-dir ../shared-config
claude mcp add <name> --scope user|project|local(=dir-specific) --transport stdio|http|sse ...
claude mcp add <name> --transport stdio --env ENV_VAR_NAME=ENV_VAR_VALUE -- <command> | npx -y mcp-server
claude mcp add <name> --transport http http://127.0.0.1:3845/mcp

# uv run fastmcp run
claude mcp add <python-fastmcp-server> --scope user --transport sse http://127.0.0.1:8000/sse | --transport http http://localhost:8000/mcp --env ENV_VAR_1=ENV_VAR_VALUE --env ENV_VAR_2=ENV_VAR_VALUE -- uv run --with fastmcp [--with requests --with pandas] fastmcp run fastmcp-server.py

# uv run
claude mcp add <python-fastmcp-server> --scope user [--transport stdio] --env ENV_VAR_1=ENV_VAR_VALUE --env ENV_VAR_2=ENV_VAR_VALUE -- uv run [python] fastmcp-server.py

# python
claude mcp add <python-fastmcp-server> --scope user [--transport stdio] --env ENV_VAR_1=ENV_VAR_VALUE --env ENV_VAR_2=ENV_VAR_VALUE -- python3 fastmcp-server.py

claude mcp list
claude mcp remove <mcp-server>
```

## Environment variables
```
echo $CLAUDE_ENV_FILE
# recommended
export CLAUDE_CODE_NEW_INIT=1
# optional
export CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD=1
export CLAUDE_CODE_DISABLE_AUTO_MEMORY=1
export CLAUDE_CONFIG_DIR="~/.claude.json"
export CLAUDE_CODE_SHELL="/bin/bash" # /bin/zsh
```

## Files

- `/etc/claude-code/CLAUDE.md` or `/Library/Application Support/ClaudeCode/CLAUDE.md` or `C:\Program Files\ClaudeCode\CLAUDE.md`
- `~/.claude/CLAUDE.md` # personal preferences
- `~/.claude.json` (mcp --scope user (.mcpServers) |local (.projects.<fs-path>.mcpServers))
- `~/.claude/settings.json`
- `~/.claude/settings.local.json` # local specifics
- `~/.claude/projects/<project-path>/<session-id>.jsonl`
- `~/.claude/projects/<project-path>/memory/`
- `~/.claude/agents/`
- `~/.claude/agent-memory/<name-of-agent>/`
- `$(pwd)/CLAUDE.md` or `$(pwd)/.claude/CLAUDE.md`
- `$(pwd)/CLAUDE.local.md` # personal project-specific preferences
- `$(pwd)/.claude/settings.json`
- `$(pwd)/.claude/settings.local.json`
- `$(pwd)/.claude/agents/`
- `$(pwd)/.mcp.json` (mcp --scope project)

### CLAUDE.md

The CLAUDE.md file is always loaded, processed and included in every turn.

- Instructions
- Architecture rules
- Naming conventions
- Test expectations
- Repo map

Tokens = words x 1.25
Target: less than < 1500 tokens or 200 lines
```
wc -w $(pwd)/CLAUDE.md # or $(pwd)/.claude/CLAUDE.md
wc -w $(pwd)/CLAUDE.local.md
```

#### CLAUDE.md example
```
# CLAUDE.md
See @README.md for project overview and @package.json for available npm commands for this project.

## Agents
@AGENTS.md
## Additional Instructions
- git workflow @docs/git-instructions.md
## Individual Preferences
- @~/.claude/CLAUDE.md
```

#### CLAUDE.md prompts
```
- Always use pnpm, not npm and add this to CLAUDE.md
```

## Project Structure
```
project/
├── .claude/
│   ├── CLAUDE.md # Main project instructions
│   ├── settings.json
│   ├── memory/
│   |   ├── MEMORY.md # memory index with a list of links and descriptions to memory files
│   |   ├── project-docs-filenames.md # memory file with name, description, metadata.node_type: memory, metadata.type: project, metadata.originSessionId: xyz
│   |   └── user-environment.md # memory file
│   ├── rules/
│   |   ├── code-style.md # Code style guidelines
│   |   ├── testing.md # Testing conventions
│   |   └── security.md # Security requirements
│   ├── skills/
│   |   ├── code-review
|   |       └── SKILL.md
│   |   ├── refactor
|   |       └── SKILL.md
│   |   └── release
|   |       └── SKILL.md
│   ├── hooks/
│   |   ├── code-style.md
│   |   ├── testing.md
│   |   └── security.md
│   ├── agents/ # subagent files in markdown with name, description, tools and model in YAML frontmatter
│   |   ├── code-reviewer.md
│   |   ├── debugger.md
│   |   └── tester.md
│   └── agent-memory/
│       ├── code-reviewer/
│       ├── debugger/
│       └── tester/
├── tools/
│   ├── scripts/
│   └── prompts/
├── docs/
│   ├── architecture.md
│   ├── specification.md
│   ├── decisions/
│   └── runbooks/
└── src/
```

## Commands
```
/init
/status
/update-config # updates ~/.claude/settings.json
/setup-bedrock
/edit .claude/settings.json
## resume
/rename # for /resume
/resume
/memory # verify if CLAUDE.md and CLAUDE.local.md files are loaded
/batch <"commands" | -f tasks.md> ## tasks.md: # Tasks\n- [ ] Task1\n- [ ] Task2
## usage
/usage
/stats
## mcp
/mcp [disable <server>]
## skills
/skills
## hooks
/hooks
## plugin
/plugin [disable <plugin-name>]
### list known (configured) repository marketplaces
/plugin marketplace list
### add repository and update repository URL
### in ~/.claude/plugins/known_marketplaces.json
### and in ~/.claude/plugins/marketplaces/<repository-marketplace-name>
/plugin marketplace add https://<url>.**git**
### view repository URL
/plugin marketplace update
### update repository plugins
/plugin marketplace update <repository-name>
### install plugin (+ skills) from known repository marketplaces
/plugin install <plugin-name>
### uninstall plugin
/plugin uninstall <plugin-name>
## agents
/agents # create agents interactively
## tasks
/tasks
/claude-api
## settings
/effort
/model
/btw
/exit
```

## Projects
```
ls -lht ~/.claude/projects/$(pwd | sed 's/[^a-zA-Z0-9]/-/g')/*.jsonl
```

## Hooks
```
cat ~/.claude/settings.json | jq '.hooks'
cat ~/.claude/settings.local.json | jq '.hooks'
cat $(pwd)/.claude/settings.json | jq '.hooks'
cat $(pwd)/.claude/settings.local.json | jq '.hooks'
/plugin disable <plugin-name>
```

### ~/.claude/hooks/claude-env-file-hook.sh
```
#!/bin/bash
# ~/.claude/hooks/claude-env-file-hook.sh
# register this hook script in ~/.claude/settings(.local).json
# at .hooks.SessionStart[].hooks[]
# with {"type": "command", "command": "bash ~/.claude/hooks/claude-env-file-hook.sh"}
echo "CLAUDE_ENV_FILE: '$CLAUDE_ENV_FILE'" >> /tmp/claude_code_debug.log
```

## .gitignore
```
CLAUDE.local.md
.claude/settings.local.json
.env
```
