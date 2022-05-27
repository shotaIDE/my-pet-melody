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

## Firebase の構成ファイルを更新する

```shell
flutterfire config \
  --project=colomney-meow-music-dev \
  --ios-bundle-id=ide.shota.colomney.MeowMusic.dev \
  --android-app-id=ide.shota.colomney.MeowMusic.dev
```
