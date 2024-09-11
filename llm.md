# llm

## Installation

1. `ln -s /usr/bin/pip3 /usr/bin/pip3.8`
2. `ls -lah /usr/bin/pip*`
3. `pip install llm`
4. `which llm`
5. `gcc --version`
6. Apple Silicon macOS: `CMAKE_ARGS="-DLLAMA_METAL=on" FORCE_CMAKE=1 llm install llama-cpp-python`<br />
   Nvidia CUDA: `CMAKE_ARGS="-DLLAMA_CUBLAS=on" llm install llama-cpp-python`<br />
   OpenBLAS: `CMAKE_ARGS="-DLLAMA_BLAS=ON -DLLAMA_BLAS_VENDOR=OpenBLAS" llm install llama-cpp-python`<br />
   CLBLast: `CMAKE_ARGS="-DLLAMA_CLBLAST=on" llm install llama-cpp-python`<br />
   AMD ROCm: `CMAKE_ARGS="-DLLAMA_HIPBLAS=on" llm install llama-cpp-python`<br />
   no GPU acceleration: `llm install llama-cpp-python`<br />
   pip (secondary option): `pip install llama-cpp-python`<br />
7. `llm install llm-llama-cpp`

## models-dir

1. `llm llama-cpp models-dir`

## models-file

1. `llm llama-cpp models-file`

## Install model

### download-model

1. `llm llama-cpp download-model https://huggingface.co/LiteLLMs/Llama-3-8B-Web-GGUF/resolve/main/Q6_K/Q6_K-00001-of-00001.gguf --alias llama3-8b-web --alias llama38bw --alias l3-8b-w --alias l3-8-w`

### add-model

1. `cp -rv /path/to/<model-file>.gguf "$(llm llama-cpp models-dir/)"`
2. `llm llama-cpp add-model "$(llm llama-cpp models-dir/<model-file>.gguf)" --alias <alias1 (llama-3-8b-web)> --alias <alias2 (llama-3-8-w)> --alias <alias3 (l-3-8-w)> --alias <alias4 (l38w)>`

## models

1. `llm llama-cpp models`

## Execute models

```
llm -m llama3-8b-web "three funny names for a pet hedgehog"

// models without chat training
llm -m llama3-8b-web "Three funny names for a pet hedgehog are:"

// options
llm -m llama3-8b-web "three funny names for a pet hedgehog" [-o verbose 1] [-o max_tokens 100 (default=4000)] [-o no_gpu 1 (removes default `n_gpu_layers 1` argument and disables GPU usage)] [-o n_gpu_layers 10 (default=1)] [-o n_ctx 1024 (default=4000)]
```
