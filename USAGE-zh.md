# Claw Code Agent — 本地模型使用指南

本指南說明如何透過 LM Studio 搭配本地模型運行 Claw Code Agent，提供類似 **Claude Code** 的終端機體驗——只需輸入 `clawcode` 即可啟動。

---

## 總覽

```
                 +-----------------+
  終端機         |   LM Studio     |
  clawcode  ---> |   (port 1234)   |
  (任意目錄)     |   OpenAI API    |
                 +---------+-------+
                           |
                 +---------v----------------------------+
                 |  Qwen3.5-35B-A3B-Uncensored (GGUF)  |
                 |  MoE: 350 億總參數 / ~30 億活躍      |
                 +--------------------------------------+
```

**技術堆疊：**
- **Agent：** Claw Code Agent（純 Python，零外部依賴）
- **推理伺服器：** LM Studio（OpenAI 相容 API）
- **模型：** [HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive](https://huggingface.co/HauhauCS/Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive)（Q5_K_M GGUF）

---

## 前置需求

| 需求 | 說明 |
|------|------|
| Python | 3.10 或更高版本 |
| LM Studio | v0.4.5 以上（支援 Qwen3 工具呼叫） |
| GGUF 模型 | 已下載至 LM Studio 模型目錄 |
| GPU VRAM | 建議 16GB 以上（Q4_K_M ~20GB、Q5_K_M ~24GB） |

---

## 步驟一：下載模型

從 HuggingFace 下載適合你 GPU 的 GGUF 量化版本：

| 量化格式 | 大小 | 建議配置 |
|----------|------|----------|
| Q4_K_M | ~20 GB | 24 GB VRAM（如 RTX 4090） |
| Q5_K_M | ~24 GB | 32 GB 以上 VRAM |
| Q6_K | ~27 GB | 48 GB VRAM |
| Q8_0 | ~35 GB | 48 GB 以上 VRAM |

將 GGUF 檔案放入 LM Studio 模型目錄，例如：

```
C:\Users\<使用者>\.lmstudio\models\HauhauCS\Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive\
```

---

## 步驟二：設定 LM Studio

1. 開啟 **LM Studio**
2. 切換到 **Developer** 分頁
3. 載入模型 `Qwen3.5-35B-A3B-Uncensored-HauhauCS-Aggressive`
4. 設定 **Context Length** 為 `32768`（VRAM 足夠可調更高，模型原生支援最高 262K）
5. 將 **GPU Offload Layers** 調到最大以獲得最佳效能
6. 點擊 **Start Server**（預設連接埠：`1234`）

驗證伺服器是否運行：

```bash
curl http://localhost:1234/v1/models
```

記下回傳的模型 ID——後續設定可能會用到。

---

## 步驟三：設定 `clawcode` 指令

專案中已包含 `clawcode.cmd` 腳本，內建所有最佳參數。要讓它在任意目錄都能使用：

**將專案目錄加入 PATH：**

```powershell
# PowerShell（只需執行一次）
[Environment]::SetEnvironmentVariable(
    'Path',
    [Environment]::GetEnvironmentVariable('Path', 'User') + ';D:\Python\claw-code-agent',
    'User'
)
```

> 請將 `D:\Python\claw-code-agent` 替換為你的實際專案路徑。

**重新啟動終端機**，PATH 變更才會生效。

---

## 步驟四：開始使用

開啟終端機，切換到任意專案目錄，輸入：

```bash
cd D:\Projects\my-project
clawcode
```

就這樣。Agent 會在你的當前目錄中以互動聊天模式啟動，具備完整的工具呼叫能力。

### 背後的運作原理

`clawcode` 指令實際執行的是：

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
  --cwd <你的當前目錄>
```

### 傳遞額外參數

你可以在 `clawcode` 後面附加任何額外的旗標：

```bash
# 啟用串流輸出
clawcode --stream

# 覆蓋溫度設定
clawcode --temperature 1.0

# 執行單次提示（非互動模式）
# （修改 clawcode.cmd：將 agent-chat 改為 agent，然後傳入提示詞）
python -m src.main agent "解釋這個程式碼庫" ^
  --base-url http://localhost:1234/v1 --api-key lm-studio ^
  --temperature 0.6 --top-p 0.95 --top-k 20 ^
  --strip-thinking-tags --cwd .
```

---

## 模型參數

預設參數針對**程式撰寫任務**進行最佳化，依據模型卡片的建議值：

| 參數 | 值 | 用途 |
|------|-----|------|
| `--temperature` | 0.6 | 精確且具創意的程式碼生成 |
| `--top-p` | 0.95 | 核心取樣——避免低品質 token |
| `--top-k` | 20 | 限制候選 token 範圍 |
| `--presence-penalty` | *（未設定）* | 程式撰寫任務不需要重複懲罰 |
| `--strip-thinking-tags` | 啟用 | 移除輸出中的 `<think>...</think>` 區塊 |
| `--timeout-seconds` | 300 | 本地推理可能比雲端 API 慢 |

### 替代參數預設

**一般對話（思考模式）：**
```
--temperature 1.0 --top-p 0.95 --top-k 20 --presence-penalty 1.5
```

**非思考模式（直接回應）：**
```
--temperature 0.7 --top-p 0.8 --top-k 20 --presence-penalty 1.5
```

---

## 自訂 `clawcode.cmd`

編輯專案根目錄的 `clawcode.cmd` 來修改預設值：

```cmd
@echo off
set "CLAWCODE_HOME=D:\Python\claw-code-agent"    &REM <-- 你的專案路徑
set "PYTHONPATH=%CLAWCODE_HOME%;%PYTHONPATH%"

python -m src.main agent-chat ^
  --model <lm-studio-中的模型-id> ^               &REM <-- 對應 LM Studio 模型 ID
  --base-url http://localhost:1234/v1 ^            &REM <-- LM Studio 預設連接埠
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

你可能需要修改的欄位：

| 欄位 | 何時需要修改 |
|------|-------------|
| `CLAWCODE_HOME` | 如果你將專案克隆到不同路徑 |
| `--model` | 如果 LM Studio 回報的模型 ID 不同（用 `curl http://localhost:1234/v1/models` 確認） |
| `--base-url` | 如果 LM Studio 使用不同的連接埠 |
| `--timeout-seconds` | 如果在較慢的硬體上回應逾時，請調高 |
| `--allow-write --allow-shell` | 移除這兩個旗標可啟用唯讀模式 |

---

## 新增的 CLI 旗標

此設定在上游 claw-code-agent 基礎上新增了以下 CLI 旗標（適用於所有 `agent` 和 `agent-chat` 指令）：

| 旗標 | 類型 | 預設值 | 說明 |
|------|------|--------|------|
| `--top-p` | float | *（無）* | 核心取樣閾值 |
| `--top-k` | int | *（無）* | Top-K 取樣限制 |
| `--min-p` | float | *（無）* | 最小機率閾值 |
| `--presence-penalty` | float | *（無）* | 重複出現懲罰 |
| `--strip-thinking-tags` | flag | 關閉 | 移除模型輸出中的 `<think>...</think>` |

未設定的參數不會被加入 API 請求，後端伺服器將使用其自身的預設值。

---

## 疑難排解

### 「clawcode」不是可辨識的指令

- 確認 `D:\Python\claw-code-agent` 已加入 PATH
- 修改 PATH 後**必須重新啟動終端機**
- 驗證方式：`where clawcode.cmd`

### 連線被拒 / 逾時

- 確認 LM Studio 伺服器正在運行（Developer 分頁 → Start Server）
- 驗證方式：`curl http://localhost:1234/v1/models`
- 檢查連接埠是否與 `clawcode.cmd` 中的 `--base-url` 一致

### 模型 ID 不匹配

LM Studio 回報的模型 ID 可能與預期不同。請確認：

```bash
curl http://localhost:1234/v1/models
```

將 `clawcode.cmd` 中的 `--model` 值更新為回應中的 `id` 欄位。

### 工具呼叫無法運作

- 確認 LM Studio 版本為 **0.4.5 或更新**（較早版本存在 Qwen3 聊天模板問題）
- Qwen3.5 模型家族透過 LM Studio 原生支援 XML 格式的工具呼叫

### 記憶體不足

- 在 LM Studio 中降低 context length（例如改為 16384 而非 32768）
- 使用較小的量化格式（Q4_K_M 取代 Q5_K_M）
- 減少 GPU offload 層數，讓部分層使用 CPU 運算

### 回應中包含 `<think>` 區塊

- 確認指令中有包含 `--strip-thinking-tags`
- 此旗標會移除模型內部推理區塊，避免干擾輸出

---

## 修改的檔案（相對於上游）

| 檔案 | 修改內容 |
|------|----------|
| `src/agent_types.py` | `ModelConfig` 新增 `top_p`、`top_k`、`min_p`、`presence_penalty`、`strip_thinking_tags` 欄位 |
| `src/openai_compat.py` | API payload 發送新的取樣參數；`_strip_thinking_tags()` 過濾 `<think>` 區塊 |
| `src/main.py` | 新增 CLI 旗標：`--top-p`、`--top-k`、`--min-p`、`--presence-penalty`、`--strip-thinking-tags` |
| `src/session_store.py` | 序列化/反序列化更新以支援新欄位（向後相容） |
| `src/agent_runtime.py` | 串流路徑套用思考標籤過濾 |
| `clawcode.cmd` | 啟動腳本，內建預先配置的最佳參數 |
