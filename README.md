# ConvertRubiApp
- gooラボAPIの「ひらがな化API」を利用した日本語文字列にひらがなのルビをつけるアプリ
- iOSアプリ制作１本目（Swift: 2019/11~)
- 制作期間約2週間

![demo](https://github.com/Ryuta1346/ConvertRubiApp/blob/image_for_readme/media_for_readme/ConvertRubiAppDemo.gif)


## 利用API
- [ひらがな化API](https://labs.goo.ne.jp/api/jp/hiragana-translation/)

## 機能
### トップ画面
1. 検索窓に入力した日本語文字列およびその文字列のルビを表示
2. 検索した文字列の履歴を5件まで表示
3. 検索した文字列を今後見直せるようにリストに保存するための登録ボタン(UserDefaults使った永続化)
4. リスト登録した文字列を表示するためのページに遷移するボタン(画面上部右側のブックマーク)

### リスト画面
1. リスト登録された文字列を、新しい順に上部から表示
2. 個別文字列欄で左にスワイプでリストからの削除ボタン表示
3. 画面上部左側のBackボタンでトップ画面に戻る

## UI/UXについて
- 検索窓を利用して画面上部に設置することで、変換前後の文字列の視認性向上と異なる文字列の再検索性の向上を図った
- 読書や新聞などを読む際には、同様の文字列が複数回登場することも想定されるため、検索履歴を表示することで検索数の減少を図った
- リスト登録機能をつけることで、検索数の減少と繰り返し見直せる事による学習のし易さを狙った

## 今後の実装計画
### http通信の部分を切り出してViewControllerの軽量化
現状はViewControllerにHTTP通信に関するコードを書いているが、FatViewControllerに繋がりコードの可読性等にも問題が出るので別ファイルに切り出す。
masterブランチからブランチを切って試しているが、思ったような挙動にならず苦戦中で、もう少し時間を要しそう。

#### 参考
[iOSでライブラリに頼らず、URLSessionを使ってHTTP通信する](https://qiita.com/yutailang0119/items/ab400cb7158295a9c171)
[https://github.com/ashbhat/swift-ezJson](https://github.com/ashbhat/swift-ezJson)

### TableViewDelegate, DataSource部分を切り出してViewControllerの軽量化
http通信処理と同じく、ViewControllerにコードを書いている状態で、こちらもFatViewControllerに繋がり可読性も悪くなるので、別ファイルに切り出す。
こちらも同様に期限内での実装が間に合わず、HTTP通信処理の切り出しの方をメインで調べていたこともあって実装方法について調べるところから。

#### 参考
[【swift】イラストで分かる！具体的なDelegateの使い方。](https://qiita.com/narukun/items/326bd50a78cf34371169)

## 今後の拡張検討事項
- 「読めない日本語文字列 = 意味もわからない」の場合も多いことも想定されるため、変換結果から意味を検索/表示できる機能を追加
