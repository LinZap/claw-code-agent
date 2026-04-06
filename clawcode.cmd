@echo off
REM ============================================================
REM  clawcode - Launch Claw Code Agent with local Qwen3.5 model
REM  Usage: cd to any project directory, then type "clawcode"
REM ============================================================

set "CLAWCODE_HOME=D:\Python\claw-code-agent"
set "PYTHONPATH=%CLAWCODE_HOME%;%PYTHONPATH%"

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
  --cwd "%CD%" ^
  %*
