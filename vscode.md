# Visual Studio Code

## Files
```
ls -lah /usr/share/code/
ls -lah /usr/local/bin/code
ls -lah $(which code)
ls -lah /usr/local/bin/codium
ls -lah $(which codium)
ls -lah /home/<username>/.config/Code/
ps -ef | grep /usr/share/code | less
```

## Variables
```
# environment variables
echo $DBUS_SESSION_BUS_ADDRESS
echo $XDG_CURRENT_DESKTOP
# export XDG_CURRENT_DESKTOP=GNOME
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
```

## Commands
```
# start
code --ignore-certificate-errors [-n(new window)] .|/path/to/folder|[/path/to/]file.txt
code --list-extensions --show-versions --ignore-certificate-errors

# start verbose
code --ignore-certificate-errors [--password-store="gnome-libsecret|kwallet5|basic"] --verbose --vmodule="*/components/os_crypt/*=1" . > /tmp/vscode-output.log 2>&1 &
```

## VSX Extensions
```
F1 > <extension-name> : <command>
F1 > Extensions: Install VSIX...
F1 > Preferences: Open User Settings Settings
F1 > Preferences: Open User Settings Settings (JSON)
F1 > Developer: Reload Window
F1 > Network Proxy Test: Test Connection
F1 > Network Proxy Test: Show OS Certificates
```

### AI extensions
- github.copilot-chat # formerly github.copilot
- continue.continue # https://open-vsx.org/extension/Continue/continue
### Java + CPP extensions
- vscjava.vscode-java-pack
- vscjava.vscode-gradle
- madhavd1.javadoc-tools
- ms-vscode.cpptools-extension-pack
- ms-vscode.makefile-tools
### Python extensions
- ms-python.python
- ms-python.vscode-pylance
- ms-python.debugpy
- ms-python.vscode-python-envs
### PowerShell extensions
- ms-vscode.powershell
- ms-vscode-remote.remote-wsl
### Kubernetes extensions
- ms-kubernetes-tools.vscode-kubernetes-tools
### File format extensions
- redhat.vscode-yaml
- redhat.vscode-xml
### Additional extensions
- cschlosser.doxdocgen
- marlon407.code-groovy
- yzhang.markdown-all-in-one
- cliffordfajardo.hightlight-selections-vscode
- gerane.theme-flatlandmonokai
- humao.rest-client

## App Settings
```
# Windows
$HOME/AppData/Roaming/Code/settings.json
```

## User Settings
```
# Linux
$HOME/.config/Code/User/settings.json
$HOME/.config/VSCodium/User/settings.json
# macOS
$HOME/Library/Application\ Support/Code/User/settings.json
$HOME/Library/Application\ Support/VSCodium/User/settings.json
# Windows
/c/Users/<username>/AppData/Roaming/Code/User/settings.json
/c/Users/<username>/AppData/Roaming/VSCodium/User/settings.json
```

## Workspace Settings

`<dir>/.vscode/settings.json`

## VS Code Settings
```
{
    "update.mode": "none",
    "update.enableWindowsBackgroundUpdates": false,
    "files.eol": "\n",
    "files.exclude": {
        "**/.classpath": true,
        "**/.project": true,
        "**/.settings": true,
        "**/.factorypath": true
    },
    "editor.detectIndentation": false,
    "editor.insertSpaces": false,
    "editor.tabSize": 4,
    "editor.indentSize": 4,
    "editor.indentSize.alt": "tabSize",
    "editor.suggestSelection": "first",
    "editor.renderControlCharacters": false,
    "editor.selectionHighlight": false,
    "editor.occurrencesHighlight": "off",
    "editor.occurrencesHighlight.alt": "singleFile|multiFile",
    "workbench.colorTheme": "Flatland Monokai",
    "github.copilot.chat.githubMcpServer.enabled": true,
    "mcp": {
        "servers": {
            "atlassian-jira-mcp-server": {
                "type": "stdio",
                "command_win": "C:\\dev\\python-venv\\Scripts\\python.exe",
                "command": "/mnt/c/dev/python-venv/bin/python",
                "args_win": [
                    "C:\\dev\\python-tests\\test-atlassian-jira-mcp-server.py"
                ],
                "args": [
                    "/mnt/c/dev/python-tests/test-atlassian-jira-mcp-server.py"
                ]
                "env": {
                    "JIRA_CA_BUNDLE": "C:\\Users\\<username>\\Desktop\\Root-CA.cer",
                    "JIRA_BASE_URL": "<jira-base-url>",
                    "JIRA_BEARER_TOKEN": "<jira-token>"
                }
            }
        }
    }
}
```

