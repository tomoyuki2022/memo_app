# メモアプリ
sinatraを使用して作成したメモアプリです。
メモの作成、編集、削除をすることができます。

# 必要なソフトウェア
Ruby(3.1.2を使用して作成しています)<br>
Bundler(`gem install bundler`でインストール）
PostgreSQL

# データベースの作成
1.インストール(macOS)
```
brew install postgresq
brew services start postgresql
```
2.データベースの作成
```
CREATE DATABASE memo_app;
```
3.テーブルの作成
```
CREATE TABLE memos(
  memo_id uuid PRIMARY KEY,
  title VARCHAR(100),
  content TEXT
);
```
# インストール
1.リポジトリをcloneしてください。
```
git clone https://github.com/アカウント名/memo_app.git
```
2.memo_appディレクトリに移動してください。
```
cd memo_app
```
3.bundleでgemをインストールしてください。
```
bundle install
```
4.アプリを実行します。
```
bundle exec ruby memoapp.rb
```
# 使い方
1.ブラウザでアクセスします。
```
http://localhost:4567
```
2.トップ画面の「作成」ボタンから新しいメモを作成できます。<br>
3.テキストボックスにメモを入力し、「保存」ボタンをクリックするとトップ画面にメモのタイトルが表示されます。<br>
4.作成したメモを変更する場合は、メモタイトルをクリックし「変更」を選び、テキストボックスしたの「変更」ボタンをクリックします。<br>
5.作成したメモを削除する場合は、メモタイトルをクリックし、「削除」ボタンをクリックします。
