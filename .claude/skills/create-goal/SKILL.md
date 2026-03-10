---
name: create-goal
description: 実装テーマからゴール文書を対話的に作成する。RN版のソースコードと IMPLEMENTATION_PLAN.md を探索して関連情報を自動収集し、方針・設計の下書きを生成する。新しい Phase の実装を始めたい、機能追加の方針を整理したい、と言った場合にこのスキルを使う。
user_invocable: true
argument_hint: "<topic> [--template minimal|standard]"
---

# create-goal スキル

## 概要

実装テーマを受け取り、RN版リファレンスと現行 Flutter コードベースを調査した上でゴール文書の下書きを生成する。ユーザーが確認・修正した後に `docs/goals/<topic>.md` として保存する。

## 実行手順

### 1. トピックの受け取り

引数または会話からトピック名・実装の概要を取得する。

- 引数がある場合: 第1引数をトピック名として使用
- 引数がない場合: 「何を実装しますか？」と質問する

トピック名はファイル名に使うため、英語のケバブケースに正規化する（例: 「コンボシステム」→ `combo-system`）。

### 2. テンプレート選択

- **Minimal**: Goal + Expected Output + References のみ。単機能の実装向け
- **Standard**: 上記 + Context + Scope + Design Notes。複数コンポーネントにまたがる実装向け

`--template` オプションが指定されていればそれを使用。

### 3. 関連情報の自動探索

テーマに基づき以下を探索する:

1. **IMPLEMENTATION_PLAN.md を読み込み**、該当 Phase の要件を確認
2. **RN版リファレンス** (`../../g-runner-rn/`) を探索
   - `src/engine/` — ゲームロジック（システム、エンティティ）
   - `src/game/` — データ定義（フォーム、ステージ、ゲート）
   - `src/constants/` — バランス定数
   - `src/types/` — 型定義
3. **現行 Flutter コードベース** (`lib/`) を確認し、既存実装との接点を特定
4. 必要に応じて **WebSearch** でFlame エンジンのベストプラクティスを調査

### 4. 下書きの生成

#### Minimal テンプレート

```markdown
# Goal
[1-2文の実装目的]

# Expected Output
[実装する成果物: コンポーネント、データ定義、画面等]

# References
## RN版の関連ファイル
[調査で発見したRN版のキーファイルパス]

## 実装ノート
[RN版から読み取った設計ポイント、バランス値、注意事項]
```

#### Standard テンプレート

```markdown
# Goal
[1-2文の実装目的]

# Context
[IMPLEMENTATION_PLAN.md での位置づけ、前提条件]

# Scope
## In Scope
[実装する範囲]
## Out of Scope
[今回は実装しない範囲]

# Expected Output
[実装する成果物の一覧]

# References
## RN版の関連ファイル
[キーファイルパス + 概要]

## 実装ノート
[設計ポイント、バランス値、注意事項]

# Design Notes
[Flutter/Flame での実装方針、RN版との差異]
```

### 5. ユーザーへの提示と確認

下書きを表示し、ユーザーに確認を求める。フィードバックがあれば修正し、OK が出るまで繰り返す。

### 6. ファイルの保存

確定した内容を `docs/goals/<topic>.md` に保存する。

### 7. 次のアクションの確認

```
ゴール文書を保存しました: docs/goals/<topic>.md

次のアクションを選んでください:
1. このまま開発ループを開始する（/dev-loop）
2. ここで終了する（後で手動で /dev-loop を実行）
```
