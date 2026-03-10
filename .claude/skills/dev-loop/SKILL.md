---
name: dev-loop
description: ゴール文書をインプットに、Ralph Loop パターンで設計→実装→検証のループを自律的に実行する。各イテレーションでファイルベースの進捗を記録し、中断→再開が可能。
user_invocable: true
argument_hint: "<goal-file-path> [--max-iterations N]"
---

# dev-loop スキル

## 概要

ゴール文書と RN版リファレンスをインプットに、設計→実装→検証の開発ループを Ralph Loop パターンで自律的に実行する。

## 実行手順

### 1. 引数の解析

- 第1引数: ゴール文書のパス（必須）
- `--max-iterations N`: 最大イテレーション数（省略時: 10）

### 2. ゴール文書の読み込みとトピック名の抽出

- ゴール文書を Read で読み込む
- ファイル名からトピック名を抽出（例: `combo-system.md` → `combo-system`）

### 3. プロンプトの組み立て

以下の構造でプロンプトを組み立て、Ralph Loop に渡す。

---

#### プロンプトテンプレート

```
あなたは G-Runner Flutter版の開発エージェントです。Flutter + Flame エンジンでゲーム機能を実装します。

## プロジェクトコンテキスト

まず以下を読み込んでください:
- CLAUDE.md（プロジェクト概要・アーキテクチャ）
- IMPLEMENTATION_PLAN.md（全体の実装計画・進捗）

## RN版リファレンス

RN版のソースコード（../../g-runner-rn/）を参照してください。
RN版の CLAUDE.md も読み、アーキテクチャの全体像を把握してください。

## ゴール

<ゴール文書の全文をここに展開>

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
4. 設計メモが必要な場合は docs/goals/<topic>-design.md に出力

### Phase 1: Implementation（実装）

1. Phase 0 の設計に基づきコードを実装する
2. 実装順序:
   a. データ定義（constants.dart, stage_data.dart への追加）
   b. 新規コンポーネント（lib/game/components/ に追加）
   c. ゲームエンジン統合（g_runner_game.dart への組み込み）
   d. HUD更新（必要な場合）
   e. 画面更新（必要な場合）
3. 既存の Flame パターンに従う:
   - PositionComponent + HasGameReference<GRunnerGame>
   - anchor = Anchor.center
   - 論理座標系（width=320）
   - Canvas 直接描画
4. RN版のバランス値を忠実に移植する

### Phase 2: Verify（検証）

1. `flutter analyze` を実行し、静的解析エラーがないことを確認
2. `flutter test` を実行し、テストが通ることを確認
3. エラーがあれば修正する

### Phase 3: Update Plan（計画更新）

1. IMPLEMENTATION_PLAN.md の該当項目を [x] に更新
2. 実装した内容の簡潔なサマリを確認

## 完了条件

Phase 0〜3 の全てが完了し、以下を全て満たした時点で promise を出力してください:

- コードが実装されている
- `flutter analyze` がエラーなし
- `flutter test` が通る
- IMPLEMENTATION_PLAN.md が更新されている

<promise>DEV LOOP COMPLETE</promise>

重要: この promise は全 Phase が本当に完了した場合にのみ出力してください。
```

---

### 4. Ralph Loop の起動

```
/ralph-loop <組み立てたプロンプト> --max-iterations <N> --completion-promise "DEV LOOP COMPLETE"
```

### 5. 完了後の確認

ループ完了後、以下を報告する:
- 実装したファイルの一覧
- IMPLEMENTATION_PLAN.md の更新内容
- `flutter analyze` / `flutter test` の結果

イテレーション上限に達した場合は、どこまで完了したかを報告し、再実行を提案する。

## 注意事項

- ループ中は Claude が自律的に動作する。`lib/` と `IMPLEMENTATION_PLAN.md` の変更で進捗確認可能
- `--max-iterations` のデフォルトは 10。Phase 1 つあたり2-3イテレーション想定
- 安全性: `flutter analyze` と `flutter test` が Phase 2 で実行されるため、壊れたコードがコミットされるリスクは低い
