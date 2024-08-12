# benesse_hackathon_2024_08
# 目次

1. [プロジェクト概要](#プロジェクト概要)
2. [開発環境](#開発環境)
3. [利用パッケージ](#利用パッケージ)
4. [画面収録](#画面収録)
5. [スクリーンショットと各機能説明](#スクリーンショットと各機能説明)
6. [開発で工夫した点](#開発で工夫した点)
7. [実装+企画で工夫したこと](#実装企画で工夫したこと)
8. [Firebaseセットアップ](#firebaseセットアップ)
9. [ユーザーデータ](#ユーザーデータ)

# プロジェクト概要
```
自己管理を他に任せるコミュニティー協力型サービス（Uni-Com）
```
<img alt="my skills" src="https://skillicons.dev/icons?theme=light&perline=8&i=flutter,firebase,dart,figma" />  

# 開発環境
|環境|概要|
|-|-|
|言語|Dart|
|フレームワーク|Flutter|
|対象|iOS, Android|
|IDE|Android Studio|
|バックエンド|Firebase|
|認証|Firebase Authentication|
|データベース| Firebase Firestore|
|イミュータブルクラス|Freezed|

# 利用パッケージ
## Dependencies

| Package | Version |
|---------|---------|
| flutter | sdk: flutter |
| cupertino_icons | ^1.0.6 |
| firebase_core | ^3.3.0 |
| firebase_auth | ^5.1.4 |
| cloud_firestore | ^5.2.1 |
| riverpod | ^2.5.1 |
| freezed_annotation | ^2.4.4 |
| freezed | ^2.5.2 |
| flutter_riverpod | ^2.5.1 |
| json_annotation | ^4.9.0 |
| intl | ^0.19.0 |

## Dev Dependencies

| Package | Version |
|---------|---------|
| flutter_test | sdk: flutter |
| flutter_lints | ^3.0.0 |
| json_serializable | ^6.8.0 |
| build_runner | ^2.4.9 |

# 画面収録
https://github.com/user-attachments/assets/2c429f7d-54ac-4cc2-9d3e-c6b3582a4c45



# スクリーンショットと各機能説明
|スクリーンショット|機能概要|
|-|-|
|<img src="https://github.com/user-attachments/assets/7e1469a0-05fe-44d2-85e9-d383e9af139a" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 33 23">|トップページ（認証画面）|
|<img src="https://github.com/user-attachments/assets/a3dbf8f6-56f4-4ac9-a595-b9dbbf29d7e8" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 01">|必要情報を記入する|
|<img src="https://github.com/user-attachments/assets/1bbdfd15-90e2-4119-8eab-5eccc94935ee" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 08">|勉強することを選択|
|<img src="https://github.com/user-attachments/assets/f6afdc47-f059-455b-b9d7-cbc5b6643c83" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 13">|期間の逆算|
|<img src="https://github.com/user-attachments/assets/bfaea48e-74c1-4db8-bc16-506aa8671048" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 21">|目標点数の入力|
|<img src="https://github.com/user-attachments/assets/54f69bea-c04e-4001-8846-bbc6a8a6db72" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 26">|おすすめコミュニティーの選択|
|<img src="https://github.com/user-attachments/assets/fb3f5ed8-4a8c-4f3c-a04b-4ca2a371faa0" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 32">|コミュニティー参加確認|
|<img src="https://github.com/user-attachments/assets/dfac8178-59a1-471e-b196-d811f62f3fb3" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 35 37">|コミュニティーホーム画面(ダッシュボード)|
|<img src="https://github.com/user-attachments/assets/5e077fa6-fd98-4530-b9d1-99508fb0bb45" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 39 42">|メンバーリスト|
|<img src="https://github.com/user-attachments/assets/8fe580ba-2470-43ed-b2ad-c893fa2b4745" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 39 47">|メンバー詳細|
|<img src="https://github.com/user-attachments/assets/8e592668-1dbd-42c1-98e0-f5a8846b80bf" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 40 39">|企画（オンライン単語テスト）,コメントもできる|
|<img src="https://github.com/user-attachments/assets/39813acc-cd29-44e1-b0ba-dd203d4006af" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 40 46">|参加するボタン→押すと参加人数に即時反映|
|<img src="https://github.com/user-attachments/assets/b7dff7b1-d5a0-400e-b020-fd1da409138e" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 42 24">|勉強ストリーム、各メンバーの勉強内容が流れる|
|<img src="https://github.com/user-attachments/assets/361b1498-c1ab-4337-b84a-ff42bbd6fb5d" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 43 34">|各勉強記録に「いいね」や「コメント」もできる|
|<img src="https://github.com/user-attachments/assets/9d9291dd-b366-430b-b8e0-c80b02ea72f9" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 43 40">|勉強記録に「いいね」や「コメント」が反映されている|
|<img src="https://github.com/user-attachments/assets/b8e4a6bc-7d16-44f3-a8e0-f789cb51ad64" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 45 07">|勉強記録のダッシュボード|
|<img src="https://github.com/user-attachments/assets/dacebca1-acf1-4276-9b7d-8641bf03715d" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 45 28">|時間を入力|
|<img src="https://github.com/user-attachments/assets/68f6a666-6243-40fd-af06-53cc4448593b" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 46 31">|内容を入力|
|<img src="https://github.com/user-attachments/assets/a1bd57b8-39da-44b1-8c59-c1763f4e87be" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 46 39">|反映されている|
|<img src="https://github.com/user-attachments/assets/374b7c7e-3cb2-4c8e-8140-d83be4c28c5f" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 46 42">|記録はシャンルごとに表示される|
|<img src="https://github.com/user-attachments/assets/2ab5359c-8395-445c-8098-7bfe0f79b5cd" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 46 54">|勉強ストリームにも即時反映|
|<img src="https://github.com/user-attachments/assets/fbcbe7b7-1cd3-486a-9b27-9181318acc64" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 46 57">|最後に投稿されたデータを先頭に表示|
|<img src="https://github.com/user-attachments/assets/9265cfa4-2160-4e97-a294-c599466bc2c6" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 49 42">|単語テストのランキング(即時反映)|
|<img src="https://github.com/user-attachments/assets/e962bd8b-a403-4aee-8420-49db5854b0a2" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 49 49">|問題|
|<img src="https://github.com/user-attachments/assets/c9b2a5fa-92a4-4efd-a52d-e3c1be8b7e8f" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 50 43">|答え合わせ|
|<img src="https://github.com/user-attachments/assets/527f03cd-2a47-4bfd-b648-f0a3e5835c2d" width="300" alt="Simulator Screenshot - iPhone 15 Pro - 2024-08-12 at 12 50 54">|反映されている|

# 開発で工夫した点
- Firebaseをふんだんに利用したバックエンド設計
- イミュータブルなクラスを設計し、バグの軽減に挑戦した
- UIはシンプルにデザインし、視覚的負荷の内容に心がけた

# 実装+企画で工夫したこと
- 勉強内容投稿での時間において、`自己管理`の面では重要だが`ストリーム`（他のユーザーが見れるところ）では悪い効果を生んでしまう可能性もあるためあえて表示しなかった。  
- 努力した量を重要なパラメーターとしておいているため、`単語テスト`では一回の結果でなく何度も挑戦することでポイントが貯まるように（実装）した。  

# Firebaseセットアップ
```
firebase login
```
```
flutterfire configure --project=benesse-hackathon-202408
```
# ユーザーデータ
- 氏名、メールアドレス、パスワードなどは架空のもので現実のものとは一切関係ありません。

| 氏名 | 大学・学部・学年 | 趣味・好きなこと | メールアドレス | パスワード |
|------|------------------|-------------------|----------------|------------|
| 田中 美咲 | 東京大学 文学部 3年生 | 茶道、古典文学を読むこと | test04@test.com | test04 |
| 佐藤 健太 | 京都大学 工学部 2年生 | ロボット工学、週末のサイクリング | k.sato_robo@kyodai.edu | CyclingRobot!99 |
| 山本 絢子 | 早稲田大学 国際教養学部 4年生 | 語学学習（6カ国語）、旅行ブログ運営 | ayako2000@waseda.jp | 6Languages&Travel |
| 鈴木 翔太 | 大阪大学 医学部 5年生 | ジャズピアノ、医療ボランティア | s.shota_med@osaka-u.ac.jp | JazzMed2025! |
| 伊藤 花子 | 筑波大学 体育専門学群 1年生 | 陸上（100mハードル）、スポーツ栄養学 | hanako.ito@tsukuba-sp.edu | Hurdle100m#1 |
| 中村 大輔 | 名古屋大学 情報学部 3年生 | プログラミング、eスポーツ大会参加 | d_nakamura@nagoya-u.jp | C0deGamer2022 |
| 小林 直子 | 慶應義塾大学 経済学部 2年生 | 株式投資の勉強、クラシックバレエ | naoko_k@keio.ac.jp | Ballet&Stocks23 |
| 加藤 隆司 | 北海道大学 農学部 4年生 | 持続可能な農業研究、スノーボード | r.kato2001@hokudai.edu | Sn0wFarmer!24 |
| 渡辺 真理 | 九州大学 芸術工学部 1年生 | デジタルアート制作、カフェ巡り | mari.w@kyushu-art.ac.jp | D1gitalCafe2023 |
| 木村 哲也 | 東北大学 理学部 3年生 | 天体観測、科学コミュニケーション | t_kimura_science@tohoku.ac.jp | StarGazer#2024 |
