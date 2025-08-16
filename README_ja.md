# GoFly - Google Workspace統合学習管理システム

[English Version / 英語版](README.md)

GoflyはGoogle Workspaceサービスと統合されたRuby on Rails学習管理システムで、Google Drive、Sheets、Formsを通じてコース、学生、教育コンテンツを管理します。

## 機能

### コース管理
- コースの作成と管理
- 登録コードを使用した学生のコース登録
- ファイル添付による学生の提出物追跡

### Google Workspace統合
- **Google Driveファイル**: コース内でGoogle Driveファイルをリンクしてダウンロード
- **Google Sheets**: データ管理とフォーム回答のためのGoogle Sheets統合
- **Google Forms**: Google Formsを接続し、リンクされたGoogle Sheetsから自動的に回答を収集
- **自動URL解析**: Drive/DocsのURLからGoogle ファイルIDを自動抽出
- **サービスアカウント認証**: Google サービスアカウント認証情報を使用した安全なAPI アクセス

### 学生・提出物管理
- 学生登録とコース参加追跡
- Active Storage統合によるファイル提出システム
- フォーム回答の収集と管理

## 技術スタック

- **フレームワーク**: Ruby on Rails 8.0.2
- **データベース**: PostgreSQL
- **フロントエンド**: Hotwire (Turbo + Stimulus)、Tailwind CSS
- **Google APIs**: Drive v3、Sheets v4
- **テスト**: RSpec、Factory Bot、Capybara
- **デプロイ**: Kamalを使用したDockerサポート

## 前提条件

- Ruby 3.x
- PostgreSQL
- Node.js（アセットコンパイル用）
- Drive APIとSheets APIアクセス権限を持つGoogle サービスアカウント

## セットアップ

### 1. クローンと依存関係のインストール

```bash
git clone <repository-url>
cd gofly
bundle install
```

### 2. データベースセットアップ

```bash
rails db:create
rails db:migrate
```

### 3. Google サービスアカウント設定

1. Google Cloud ConsoleでGoogle サービスアカウントを作成
2. Google Drive APIとGoogle Sheets APIを有効化
3. サービスアカウントJSONキーファイルをダウンロード
4. 環境変数を設定:

```bash
export GOOGLE_SERVICE_ACCOUNT_CREDENTIAL_PATH=path/to/your/service-account-key.json
```

### 4. 環境変数

`.env`ファイルを作成:

```bash
GOOGLE_SERVICE_ACCOUNT_CREDENTIAL_PATH=config/google-service-account.json
DATABASE_URL=postgresql://username:password@localhost/gofly_development
```

### 5. アプリケーションの起動

```bash
# Foremanを使用した開発環境
bin/dev

# または標準のRailsサーバー
rails server
```

## 使用方法

### コース管理
1. Webインターフェースを通じてコースを作成
2. Google URLを提供してGoogle Files、Sheets、Formsを追加
3. 登録コードを使用して学生を登録

### Google統合
- **ファイル**: Google Drive URLを貼り付けてダウンロード用ファイルをリンク
- **シート**: データ管理のためのGoogle Sheets接続
- **フォーム**: Google Formsをリンクし、接続されたGoogle Sheetsから自動的に回答をインポート

### 学生のワークフロー
1. 学生は提供されたコードを使用してコースに登録
2. 提出システムを通じて課題を提出
3. コース教材とGoogleリソースにアクセス

## API構造

### モデル
- `Course`: Google リソース関連付けを持つメインコースエンティティ
- `Student`: コース登録を含む学生管理
- `CourseStudent`: コードによるコース登録のための結合テーブル
- `GoogleFile`: ダウンロード機能付きGoogle Drive ファイル統合
- `GoogleSheet`: フォーム回答追跡機能付きGoogle Sheets統合
- `GoogleForm`: 自動回答収集機能付きGoogle Forms
- `Submission`: Active Storageを使用した学生ファイル提出

### サービス
- `GoogleService::Connection`: 認証機能付きコアGoogle APIクライアント
- `GoogleService::File`、`GoogleService::Sheet`、`GoogleService::Folder`: リソース固有のハンドラー
- `GoogleConnectionable`: Google リソースモデル用の共有concern

## テスト

```bash
# 全テストの実行
bundle exec rspec

# 特定のテストファイルの実行
bundle exec rspec spec/models/
bundle exec rspec spec/requests/
```

## デプロイ

アプリケーションにはDockerサポートとデプロイ用のKamal設定が含まれています:

```bash
# Kamalでビルドとデプロイ
kamal deploy
```

## 開発

### 主要ディレクトリ
- `app/models/concerns/google_connectionable.rb`: 共有Google統合ロジック
- `lib/google_service/`: Google APIサービスクラス
- `app/controllers/`: 全リソース用のRESTfulコントローラー
- `spec/`: ファクトリー付きRSpecテストスイート

### 新しいGoogle リソースの追加
1. `GoogleConnectionable`を含む新しいモデルを作成
2. `Course`に適切な関連付けを追加
3. `lib/google_service/`でリソース固有のメソッドを実装

## ライセンス

このプロジェクトはMITライセンスの下でライセンスされています - 詳細については[LICENSE](LICENSE)ファイルをご覧ください。

学籍番号：247735が追加