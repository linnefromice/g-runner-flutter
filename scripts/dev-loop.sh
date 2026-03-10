#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# dev-loop.sh
# Headless execution wrapper for G-Runner Flutter dev loop using claude -p
# =============================================================================

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info()  { echo -e "${CYAN}[INFO]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# --- Argument parsing ---
GOAL_FILE=""
MAX_ITERATIONS=10
MODEL="claude-sonnet-4-6"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-iterations)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --model)
      MODEL="$2"
      shift 2
      ;;
    -*)
      err "Unknown option: $1"
      echo "Usage: $0 <goal-file-path> [--max-iterations N] [--model MODEL]"
      exit 1
      ;;
    *)
      if [[ -z "$GOAL_FILE" ]]; then
        GOAL_FILE="$1"
      else
        err "Unexpected argument: $1"
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ -z "$GOAL_FILE" ]]; then
  err "Goal file path is required."
  echo "Usage: $0 <goal-file-path> [--max-iterations N] [--model MODEL]"
  exit 1
fi

# --- Validate goal file ---
if [[ ! -f "$GOAL_FILE" ]]; then
  err "Goal file not found: $GOAL_FILE"
  echo "Create one using: /create-goal <topic>"
  exit 1
fi

# --- Validate claude CLI ---
if ! command -v claude &>/dev/null; then
  err "'claude' CLI not found in PATH."
  exit 1
fi

# --- Resolve workspace root ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WS_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- Extract topic name ---
TOPIC="$(basename "$GOAL_FILE" .md)"

info "Goal file:       $GOAL_FILE"
info "Topic:           $TOPIC"
info "Max iterations:  $MAX_ITERATIONS"
info "Model:           $MODEL"

# --- Read goal file content ---
GOAL_CONTENT="$(cat "$GOAL_FILE")"

# --- Build prompt ---
PROMPT="$(cat <<PROMPT_EOF
あなたは G-Runner Flutter版の開発エージェントです。Flutter + Flame エンジンでゲーム機能を実装します。

## プロジェクトコンテキスト

まず以下を読み込んでください:
- CLAUDE.md（プロジェクト概要・アーキテクチャ）
- IMPLEMENTATION_PLAN.md（全体の実装計画・進捗）

## RN版リファレンス

RN版のソースコード（../../g-runner-rn/）を参照してください。
RN版の CLAUDE.md も読み、アーキテクチャの全体像を把握してください。

## ゴール

$GOAL_CONTENT

## フェーズ実行指示

以下の Phase を順に実行してください。
既に前のイテレーションで作成・変更されたファイルがある場合は、その内容を確認し、続きから作業してください。

### Phase 0: Design（設計）

1. ゴール文書の References にあるRN版ファイルを読み込む
2. 現行 Flutter コードベース（lib/）の関連ファイルを読み込む
3. 実装方針を決定する:
   - 新規ファイル vs 既存ファイル変更
   - コンポーネント設計（Flame Component 構成）
   - データ定義（constants, stage_data 等）
   - 衝突判定やゲームループへの組み込み方

### Phase 1: Implementation（実装）

1. Phase 0 の設計に基づきコードを実装する
2. 実装順序:
   a. データ定義（constants.dart, stage_data.dart への追加）
   b. 新規コンポーネント（lib/game/components/ に追加）
   c. ゲームエンジン統合（g_runner_game.dart への組み込み）
   d. HUD更新（必要な場合）
   e. 画面更新（必要な場合）
3. 既存の Flame パターンに従う
4. RN版のバランス値を忠実に移植する

### Phase 2: Verify（検証）

1. flutter analyze を実行し、静的解析エラーがないことを確認
2. flutter test を実行し、テストが通ることを確認
3. エラーがあれば修正する

### Phase 3: Update Plan（計画更新）

1. IMPLEMENTATION_PLAN.md の該当項目を [x] に更新

## 完了条件

Phase 0〜3 の全てが完了し、以下を全て満たした時点で promise を出力:

- コードが実装されている
- flutter analyze がエラーなし
- flutter test が通る
- IMPLEMENTATION_PLAN.md が更新されている

<promise>DEV LOOP COMPLETE</promise>
PROMPT_EOF
)"

# --- Run the dev loop ---
ITERATION=0
COMPLETED=false

info "Starting dev loop..."
echo ""

while [[ $ITERATION -lt $MAX_ITERATIONS ]]; do
  ITERATION=$((ITERATION + 1))
  info "=== Iteration $ITERATION / $MAX_ITERATIONS ==="

  CLAUDE_OUTPUT="$(cd "$WS_ROOT" && claude -p "$PROMPT" \
    --dangerously-skip-permissions \
    --model "$MODEL" \
    --max-turns 50 2>&1)" || true

  # Check for completion promise
  if echo "$CLAUDE_OUTPUT" | grep -q '<promise>DEV LOOP COMPLETE</promise>'; then
    COMPLETED=true
    ok "Dev loop completed at iteration $ITERATION."
    break
  fi

  warn "Iteration $ITERATION did not complete all phases. Retrying..."
  sleep 3
done

echo ""

if $COMPLETED; then
  ok "Dev loop completed successfully!"
  echo ""
  info "Run 'flutter analyze && flutter test' to verify."
else
  warn "Max iterations ($MAX_ITERATIONS) reached without full completion."
  echo ""
  warn "Check IMPLEMENTATION_PLAN.md for partial progress."
  warn "Consider re-running with --max-iterations $((MAX_ITERATIONS + 5))."
fi
