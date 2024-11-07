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

## vscode-java

```
{
    "java.autobuild.enabled": false
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
