# Meow Music

## Firebase の Emulator を起動する

```shell
firebase emulators:start --import=./emulator-data --export-on-exit=./emulator-data
```

## リリースビルド

```shell
flutter build ipa --export-options-plist ios/ExportOptions.plist
```

##　 Flutter のバージョンを更新する

プロジェクトの Flutter バージョンを指定する場合、以下のコマンドを利用します。

```shell
asdf list all flutter
asdf install flutter <version>
asdf local flutter <version>
```
