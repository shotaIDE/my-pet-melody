# うちのコメロディー

## Development

### Launch Firebase emulator

```shell
firebase use default
firebase emulators:start --import=./emulator-data --export-on-exit=./emulator-data
```

## E2E Testing

### iOS

Launch iOS simulator.

Execute the following command.

```shell
flutter build ios --dart-define-from-file 'dart-defines_emulator.json' --simulator
xcrun simctl install Booted 'build/ios/iphonesimulator/Runner.app'
maestro test flow.yaml
```

### Android

Launch Android emulator.

Execute the following command.

```shell
flutter build apk --dart-define-from-file 'dart-defines_emulator.json'
adb install -r 'build/app/outputs/flutter-apk/app-release.apk'
maestro test flow.yaml
```

### Upgrade Flutter version

```shell
asdf list all flutter
asdf install flutter <version>
asdf local flutter <version>
```

### Update Firebase configuration dart files

```shell
firebase use --clear
flutterfire config \
  --project=colomney-my-pet-melody-dev \
  --out=lib/firebase_options_emulator.dart \
  --ios-bundle-id=ide.shota.colomney.MyPetMelody.emulator \
  --android-app-id=ide.shota.colomney.MyPetMelody.emulator
mv android/app/google-services.json android/app/firebase/emulator
mv ios/Runner/GoogleService-Info.plist ios/Runner/Firebase/Emulator
mv ios/firebase_app_id_file.json ios/Runner/Firebase/Emulator
flutterfire config \
  --project=colomney-my-pet-melody-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=ide.shota.colomney.MyPetMelody.dev \
  --android-app-id=ide.shota.colomney.MyPetMelody.dev
mv android/app/google-services.json android/app/firebase/dev
mv ios/Runner/GoogleService-Info.plist ios/Runner/Firebase/Dev
mv ios/firebase_app_id_file.json ios/Runner/Firebase/Dev
```

```shell
firebase use prod
flutterfire config \
  --project=colomney-my-pet-melody \
  --out=lib/firebase_options_prod.dart \
  --ios-bundle-id=ide.shota.colomney.MyPetMelody \
  --android-app-id=ide.shota.colomney.MyPetMelody
mv android/app/google-services.json android/app/firebase/prod
mv ios/Runner/GoogleService-Info.plist ios/Runner/Firebase/Prod
mv ios/firebase_app_id_file.json ios/Runner/Firebase/Prod
```

## Deployment

### Firestore rules

```shell
firebase deploy --only firestore:rules
```

### Storage rules

```shell
firebase deploy --only storage
```
