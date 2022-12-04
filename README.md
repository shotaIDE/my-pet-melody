# Meow Music

## Development

### Launch Firebase emulator

```shell
firebase emulators:start --import=./emulator-data --export-on-exit=./emulator-data
```

### Upgrade Flutter version

```shell
asdf list all flutter
asdf install flutter <version>
asdf local flutter <version>
```

### Update Firebase configuration dart files

```shell
flutterfire config \
  --project=colomney-meow-music-dev \
  --out=lib/firebase_options_emulator.dart \
  --ios-bundle-id=ide.shota.colomney.MeowMusic.emulator \
  --android-app-id=ide.shota.colomney.MeowMusic.emulator
flutterfire config \
  --project=colomney-meow-music-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=ide.shota.colomney.MeowMusic.dev \
  --android-app-id=ide.shota.colomney.MeowMusic.dev
```

## Deployment

### Build app

#### iOS

```shell
flutter build ipa --dart-define FLAVOR=dev --export-options-plist ios/ExportOptions.plist
```

#### Android

```shell
flutter build appbundle --dart-define FLAVOR=dev
```
