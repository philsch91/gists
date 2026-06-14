# LM Studio

## Files
```
/Users/<username>/.lmstudio/models
/Users/<username>/.lmstudio/models/<publisher>/<model>/model-file.gguf
/Users/<username>/.lmstudio/bin/lms
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
