# Visual Studio Code

```
# environment variables
echo $DBUS_SESSION_BUS_ADDRESS
echo $XDG_CURRENT_DESKTOP
# export XDG_CURRENT_DESKTOP=GNOME
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/ca-certificates.crt

# start
code --ignore-certificate-errors .
code --list-extensions --show-versions --ignore-certificate-errors

# start verbose
code --ignore-certificate-errors [--password-store="gnome-libsecret|kwallet5|basic"] --verbose --vmodule="*/components/os_crypt/*=1" . > /tmp/vscode-output.log 2>&1 &
```

## Extensions
```
F1 > <extension-name> : <command>
F1 > Extensions: Install VSIX...
F1 > Network Proxy Test: Test Connection
F1 > Network Proxy Test: Show OS Certificates
```

- vscjava.vscode-java-pack
- ms-vscode.cpptools-extension-pack
- github.copilot-chat
- cschlosser.doxdocgen

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
