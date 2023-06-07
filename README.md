# うちのコメロディー

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
  --project=colomney-my-pet-melody-dev \
  --out=lib/firebase_options_emulator.dart \
  --ios-bundle-id=ide.shota.colomney.MyPetMelody.emulator \
  --android-app-id=ide.shota.colomney.MyPetMelody.emulator
mv android/app/google-services.json android/app/firebase/emulator
mv ios/Runner/GoogleService-Info.plist ios/Runner/Firebase/Emulator
flutterfire config \
  --project=colomney-my-pet-melody-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=ide.shota.colomney.MyPetMelody.dev \
  --android-app-id=ide.shota.colomney.MyPetMelody.dev
mv android/app/google-services.json android/app/firebase/dev
mv ios/Runner/GoogleService-Info.plist ios/Runner/Firebase/Dev
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
