# Claw Code Agent — Local Model Usage Guide

This guide explains how to run Claw Code Agent with a local model via LM Studio, providing a **Claude Code-like** terminal experience using the `clawcode` command.

---

## Overview

```
                 +-----------------+
  Terminal       |   LM Studio     |
  clawcode  ---> |   (port 1234)   |
  (any dir)      |   OpenAI API    |
                 +---------+-------+
                           |
                 +---------v----------------------------+
                 |  Qwen3.5-35B-A3B-Uncensored (GGUF)  |
                 |  MoE: 35B total / ~3B active         |
                 +--------------------------------------+
```

**Stack:**
- **Agent:** Claw Code Agent (Python, zero dependencies)
- **Inference Server:** LM Studio (OpenAI-compatible API)
- **Model:** [HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive) (Q5_K_M GGUF)

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| Python | 3.10 or higher |
| LM Studio | v0.4.5+ (Qwen3 tool calling support) |
| GGUF Model | Downloaded in LM Studio's model directory |
| GPU VRAM | 16GB+ recommended (Q4_K_M ~20GB, Q5_K_M ~24GB) |

---

## Step 1: Download the Model

Download the GGUF quantization that fits your GPU from HuggingFace:

| Quantization | Size | Recommended For |
|--------------|------|-----------------|
| Q4_K_M | ~20 GB | 24 GB VRAM (e.g. RTX 4090) |
| Q5_K_M | ~24 GB | 32 GB+ VRAM |
| Q6_K | ~27 GB | 48 GB VRAM |
| Q8_0 | ~35 GB | 48 GB+ VRAM |

Place the GGUF file in the LM Studio models directory, for example:

```
C:\Users\<user>\.lmstudio\models\HauhauCS\Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive\
```

---

## Step 2: Configure LM Studio

1. Open **LM Studio**
2. Go to the **Developer** tab
3. Load the model `Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive`
4. Set **Context Length** to `32768` (increase if VRAM allows, model supports up to 262K natively)
5. Maximize **GPU Offload Layers** for best performance
6. Click **Start Server** (default port: `1234`)

Verify the server is running:

```bash
curl http://localhost:1234/v1/models
```

Take note of the model ID returned — you may need it for configuration.

---

## Step 3: Set Up the `clawcode` Command

The repository includes a `clawcode.cmd` script that wraps all optimal parameters. To use it from any directory:

**Add the project directory to your PATH:**

```powershell
# PowerShell (run once)
[Environment]::SetEnvironmentVariable(
    'Path',
    [Environment]::GetEnvironmentVariable('Path', 'User') + ';D:\Python\claw-code-agent',
    'User'
)
```

> Replace `D:\Python\claw-code-agent` with your actual project path.

**Restart your terminal** for the PATH change to take effect.

---

## Step 4: Use It

Open a terminal, navigate to any project directory, and type:

```bash
cd D:\Projects\my-project
clawcode
```

That's it. The agent starts in interactive chat mode with full tool calling capabilities in your current directory.

### What Happens Under the Hood

The `clawcode` command runs:

```bash
python -m src.main agent-chat ^
  --model HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive ^
  --base-url http://localhost:1234/v1 ^
  --api-key lm-studio ^
  --temperature 0.6 ^
  --top-p 0.95 ^
  --top-k 20 ^
  --strip-thinking-tags ^
  --timeout-seconds 300 ^
  --allow-write --allow-shell ^
  --cwd <your current directory>
```

### Passing Extra Flags

You can append any additional flags after `clawcode`:

```bash
# Enable streaming output
clawcode --stream

# Override temperature
clawcode --temperature 1.0

# Run a one-shot prompt instead of interactive chat
# (edit clawcode.cmd: change agent-chat to agent, then pass prompt)
python -m src.main agent "Explain this codebase" ^
  --base-url http://localhost:1234/v1 --api-key lm-studio ^
  --temperature 0.6 --top-p 0.95 --top-k 20 ^
  --strip-thinking-tags --cwd .
```

---

## Model Parameters

The default parameters are optimized for **coding tasks** based on the model card recommendations:

| Parameter | Value | Purpose |
|-----------|-------|---------|
| `--temperature` | 0.6 | Precise yet creative output for code generation |
| `--top-p` | 0.95 | Nucleus sampling — avoids low-quality tokens |
| `--top-k` | 20 | Limits candidate token pool |
| `--presence-penalty` | *(not set)* | Not needed for coding tasks |
| `--strip-thinking-tags` | enabled | Removes `<think>...</think>` blocks from output |
| `--timeout-seconds` | 300 | Local inference can be slower than cloud APIs |

