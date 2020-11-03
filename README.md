# アプリケーション名
自らをレベリングする習慣化アプリ

# デプロイ先URL
https://habituation-app-3.herokuapp.com/

# テスト用アカウント
- emailアドレス：sample1@sample.com
- password : sample1

# 利用方法
1. ニックネームとemailアドレスとパスワードを設定し、ユーザ登録を行う。
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.11.31.png)

2. 目標の内容とその目標の指標となる能力値の名前を記述する。
  - 目標設定画面に移動
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.15.00.png)
  - 目標の設定
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.16.13.png)

3. 能力値を向上させるための鍛錬（習慣）の内容を入力する。
  - 設定した目標の詳細内容を確認できるページへ移動
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.16.29.png)
  - 習慣にしたい内容を登録する画面に移動
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.16.47.png)
  - 習慣にしたい内容の設定
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.19.36.png)

4. 鍛錬が達成できたら、チェックをつける。
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.20.12.png)

5. 達成度に応じ経験値が得られる。（レベルが上がる。）
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2019.20.42.png)

6. 中間目標や以前と比べて変化があったらその内容を記入できる。経験値がもらえる。
![画像がないよ]()

# 目指した課題解決
達成したい目標・定期的に行うこと・達成できたことを記載してもらい、その達成度に応じて自身のレベルが上がることで、成長を実感しながら習慣化を目指すアプリ

# 実装機能、実装予定機能について
実装完了した機能は太字で記載
|機能|概要|
|:--|:--|
|**ユーザ管理**|目標をユーザごとに管理する|
|**達成目標の登録**|達成したい目標を能力値として登録する|
|**達成目標の一覧**|達成したい目標を能力値として一覧で表示する|
|**達成目標の詳細表示**|鍛錬（習慣）の内容や以前との変化（実績）を含めた、達成目標の詳細が表示される|
|**習慣の登録**|能力値を上昇させるための行動を登録する|
|**習慣の詳細**|鍛錬の具体的な内容や鍛錬の難易度など詳細が表示される|
|**習慣の振り返り**|現在取り組んでいる鍛錬の一覧を表示し、達成できたか記録する|
|**実績の登録**|中間目標や達成できたことを記録できる|
|**実績の編集**|中間目標など事前にたてた実績を達成したことを記録する|

# データベース設計
![画像がないよ](https://github.com/nakamura1111/habituation-app/blob/master/public/photos_for_README/%E3%82%B9%E3%82%AF%E3%83%AA%E3%83%BC%E3%83%B3%E3%82%B7%E3%83%A7%E3%83%83%E3%83%88%202020-10-04%2018.53.12.png)

# ローカルでの動作方法、開発環境
- Rails 6.0.3.3
- Ruby 2.6.5
- macOS Catalina 10.15.7
