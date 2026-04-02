<p align="center">
  <img src="images/logo.png" alt="Claw Code Agent logo" width="420" />
</p>

<h1 align="center">Claw Code Agent</h1>

<p align="center">
  <em>A Python reimplementation of the Claude Code agent architecture — local models, full control.</em>
</p>

<p align="center">
  <a href="https://www.python.org/downloads/"><img src="https://img.shields.io/badge/python-3.10%2B-3776AB?logo=python&logoColor=white" alt="Python 3.10+"></a>
  <a href="https://github.com/HarnessLab/claw-code-agent"><img src="https://img.shields.io/badge/repo-HarnessLab%2Fclaw--code--agent-181717?logo=github" alt="GitHub"></a>
  <a href="https://docs.vllm.ai/"><img src="https://img.shields.io/badge/backend-vLLM-FF6F00?logo=lightning&logoColor=white" alt="vLLM"></a>
  <a href="https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct"><img src="https://img.shields.io/badge/model-Qwen3--Coder-FFD21E?logo=huggingface&logoColor=black" alt="Qwen3-Coder"></a>
  <img src="https://img.shields.io/badge/status-alpha-orange" alt="Alpha">
  <img src="https://img.shields.io/badge/license-open--source-green" alt="License">
</p>

---

## 📖 About