### Alternative Parameter Presets

**General conversation (thinking mode):**
```
--temperature 1.0 --top-p 0.95 --top-k 20 --presence-penalty 1.5
```

**Non-thinking mode (direct responses):**
```
--temperature 0.7 --top-p 0.8 --top-k 20 --presence-penalty 1.5
```

---

## Customizing `clawcode.cmd`

Edit `clawcode.cmd` in the project root to change defaults:

```cmd
@echo off
set "CLAWCODE_HOME=D:\Python\claw-code-agent"    &REM <-- your project path
set "PYTHONPATH=%CLAWCODE_HOME%;%PYTHONPATH%"

python -m src.main agent-chat ^
  --model <model-id-from-lm-studio> ^             &REM <-- match LM Studio model ID
  --base-url http://localhost:1234/v1 ^            &REM <-- LM Studio default port
  --api-key lm-studio ^
  --temperature 0.6 ^
  --top-p 0.95 ^
  --top-k 20 ^
  --strip-thinking-tags ^
  --timeout-seconds 300 ^
  --allow-write --allow-shell ^
  --cwd "%CD%" ^
  %*
```

Key things you might want to change:

| Field | When to Change |
|-------|---------------|
| `CLAWCODE_HOME` | If you cloned the repo to a different path |
| `--model` | If LM Studio reports a different model ID (check `curl http://localhost:1234/v1/models`) |
| `--base-url` | If LM Studio runs on a different port |
| `--timeout-seconds` | Increase if responses are timing out on slower hardware |
| `--allow-write --allow-shell` | Remove for read-only mode |

---

## New CLI Flags Added

This setup adds the following CLI flags to the upstream claw-code-agent (available on all `agent` and `agent-chat` commands):

| Flag | Type | Default | Description |
|------|------|---------|-------------|
| `--top-p` | float | *(none)* | Nucleus sampling threshold |
| `--top-k` | int | *(none)* | Top-K sampling limit |
| `--min-p` | float | *(none)* | Minimum probability threshold |
| `--presence-penalty` | float | *(none)* | Repetition presence penalty |
| `--strip-thinking-tags` | flag | off | Remove `<think>...</think>` from model output |

When a parameter is not set, it is omitted from the API request and the backend uses its own default.

---

## Troubleshooting

### "clawcode" is not recognized

- Ensure `D:\Python\claw-code-agent` is in your PATH
- **Restart your terminal** after modifying PATH
- Verify: `where clawcode.cmd`

### Connection refused / timeout

- Ensure LM Studio server is running (Developer tab → Start Server)
- Verify: `curl http://localhost:1234/v1/models`
- Check that the port matches `--base-url` in `clawcode.cmd`

### Model ID mismatch

LM Studio may report a different model ID than expected. Check:

```bash
curl http://localhost:1234/v1/models
```

Update the `--model` value in `clawcode.cmd` to match the `id` field in the response.

### Tool calling not working

- Ensure LM Studio version is **0.4.5 or later** (earlier versions had Qwen3 chat template issues)
- The Qwen3.5 model family supports XML-format tool calling natively via LM Studio

### Out of memory

- Reduce context length in LM Studio (e.g. 16384 instead of 32768)
- Use a smaller quantization (Q4_K_M instead of Q5_K_M)
- Reduce GPU offload layers to use CPU for some layers

### Response contains `<think>` blocks

- Ensure `--strip-thinking-tags` is included in your command
- This flag removes the model's internal reasoning blocks from the output

---

## Files Modified (vs upstream)

| File | Change |
|------|--------|
| `src/agent_types.py` | `ModelConfig` extended with `top_p`, `top_k`, `min_p`, `presence_penalty`, `strip_thinking_tags` |
| `src/openai_compat.py` | API payload sends new sampling params; `_strip_thinking_tags()` filters `<think>` blocks |
| `src/main.py` | New CLI flags: `--top-p`, `--top-k`, `--min-p`, `--presence-penalty`, `--strip-thinking-tags` |
| `src/session_store.py` | Serialization/deserialization updated for new fields (backward compatible) |
| `src/agent_runtime.py` | Streaming path applies think-tag stripping |
| `clawcode.cmd` | Launcher script with pre-configured optimal parameters |
