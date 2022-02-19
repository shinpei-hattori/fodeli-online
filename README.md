# アプリケーションの概要

フードデリバリー配達員の情報交換や交流を目的としたチャットサービス
https://fodelionline.site/

# 技術的ポイント

・**RSpec**で Model, Request, System テスト記述(計 258examples)
・**Ajax**を用いた非同期処理（フォロー/未フォロー、ツイートに対するいいね機能などの切り替え表示）
・**Bootstrap**によるレスポンシブ対応
・**Rubocop**を使用したコード規約に沿った開発
・**14 個**のモデルをそれぞれ関連付けて使用

# DB 設計図

# AWS(インフラ)構成図

# アプリケーションの機能

+ ユーザー登録機能  
■ ログイン機能  
■ ログイン情報の保持  
■ ユーザー情報編集機能  
■ プロフィール画像変更機能(carrierwave)  
■ 検索機能  
+ ツイートの投稿機能  
■ 投稿一覧表示機能  
■ 投稿詳細表示機能  
■ 画像投稿機能(carrierwave)  
■ コメントの投稿と削除機能  
■ いいね機能(Ajax)  
■ 検索機能  
+ ページネーション機能(Kaminari)  
+ オープンチャット機能  
■ コメントの投稿と削除機能  
■ 地域別絞り込み機能  
+ 個人チャット機能  
■ コメントの投稿と削除機能  
+ DB テーブルのリレーション管理  
+ DB トランザクション制御機能  
+ 通知機能(フォロワーがツイートした時など)  
+ フォロー機能(Ajax) 
+ 単体テスト機能(Rspec)  
+ 統合テスト機能(Rspec)  

# 使用技術

+ Ruby 2.5.7  
+ Ruby on Rails 5.2.3  
+ PostgreSQL 11.14  
+ Nginx  
+ Puma  
+ Docker/Docker-compose  
+ Rspec  
+ Bootstra  
+ Rubocop  
+ AWS  
■ VPC  
■ EC2  
■ RDS  
■ Route53  
■ ALB  
■ SES