This repository reimplements the [Claude Code](https://docs.anthropic.com/en/docs/claude-code) npm agent architecture **entirely in Python**, designed to run with **local open-source models** via an OpenAI-compatible API server.

Built on the public porting workspace from [instructkr/claw-code](https://github.com/instructkr/claw-code), the active development lives at [HarnessLab/claw-code-agent](https://github.com/HarnessLab/claw-code-agent).

> **Goal:** Not to ship the original npm source, but to reimplement the full agent flow in Python — prompt assembly, context building, slash commands, tool calling, session persistence, and local model execution.

<p align="center">
  <img src="images/demo_2.gif" alt="Claw Code Agent demo" width="900" />
</p>

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🤖 **Agent Loop** | Full agentic coding loop with tool calling and iterative reasoning |
| 🧰 **Core Tools** | File read / write / edit, glob search, grep search, shell execution |
| 💬 **Slash Commands** | Local commands: `/help`, `/context`, `/tools`, `/memory`, `/status`, `/model`, and more |
| 🧠 **Context Engine** | Automatic context building with CLAUDE.md discovery and usage reporting |
| 🔄 **Session Persistence** | Save and resume agent sessions across runs |
| 🔐 **Permission System** | Granular control: `--allow-write`, `--allow-shell`, `--unsafe` |
| 🏗️ **OpenAI-Compatible Runtime** | Python client targets an OpenAI-compatible API, with `vLLM` as the documented setup |
| 🐉 **Qwen3-Coder** | First-class support for `Qwen3-Coder-30B-A3B-Instruct` via vLLM |

---

## 📋 Roadmap

### Done

- [x] Python CLI agent loop
- [x] OpenAI-compatible local model backend
- [x] Qwen3-Coder support through vLLM with `qwen3_xml` tool parser
- [x] Core tools: `list_dir`, `read_file`, `write_file`, `edit_file`, `glob_search`, `grep_search`, `bash`
- [x] Context building and `/context`-style usage reporting
- [x] Slash commands: `/help`, `/context`, `/context-raw`, `/prompt`, `/permissions`, `/model`, `/tools`, `/memory`, `/status`, `/clear`
- [x] Session persistence and `agent-resume` flow
- [x] Permission system (read-only, write, shell, unsafe tiers)
- [x] Unit tests for the Python runtime
- [x] `pyproject.toml` packaging with `setuptools`

### In Progress

- [ ] Full MCP support
- [ ] Full plugin system
- [ ] Full slash-command parity
- [ ] Full interactive REPL / TUI behavior
- [ ] Exact tokenizer / context accounting
- [ ] Hooks parity
- [ ] Remote modes parity
- [ ] Voice / VIM parity
- [ ] Some deeper runtime details from the npm source
- [ ] Cost tracking and budget limits

## 🔎 Detailed Parity Status Against npm `src`

This section tracks what is already implemented in Python and what is still missing compared with the upstream npm runtime in [`/src`](/data/fs201059/aa17626/claude_code_source/src).

This is a functionality-oriented checklist, not a line-by-line source equivalence claim. Large parts of the mirrored Python workspace still act as inventory or scaffolding, while the working Python runtime currently lives mainly in [`src/agent_runtime.py`](/data/fs201059/aa17626/claude_code_source/claw-code/src/agent_runtime.py), [`src/agent_tools.py`](/data/fs201059/aa17626/claude_code_source/claw-code/src/agent_tools.py), [`src/agent_prompting.py`](/data/fs201059/aa17626/claude_code_source/claw-code/src/agent_prompting.py), [`src/agent_context.py`](/data/fs201059/aa17626/claude_code_source/claw-code/src/agent_context.py), [`src/agent_slash_commands.py`](/data/fs201059/aa17626/claude_code_source/claw-code/src/agent_slash_commands.py), and [`src/openai_compat.py`](/data/fs201059/aa17626/claude_code_source/claw-code/src/openai_compat.py).

### 1. Core Agent Runtime

Done:

- [x] One-shot agent loop with iterative tool calling
- [x] OpenAI-compatible `chat/completions` client
- [x] Local-model execution against `vLLM`
- [x] Local-model execution through `Ollama`
- [x] Local-model execution through `LiteLLM Proxy`
- [x] Transcript-aware session object for the Python runtime
- [x] Session save and resume support
- [x] Configurable max-turn execution
- [x] Permission-aware tool execution

Missing:

- [ ] Streaming token-by-token assistant output
- [ ] Partial tool-result streaming
- [ ] Rich transcript mutation behavior like the npm runtime
- [ ] Structured output / JSON schema response modes
- [ ] Reasoning budgets and task budgets
- [ ] Cost accounting and usage budget enforcement
- [ ] Multi-agent orchestration parity
- [ ] File history snapshots and replay flows
- [ ] Scratchpad integration
- [ ] Plugin cache integration in the query engine
- [ ] Session compaction / snipping behavior
- [ ] Full `QueryEngine.ts` parity

### 2. CLI Entrypoints And Runtime Modes

Done:

- [x] Python CLI entrypoint
- [x] `agent` command
- [x] `agent-resume` command
- [x] `agent-prompt` command
- [x] `agent-context` command
- [x] `agent-context-raw` command
- [x] Inventory/helper commands such as `summary`, `manifest`, `commands`, and `tools`

Missing:

- [ ] Daemon worker mode
- [ ] Background session mode
- [ ] Session process listing (`ps`)
- [ ] Background session logs
- [ ] Background attach flow
- [ ] Background kill flow
- [ ] Remote-control / bridge runtime mode
- [ ] Browser/native-host runtime mode
- [ ] Computer-use MCP mode
- [ ] Template job mode
- [ ] Environment runner mode
- [ ] Self-hosted runner mode
- [ ] tmux fast paths
- [ ] Worktree fast paths at the CLI entrypoint level
- [ ] Full `entrypoints/cli.tsx` and `entrypoints/init.ts` parity

### 3. Prompt Assembly

Done:

- [x] Structured Python system prompt builder
- [x] Intro/system/task/tool/tone/output sections
- [x] Session-specific prompt guidance
- [x] Environment-aware prompt sections
- [x] User context reminder injection
- [x] Custom system prompt override and append support

Missing:

- [ ] Full parity with `constants/prompts.ts`
- [ ] Hook instruction sections
- [ ] MCP instruction sections
- [ ] Model-family-specific prompt variations
- [ ] Output-style variants
- [ ] Language-control sections
- [ ] Scratchpad prompt instructions
- [ ] More exact autonomous/proactive behavior sections
- [ ] Growthbook / feature-gated prompt sections
- [ ] Cyber / risk sections used upstream

### 4. Context Building And Memory

Done:

- [x] Current working directory snapshot
- [x] Shell / platform / date capture
- [x] Git status snapshot
- [x] `CLAUDE.md` discovery
- [x] Extra directory injection through `--add-dir`
- [x] Session context usage report
- [x] Raw context inspection command

Missing:

- [ ] Tokenizer-accurate context accounting
- [ ] Full parity with `utils/queryContext.ts`
- [ ] Rich memory prompt loading
- [ ] Internal permission-aware memory handling
- [ ] Resume-aware prompt cache shaping used upstream
- [ ] More exact context cache invalidation rules
- [ ] Session context analysis parity
- [ ] Full memory subsystem parity

### 5. Slash Commands

Done:

- [x] `/help`
- [x] `/commands`
- [x] `/context`
- [x] `/usage`
- [x] `/context-raw`
- [x] `/env`
- [x] `/prompt`
- [x] `/system-prompt`
- [x] `/permissions`
- [x] `/model`
- [x] `/tools`
- [x] `/memory`
- [x] `/status`
- [x] `/session`
- [x] `/clear`

Missing:

- [ ] Full npm slash-command surface
- [ ] Slash commands backed by MCP integration
- [ ] Slash commands tied to task/plan systems
- [ ] Slash commands tied to remote/background sessions
- [ ] Slash commands with richer interactive behavior
- [ ] Slash commands tied to plugins and bundled skills
- [ ] Slash commands tied to settings, config, and account state

### 6. Built-in Tools

Done:

- [x] `list_dir`
- [x] `read_file`
- [x] `write_file`
- [x] `edit_file`
- [x] `glob_search`
- [x] `grep_search`
- [x] `bash`

Missing:

- [ ] Agent spawning tool
- [ ] Skill tool
- [ ] Notebook edit tool
- [ ] Web fetch tool
- [ ] Web search tool
- [ ] Todo write tool
- [ ] Ask-user-question tool
- [ ] LSP tool
- [ ] MCP resource listing tool
- [ ] MCP resource read tool
- [ ] Tool search tool
- [ ] Config tool
- [ ] Task create/get/update/list tools
- [ ] Team create/delete tools
- [ ] Send-message tool
- [ ] Terminal capture tool
- [ ] Browser tool
- [ ] Workflow tool
- [ ] Remote trigger tool
- [ ] Sleep / cron tools
- [ ] PowerShell tool parity
- [ ] Worktree enter/exit tools
- [ ] Full `tools.ts` parity

### 7. Commands And Task Systems

Done:

- [x] Basic local command dispatch for the Python runtime
- [x] Inventory view of mirrored command names

Missing:

- [ ] Real implementation of the larger upstream command tree
- [ ] Task orchestration system
- [ ] Planner / task execution parity
- [ ] Team / collaboration command flows
- [ ] Background task management
- [ ] Command-specific session behaviors
- [ ] Full `src/commands/*` parity
- [ ] Full `src/tasks/*` parity

### 8. Permissions, Hooks, And Policy

Done:

- [x] Read-only default mode
- [x] Write-gated mode
- [x] Shell-gated mode
- [x] Unsafe mode for destructive shell actions

Missing:

- [ ] Hooks runtime
- [ ] Tool-permission workflow parity
- [ ] Policy limit loading
- [ ] Managed settings loading
- [ ] Trust-gated initialization
- [ ] Safe environment loading parity
- [ ] More exact denial tracking
- [ ] Hook-config management
- [ ] Full hooks and policy parity

### 9. MCP, Plugins, And Skills

Done:

- [x] Placeholder mirrored package layout for plugins, skills, services, and remote subsystems

Missing:

- [ ] Real MCP client support
- [ ] MCP server integration
- [ ] MCP resource listing and reading
- [ ] MCP-backed tools
- [ ] Plugin discovery and loading
- [ ] Bundled plugin support
- [ ] Plugin lifecycle management
- [ ] Plugin update/cache behavior
- [ ] Skill discovery and execution parity
- [ ] Bundled skill support
- [ ] Full plugin and skill parity

### 10. Interactive UI / REPL / TUI

Done:

- [x] Non-interactive CLI execution
- [x] Transcript printing for debugging

Missing:

- [ ] Interactive REPL parity
- [ ] Ink/TUI component parity
- [ ] Screen system parity
- [ ] Keyboard interaction parity
- [ ] Interactive status panes
- [ ] Approval UI flows
- [ ] Rich incremental rendering
- [ ] Full `components`, `screens`, and `ink` parity

### 11. Remote, Background, And Team Features

Done:

- [x] Session save/resume on local disk

Missing:

- [ ] Remote execution modes
- [ ] Background agent processes
- [ ] Background attach/log/kill workflows
- [ ] Team runtime features
- [ ] Team messaging features
- [ ] Shared remote state
- [ ] Upstream proxy runtime integration
- [ ] Full `remote`, `server`, `bridge`, `upstreamproxy`, and team parity

### 12. Editor, Platform, And Native Integrations

Done:

- [x] Standard shell-based local workflow

Missing:

- [ ] Voice mode parity
- [ ] VIM mode parity
- [ ] Keybinding parity
- [ ] Notification hooks
- [ ] Native TypeScript / platform helper parity
- [ ] JetBrains/editor integration parity
- [ ] Browser/native host integrations
- [ ] Platform-specific startup/shutdown logic

### 13. Services And Internal Subsystems

Done:

- [x] Minimal internal service layer required by the current Python runtime

Missing:

- [ ] Real service implementations for the mirrored `services` package
- [ ] Config service parity
- [ ] Account/auth service parity
- [ ] Analytics/telemetry service parity
- [ ] Growthbook/feature-flag parity
- [ ] GitHub / git helper parity
- [ ] Sandbox/settings utility parity
- [ ] Todo/task utility parity
- [ ] Internal helpers used by the upstream runtime

### 14. Mirrored Workspace Versus Working Runtime

Working Python runtime today:

- [x] `src/main.py`
- [x] `src/agent_runtime.py`
- [x] `src/agent_tools.py`
- [x] `src/agent_prompting.py`
- [x] `src/agent_context.py`
- [x] `src/agent_context_usage.py`
- [x] `src/agent_session.py`
- [x] `src/agent_slash_commands.py`
- [x] `src/agent_types.py`
- [x] `src/openai_compat.py`
- [x] `src/session_store.py`
- [x] `src/permissions.py`

Mirrored inventory / scaffold areas that still need real implementation work:

- [ ] `src/commands.py`
- [ ] `src/tools.py`
- [ ] `src/query_engine.py`
- [ ] `src/runtime.py`
- [ ] `src/services/*`
- [ ] `src/plugins/*`
- [ ] `src/remote/*`
- [ ] `src/voice/*`
- [ ] `src/vim/*`
- [ ] Large parts of the rest of the mirrored package tree

### 15. High-Priority Next Steps

- [ ] Expand the real Python tool registry toward upstream `tools.ts`
- [ ] Replace more snapshot-backed mirrored modules with working runtime code
- [ ] Implement real MCP support
- [ ] Implement hooks and policy flows
- [ ] Build a real interactive REPL / TUI
- [ ] Add tokenizer-accurate context accounting
- [ ] Add background and remote session modes
- [ ] Port more of the command/task system
- [ ] Close the gap between the mirrored workspace and the working runtime

---

## 🏗️ Architecture

```text
claw-code/
├── README.md
├── pyproject.toml
├── .gitignore
├── images/
│   └── logo.png
├── src/                          # Python implementation
│   ├── main.py                   # CLI entry point & argument parsing
│   ├── agent_runtime.py          # Core agent loop (LocalCodingAgent)
│   ├── agent_tools.py            # Tool definitions & execution engine
│   ├── agent_prompting.py        # System prompt assembly
│   ├── agent_context.py          # Context building & CLAUDE.md discovery
│   ├── agent_context_usage.py    # Context usage estimation & reporting
│   ├── agent_session.py          # Session state management
│   ├── agent_slash_commands.py   # Local slash command processing
│   ├── agent_types.py            # Shared dataclasses & type definitions
│   ├── openai_compat.py          # OpenAI-compatible API client
│   ├── session_store.py          # Session serialization & persistence
│   ├── permissions.py            # Tool permission filtering
│   ├── tools.py                  # Mirrored tool inventory
│   ├── commands.py               # Mirrored command inventory
│   ├── ...                       # 75+ modules across 30+ packages
│   ├── plugins/                  # Plugin subsystem (WIP)
│   ├── hooks/                    # Hook system (WIP)
│   ├── remote/                   # Remote runtime modes (WIP)
│   ├── voice/                    # Voice mode (WIP)
│   └── vim/                      # VIM mode (WIP)
└── tests/                        # Unit tests
    ├── test_agent_runtime.py
    ├── test_agent_context.py
    ├── test_agent_context_usage.py
    ├── test_agent_prompting.py
    ├── test_agent_slash_commands.py
    └── test_porting_workspace.py
```

---

## 📦 Requirements

| Requirement | Details |
|-------------|---------|
| 🐍 Python | `3.10` or higher |
| 🖥️ Model Server | `vLLM`, `Ollama`, or `LiteLLM Proxy`, with tool calling support |
| 🧠 Model | [`Qwen/Qwen3-Coder-30B-A3B-Instruct`](https://huggingface.co/Qwen/Qwen3-Coder-30B-A3B-Instruct) (recommended) |

---

## 🚀 Quick Start

### 1. Start vLLM with Qwen3-Coder

vLLM must be started with automatic tool choice enabled. Use the `qwen3_xml` parser for Qwen3-Coder tool calling:

```bash
python -m vllm.entrypoints.openai.api_server \
  --model Qwen/Qwen3-Coder-30B-A3B-Instruct \
  --host 127.0.0.1 \
  --port 8000 \
  --enable-auto-tool-choice \
  --tool-call-parser qwen3_xml
```

Verify the server is running:

```bash
curl http://127.0.0.1:8000/v1/models
```

> 📚 **References:** [vLLM Tool Calling Docs](https://docs.vllm.ai/en/v0.13.0/features/tool_calling/) · [OpenAI-Compatible Server](https://docs.vllm.ai/en/v0.13.0/serving/openai_compatible_server.html)

### Optional: Use Ollama Instead of vLLM

`claw-code-agent` can also work with Ollama because the runtime targets an OpenAI-compatible API. Use a model that supports tool calling well.

Example:

```bash
ollama serve
ollama pull qwen3
```

Then configure:

```bash
export OPENAI_BASE_URL=http://127.0.0.1:11434/v1
export OPENAI_API_KEY=ollama
export OPENAI_MODEL=qwen3
```

Notes:

- prefer tool-capable models such as `qwen3`
- plain chat-only models are not enough for full agent behavior
- Ollama does not use the `vLLM` parser flags shown above

> 📚 **References:** [Ollama OpenAI Compatibility](https://docs.ollama.com/api/openai-compatibility) · [Ollama Tool Calling](https://docs.ollama.com/capabilities/tool-calling)

### Optional: Use LiteLLM Proxy

`claw-code-agent` can also work through LiteLLM Proxy because the runtime targets an OpenAI-compatible chat completions API. The routed model still needs to support tool calling for full agent behavior.

Quick start example:

```bash
pip install 'litellm[proxy]'
litellm --model ollama/qwen3
```

LiteLLM Proxy runs on port `4000` by default. Then configure:

```bash
export OPENAI_BASE_URL=http://127.0.0.1:4000
export OPENAI_API_KEY=anything
export OPENAI_MODEL=ollama/qwen3
```

Notes:

- LiteLLM Proxy gives you an OpenAI-style gateway in front of many providers
- tool use still depends on the underlying routed model and provider behavior
- if you configure a LiteLLM master key, use that instead of `anything`

> 📚 **References:** [LiteLLM Docs](https://docs.litellm.ai/) · [LiteLLM Proxy Quick Start](https://docs.litellm.ai/)

### 2. Configure Environment

```bash
export OPENAI_BASE_URL=http://127.0.0.1:8000/v1
export OPENAI_API_KEY=local-token
export OPENAI_MODEL=Qwen/Qwen3-Coder-30B-A3B-Instruct
```

### Use Another Model With vLLM

If you want to try another model, keep the same `vLLM` server setup and change the `--model` value when you launch `vLLM`.

Example:

```bash
python -m vllm.entrypoints.openai.api_server \
  --model your-model-name \
  --host 127.0.0.1 \
  --port 8000 \
  --enable-auto-tool-choice \
  --tool-call-parser your_parser
```

Then update:

```bash
export OPENAI_MODEL=your-model-name
```

Notes:

- the documented path in this repository is `vLLM`
- the model must support tool calling well enough for agent use
- some model families require a different `--tool-call-parser`
- slash commands such as `/help`, `/context`, and `/tools` are local and do not require the model server

### 3. Run the Agent

```bash
# Read-only question
python3 -m src.main agent \
  "Read src/agent_runtime.py and summarize how the loop works." \
  --cwd .

# Write-enabled task
python3 -m src.main agent \
  "Create TEST_QWEN_AGENT.md with one line: test ok" \
  --cwd . --allow-write

# Shell-enabled task
python3 -m src.main agent \
  "Run pwd and ls src, then summarize the result." \
  --cwd . --allow-shell
```

---

## 🛠️ Usage

### Agent Commands

| Command | Description |
|---------|-------------|
| `agent <prompt>` | Run the agent with a prompt |
| `agent-prompt` | Show the assembled system prompt |
| `agent-context` | Show estimated context usage |
| `agent-context-raw` | Show the raw context snapshot |
| `agent-resume <id> <prompt>` | Resume a saved session |

### CLI Flags

| Flag | Description |
|------|-------------|
| `--cwd <path>` | Set the workspace directory |
| `--model <name>` | Override the model name |
| `--base-url <url>` | Override the API base URL |
| `--allow-write` | Allow the agent to modify files |
| `--allow-shell` | Allow the agent to execute shell commands |
| `--unsafe` | Allow destructive shell operations |
| `--show-transcript` | Print the full message transcript |
| `--system-prompt <text>` | Set a custom system prompt |
| `--append-system-prompt <text>` | Append to the system prompt |
| `--add-dir <path>` | Add extra directories to context |

### Slash Commands

These are handled **locally** before the model loop:

| Command | Aliases | Description |
|---------|---------|-------------|
| `/help` | `/commands` | Show built-in slash commands |
| `/context` | `/usage` | Show estimated session context usage |
| `/context-raw` | `/env` | Show raw environment & context snapshot |
| `/prompt` | `/system-prompt` | Render the effective system prompt |
| `/permissions` | — | Show active tool permission mode |
| `/model` | — | Show or update the active model |
| `/tools` | — | List registered tools with permission status |
| `/memory` | — | Show loaded CLAUDE.md memory bundle |
| `/status` | `/session` | Show runtime/session status summary |
| `/clear` | — | Clear ephemeral runtime state |

```bash
python3 -m src.main agent "/help"
python3 -m src.main agent "/context" --cwd .
python3 -m src.main agent "/tools" --cwd .
python3 -m src.main agent "/status" --cwd .
```

### Utility Commands

```bash
python3 -m src.main summary            # Workspace summary
python3 -m src.main manifest           # Workspace manifest
python3 -m src.main commands --limit 10 # Command inventory
python3 -m src.main tools --limit 10    # Tool inventory
```

---


## 🔧 Built-in Tools

The agent has access to 7 core tools:

| Tool | Description | Permission |
|------|-------------|------------|
| `list_dir` | List files and directories | 🟢 Always |
| `read_file` | Read file contents (with line ranges) | 🟢 Always |
| `write_file` | Write or create files | 🟡 `--allow-write` |
| `edit_file` | Edit files via exact string matching | 🟡 `--allow-write` |
| `glob_search` | Find files by glob pattern | 🟢 Always |
| `grep_search` | Search file contents by regex | 🟢 Always |
| `bash` | Execute shell commands | 🔴 `--allow-shell` |

---

## 🔄 Session Persistence

Each `agent` run automatically saves a resumable session:

```text
session_id=4f2c8c6f9c0e4d7c9c7b1b2a3d4e5f67
session_path=.port_sessions/agent/4f2c8c6f...
```

Resume a previous session:

```bash
python3 -m src.main agent-resume \
  4f2c8c6f9c0e4d7c9c7b1b2a3d4e5f67 \
  "Continue the previous task and finish the missing parts."
```

Inspect saved sessions:

```bash
ls -lt .port_sessions/agent
```

> **Note:** Run `agent-resume` from the same `claw-code/` directory where the session was created. A resumed session continues from the saved transcript, not from scratch.

---

## 🧪 Testing

Run the full test suite:

```bash
python3 -m unittest discover -s tests -v
```

Smoke tests:

```bash
python3 -m src.main agent "/help"
python3 -m src.main agent-context --cwd .
python3 -m src.main agent \
  "Read src/agent_session.py and summarize the message flow." \
  --cwd .
```

---

## 🔐 Permission Model

Claw Code Agent uses a **tiered permission system** to keep the agent safe by default:

| Tier | Capability | Flag Required |
|------|-----------|---------------|
| **Read-only** | List, read, glob, grep | None (default) |
| **Write** | + file creation and editing | `--allow-write` |
| **Shell** | + shell command execution | `--allow-shell` |
| **Unsafe** | + destructive shell operations | `--unsafe` |

---

## ⚠️ Disclaimer

- This repository is a **Python reimplementation** inspired by the Claude Code npm architecture.
- It does **not** ship the original npm source.
- It is **not** affiliated with or endorsed by Anthropic.

---

<p align="center">
  <sub>Built with 🐍 Python · Powered by 🐉  HarnessLab Team.</sub>
</p>