## VS Code MCP Config
```
# Windows
# $HOME/AppData/Roaming/Code/User/mcp.json
# Linux
# $HOME/.config/Code/User/mcp.json

{
    "servers": {
        "atlassian-confluence-mcp-server": {
            "type": "stdio",
            "command": "uv",
            "args": [
                "run",
                "/mnt/c/dev/python-tests/test-atlassian-confluence-mcp-server.py"
            ],
            "env": {
                "CONFLUENCE_CA_BUNDLE": "/home/<username>/Root-CA.pem",
                "CONFLUENCE_BASE_URL": "<confluence-base-url>",
                "CONFLUENCE_BEARER_TOKEN": "<confluence-token>"
            }
        },
        "atlassian-jira-mcp-server": {
            "type": "stdio",
            "command": "C:\\dev\\python-venv\\Scripts\\python.exe",
            "args": [
                "C:\\dev\\python-tests\\test-atlassian-jira-mcp-server.py"
            ],
            "env": {
                "JIRA_CA_BUNDLE": "C:\\Users\\<username>\\Desktop\\Root-CA.cer",
                "JIRA_BASE_URL": "<jira-base-url>",
                "JIRA_BEARER_TOKEN": "<jira-token>"
            }
        }
    }
}
```

## github.copilot-chat
```
# memory-tool
~/.config/Code/User/workspaceStorage/<session-id>/GitHub.copilot-chat/memory-tool/memories/repo/<class>_<method>_<yyyy-mm-dd>.md
Tool `manage_todo_list` (`functions.manage_todo_list` API) tracks and updates the todos.
```

### github.copilot-chat + ollama
```
VSCode >= 1.113
github.copilot-chat >= 0.41.0
Ollama >= v0.18.3
```

## vscode-java

### vscode-java settings
```
{
    "java.jdt.ls.java.home": "/usr/lib/jvm/java-21-openjdk-amd64",
    "java.jdt.ls.vmargs": "",
    "java.autobuild.enabled": false,
    "java.semanticHighlighting.enabled": true,
    "java.configuration.checkProjectSettingsExclusions": false,
    "java.configuration.updateBuildConfiguration": "automatic",
    "java.configuration.updateBuildConfiguration_alt": "interactive",
    "java.configuration.maven.userSettings": "/home/a4938/.m2/settings.xml",
    "java.maven.downloadSources": true,
    "java.compile.nullAnalysis.mode": "automatic",
    "java.project.sourcePaths": [
        "src/main/java",
        "/tmp/<artifact>-generated-sources/protobuf/java",
        "/tmp/<artifact>-generated-sources/protobuf/grpc-java"
    ],
    "maven.executable.path": "/usr/bin/mvn"
}
```

### vscode-java commands
```
Java: Clean Java Language Server Workspace
Java: Import Java Projects into Workspace
Java: Update Project Source Attachment
Java: Update Project Configuration
Developer: Reload Window
```

## vscode-dotnet-runtime
```
{
    "dotnetAcquisitionExtension.existingDotnetPath": [
        {
            "extensionId": "ms-dotnettools.csdevkit",
            "path": "C:\\Program Files\\dotnet\\dotnet.exe"
        },
        {
            "extensionId": "ms-dotnettools.vscodeintellicode-csharp",
            "path": "C:\\Program Files\\dotnet\\dotnet.exe"
        },
        {
            "extensionId": "ms-dotnettools.csharp",
            "path": "C:\\Program Files\\dotnet\\dotnet.exe"
        },
        {
            "extensionId": "ms-dotnettools.vscode-dotnet-runtime",
            "path": "C:\\Program Files\\dotnet\\dotnet.exe"
        }
    ],
    "dotnetAcquisitionExtension.installTimeoutValue": 180
}
```

## Logs
```
find $HOME/AppData/Roaming/Code/logs/ -type f -name "*copilot-chat*.log" -print0 | xargs -0 grep -i "error"
```

## Keys
```
# select multiple lines
Win: Ctrl+Alt+Arrow
Linux: Shift+Alt+Arrow
```
