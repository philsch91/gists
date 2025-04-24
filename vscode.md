# Visual Studio Code

```
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt
code --list-extensions --show-versions --ignore-certificate-errors
```

## Extensions
```
F1 > <extension-name> : <command>
F1 > Extensions: Install VSIX...
F1 > Network Proxy Test: Test Connection
F1 > Network Proxy Test: Show OS Certificates
```

## User Settings

- Windows: `/c/Users/<username>/AppData/Roaming/Code/User/settings.json`<br />
- Linux: `$HOME/.config/Code/User/settings.json`<br />
- macOS: `$HOME/Library/Application Support/Code/User/settings.json`<br />

## Workspace Settings

`<dir>/.vscode/settings.json`

## VS Code Settings

```
{
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
    "workbench.colorTheme": "Flatland Monokai"
}
```

## vscode-java

```
{
    "java.jdt.ls.vmargs": "",
    "java.autobuild.enabled": false,
    "java.semanticHighlighting.enabled": true,
    "java.configuration.checkProjectSettingsExclusions": false
}
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
