# Anti-Homograph Extension

[English](README.md) | [日本語](README-ja.md)

**AHE** は、ドメイン名に英字と紛らわしい別の文字が含まれると警告する、
macOS・iPhone・iPadのSafari向け拡張機能です。コード、独自のアイコン、文書はMITライセンスで公開しています。
Unicodeデータには別途Unicodeのライセンスが適用されます。

[unbound-anti-homograph](https://github.com/rioriost/unbound-anti-homograph) と同じ文字の判定条件を使いますが、
独立したプロジェクトであり、Unboundのコードや導入は必要ありません。

## ドメイン名を端末内で判定する

Punycode形式のラベルを復号し、Unicode 17.0.0の対応表1,407件と照合します。
非ASCII文字の対応先がASCIIの英字だけで構成されていれば警告します。
文字体系の混在は条件にせず、サブドメイン、TLD、複数の英字への対応も検査します。
不正、または正規形でないPunycodeラベルも警告対象です。

| ドメイン名 | 結果 |
| --- | --- |
| `amazon.com` | 判定対象の文字なし |
| `аmazon.com`（`xn--mazon-3ve.com`、先頭がキリル文字U+0430） | 警告 |
| `аррӏе.com`（`xn--80ak6aa92e.com`） | 警告 |
| `bücher.de` / `日本語.jp` | 判定対象の文字なし |

ページ上の警告には、実際のPunycodeドメイン名、Unicodeでの表示、対象文字と対応する英字を示します。
「このページから離れる」を押すと `about:blank` に移ります。
警告を閉じる操作は現在の文書だけに適用され、許可リストには登録しません。
Safariのツールバーボタンからも、ページ上の表示とは独立した判定を確認できます。
日本語・英語と明暗の表示に対応しています。

**通信の遮断やサイトの安全性を保証する拡張機能ではありません。**
正当な名前が警告対象になる場合があります。
ASCII文字だけの偽装など、判定対象外のフィッシング手法もあります。

## 開発用として読み込む

macOS版の配布対象はApple Silicon搭載MacとmacOS 27以降です。
iPhone・iPad版はiOS／iPadOS 17以降を対象にしています。
動作確認はmacOS 27のSafariとiOS／iPadOS 27のシミュレータで行っています。
iOSの実機と最小対応OSでの検証は未実施です。このリポジトリではソースコードを公開しています。

Safariの「設定 > デベロッパ」に「一時的な機能拡張を追加」がある場合は、
リポジトリの `extension` フォルダを選んでください。
未署名の拡張機能に関する認証手順に従い、有効化してWebサイトへのアクセスを許可します。
一時的な拡張機能は、Safariの終了時または24時間後に削除されます。

自動警告には、すべてのWebサイトまたは検査したいサイトへのアクセス許可が必要です。
インストールしただけでは許可されません。
ツールバーボタンを押したときに判定できても、すべてのサイトで自動警告が有効とは限りません。
プロファイルとプライベートブラウズの権限も個別に確認してください。

macOSアプリとして組み込む場合は、Xcodeを用意し、リポジトリのルートで実行します。

```sh
sh scripts/package_safari.sh
python3 scripts/prepare_appstore.py
xcodebuild \
  -project 'build/safari/Anti-Homograph Extension/Anti-Homograph Extension.xcodeproj' \
  -scheme 'Anti-Homograph Extension' -configuration Debug \
  -destination 'platform=macOS,arch=arm64' \
  -derivedDataPath build/safari-derived CODE_SIGNING_ALLOWED=NO build
```

Intel Macでは `-destination` の指定を省いてください。
生成したプロジェクトをXcodeで開き、アプリを実行すると拡張機能を登録できます。
未署名の開発用拡張機能は、[Appleの手順](https://developer.apple.com/documentation/safariservices/running-your-safari-web-extension)
に従って許可してください。スクリプトはアプリのインストールやSafariの設定変更を行いません。

生成先に既存プロジェクトがある場合、スクリプトは上書きせず停止します。
生成したプロジェクトは元のリソースを参照します。通常の編集では再ビルドし、
ファイルの追加・削除時はプロジェクトを生成し直してください。
署名して配布する際は、開発チームと適切なBundle Identifierを設定します。

## iPhone・iPad版

`sh scripts/package_ios.sh` で、共通の拡張機能を含むiOS用プロジェクトを生成します。
ビルド手順は[英語版README](README.md#iphone-and-ipad)を参照してください。

ネイティブの設定案内画面は日本語・英語、文字サイズの変更、明暗の表示に対応します。
「設定 ＞ アプリ ＞ Safari ＞ 機能拡張」でAHEを有効にし、Safariのページメニューで
検査するWebサイトへのアクセスを許可してください。iOS 17では「設定 ＞ Safari」です。
iOS 26.2以降では案内画面から機能拡張設定を開けます。設定アプリの初回起動時に
先頭画面が開く場合は、表示している手順で移動してください。

App Storeで配布するには、同じApp Store ConnectのアプリにiOSプラットフォームを追加し、
署名したiOS用ビルドをアップロードして審査へ提出します。macOS用ビルドだけではiOSに配布できません。

## 通常のインストール導線にはApp Storeでの公開が必要

Safariの「Safari機能拡張」「その他の機能拡張」などから一般ユーザーに見つけてもらい、
App Store経由でインストールしてもらうには、Apple Developer Programへの加入と、
App Store Connectでの登録・アップロード、その後の審査・公開が必要です。
アップロードしただけでは公開されません。
App Store ConnectのSafari Web Extension Packagerを使い、
Xcodeを使わず拡張機能のリソースからアプリを作成する方法もあります。

macOSでは、**Developer IDで署名し、公証したアプリをApp Storeの外で配布する方法**もあります。
この場合はGitHub Releasesや自分のWebサイトから配布でき、App Storeへの掲載は不要です。
利用者はアプリをインストールした後、Safariで拡張機能を有効にします。
ただし、App Storeの拡張機能一覧から見つけてもらう配布方法にはなりません。

GitHubでMITのソースコードを公開しても、署名、公証、App Review、App Store掲載は自動では行われません。
未署名の一時読み込みは開発・検証用であり、一般ユーザー向けの継続的な配布とは別です。
macOS版0.1.0（ビルド3）は2026年10月20日にApp Reviewへ提出しました。
提出は承認や公開の完了を意味しません。iOS版は別のプラットフォームとして準備します。

## 閲覧情報を保存せず、通信は遮断しない

拡張機能による外部通信、利用状況の収集、バックグラウンド処理、Cookieの利用、
閲覧履歴や例外設定の保存は行いません。現在のホスト名だけを端末内で判定します。
URLのパスやクエリ文字列は表示も保存もせず、Unicodeデータは同梱しています。

警告前にページの読み込みやスクリプトの実行が始まる場合があります。
警告のスタイルは閉じたShadow DOMで分離していますが、サイト側が削除・隠蔽・模倣する可能性は残ります。
拡張機能側の判定を確認するには、Safariのツールバーボタンを使ってください。
リンク先、フレーム、追加リソース、CNAME、ダウンロード、ほかのアプリは検査しません。
Safariが拡張機能の実行を制限するページや、アクセスを許可していないサイトでは自動警告が出ません。
Safari側で拒否・正規化されたURLを元の形で検査することはできず、IDNAの完全な妥当性検査も行いません。

## 判定データを更新する

npm依存パッケージは不要です。Python 3とNode.js 22以降で実行します。

```sh
python3 scripts/build_safari_data.py --download
python3 scripts/build_safari_data.py --check
python3 -m unittest discover -s tests -v
node --test tests/safari.test.cjs
```

データを取得するのは開発時だけです。取得元のコミットとSHA-256はスクリプトで固定しています。
取得したデータはGit管理外の `build/confusables.txt` に保存します。
Unicodeのバージョンを更新した際は、生成した `extension/confusables.js` もコミットしてください。
CIは取得元と生成物の一致を確認します。

macOSでは `swift tests/safari_webkit.swift` で実際のWebKitによる描画、フォーカス、
警告を閉じる操作を確認できます。拡張機能APIは代替実装を使い、テスト用サイトには接続しません。
画像は `build/safari-webkit` に出力します。Safariへの登録や有効化は行いません。
独自のPNGアイコンは `swift scripts/build_safari_icons.swift` で再生成できます。

リリース前には、実際のSafariでインストール、アクセス許可、プロファイル、
プライベートブラウズ、キーボード操作、VoiceOverを確認してください。
WebKitでの確認と未署名ビルドだけで、App Storeへの公開準備が整うわけではありません。

## ライセンスと出典

独自のコード・画像・文書は [MITライセンス](LICENSE) です。
配布時も `extension/LICENSE.txt` と `extension/UNICODE-LICENSE.txt` を残してください。
Unicodeデータの扱いと取得元は [NOTICE](NOTICE) に記載しています。

Appleの配布・実装資料と設計根拠は、[英語版の出典表](README.md#license-and-primary-sources)にまとめています。
Web UIとして意味のあるHTML要素を使っており、macOSのネイティブ警告ではありません。
自動警告は意図的にフォーカスを移動したりモーダルを開いたりせず、色だけに頼らず文章で警告します。
アニメーションや外部フォントは使いません。
