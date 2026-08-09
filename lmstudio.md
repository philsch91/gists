# LM Studio

## Files
```
/Users/<username>/.lmstudio/models
/Users/<username>/.lmstudio/models/<publisher>/<model>/model-file.gguf
/Users/<username>/.lmstudio/bin/lms
$HOME/.lmstudio/settings.json
```

### settings.json
```
{
  "language": "en",
  "downloadsFolder": "/Users/philipp/.lmstudio/models",
  "sidebar": {
    "showButtonNames": false,
    "monochromeSidebarIcons": true
  },
  "configs": {
    "expandConfigsOnClick": true
  },
  "chat": {
    "showSuggestionsOnNewChat": true,
    "allowOnlyOneNewChat": true,
    "alwaysShowPromptTemplate": false,
    "useShiftEnterToSendMessage": false,
    "useKeychordToRegenerate": true,
    "unloadPreviousModelOnSelect": true,
    "highlightChatMessageOnHover": true,
    "doubleClickMessageToEdit": false,
    "doubleClickChatCellRenames": false,
    "aiNamingMode": "auto",
    "autoExpandReasoningBlocks": false,
    "reasoningBlocksVignette": true,
    "messageGenInfoMode": "lastMessage",
    "visualizeSpeculativeDecoding": false,
    "chatFullWidth": false,
    "neverAskForToolConfirmation": false,
    "skipToolConfirmationPatterns": [],
    "showChatUtilityMenuLabels": true,
    "pinnedPlugins": [],
    "showRoleAndInsertButtons": false,
    "scrollLastMessageToTop": "scrollToTopNoLatch",
    "showTokenCountInChatListings": false,
    "moveDeletedItemsToTrash": false,
    "sidebarSort": {
      "field": "createdAt",
      "direction": "desc"
    },
    "showSpringboardWhenClosingAllTabsInSplit": false,
    "imageInputs": {
      "userMaxImageDimensionPixelsEnabled": true,
      "userMaxImageDimensionPixels": 2048,
      "ignoreModelPreferredMaxImageDimension": false
    }
  },
  "developer": {
    "showExperimentalFeatures": false,
    "experimentalLoadPresets": false,
    "showDebugInfoBlocksInChat": false,
    "showModelDownloadOptionData": false,
    "showResourceConsumptionWidget": false,
    "backendDownloadChannel": "stable",
    "appUpdateChannel": "stable",
    "allowDevelopmentPlugins": true,
    "unloadPreviousJITModelOnLoad": true,
    "jitModelTTL": {
      "enabled": true,
      "ttlSeconds": 3600
    },
    "autoUpdateExtensionPacks": true,
    "autoDeleteExtensionPacks": true,
    "separateReasoningContentInAPI": true,
    "experimentFlags": [],
    "apiPredictionHistoryEviction": {
      "type": "time",
      "ttlDays": 30
    },
    "attemptedInstallLmsCliOnStartup": true
  },
  "ui": {
    "missionControlFullscreen": false,
    "showModelFileNameInMyModels": false,
    "configureLoadParamsBeforeLoad": false,
    "alwaysOpenModelLoaderFromPicker": false,
    "contextDisplayMode": "percentage",
    "appNavigationBarPosition": "left",
    "showTabStripScrollBar": false,
    "tabStripFullStripStyle": false,
    "openDownloadsPaneOnStartNewModelDownload": false
  },
  "configPresetInclusiveness": {
    "speculativeDecoding": false
  },
  "toggledConfigDropdowns": [],
  "developerMode": true,
  "userInterfaceComplexityLevel": 0,
  "appFirstLoad": false,
  "autoLoadBundledLLM": true,
  "modelLoadingGuardrails": {
    "mode": "high",
    "customThresholdBytes": 4294967296,
    "alwaysAllowLoadAnyway": false
  },
  "dismissedModals": [
    "Mobile Onboarding",
    "LM Link Sidebar Button Popover"
  ],
  "cliInstalled": false,
  "useHFProxy": true,
  "hfSearchToken": "",
  "hfDownloadToken": "",
  "defaultContextLength": {
    "type": "max",
    "value": 8192
  }
}
```

## lms
```
which lms # /Users/<username>/.lmstudio/bin/lms
lms import <path/to/model.gguf>
# load model with custom ID returned by http://localhost:1234/v1/models
lms load qwen3.6-27b --identifier mlx-community-qwen3.6-27b
```

## hf
```
pip install --upgrade huggingface_hub
cd ~/.lmstudio/models/mlx-community/Llama-3-8B-Instruct-4bit
hf download mlx-community/Llama-3-8B-Instruct-4bit --local-dir .
```

## Server
```
http://localhost:1234/v1/models
```
