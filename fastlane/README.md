fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

### install_flutter_dependencies

```sh
[bundle exec] fastlane install_flutter_dependencies
```

Get Flutter dependencies

### generate

```sh
[bundle exec] fastlane generate
```

Generate automatic codes

### bump_patch_version

```sh
[bundle exec] fastlane bump_patch_version
```

Bump patch version

### add_release_candidate_tag

```sh
[bundle exec] fastlane add_release_candidate_tag
```

Add release candidate tag

### set_full_version_name_from_latest_tag

```sh
[bundle exec] fastlane set_full_version_name_from_latest_tag
```

Set full version name from latest tag

### check_mobile_apps_are_currently_released

```sh
[bundle exec] fastlane check_mobile_apps_are_currently_released
```

Check if mobile apps are currently released from Google Spreadsheet. If not, raise an error.

### update_mobile_apps_status_to_in_release_process

```sh
[bundle exec] fastlane update_mobile_apps_status_to_in_release_process
```

Update mobile apps status to "in release process" on Google Spreadsheet

----


## Android

### android build_dev

```sh
[bundle exec] fastlane android build_dev
```

Build develop app

### android build_prod

```sh
[bundle exec] fastlane android build_prod
```

Build production app

### android deploy_dev

```sh
[bundle exec] fastlane android deploy_dev
```

Deploy develop app to Firebase App Distribution

### android deploy_prod

```sh
[bundle exec] fastlane android deploy_prod
```

Build production app

----


## iOS

### ios install_dependencies

```sh
[bundle exec] fastlane ios install_dependencies
```

Install iOS dependencies

### ios build_dev

```sh
[bundle exec] fastlane ios build_dev
```

Build develop app

### ios build_dev_with_no_code_sign

```sh
[bundle exec] fastlane ios build_dev_with_no_code_sign
```

Build develop app with no code sign

### ios build_dev_for_simulator

```sh
[bundle exec] fastlane ios build_dev_for_simulator
```

Build develop app for Simulator

### ios build_prod

```sh
[bundle exec] fastlane ios build_prod
```

Build production app

### ios deploy_dev

```sh
[bundle exec] fastlane ios deploy_dev
```

Deploy develop app to Firebase App Distribution

### ios deploy_prod

```sh
[bundle exec] fastlane ios deploy_prod
```

Deploy production app to App Store Connect

### ios deploy_prod_without_build

```sh
[bundle exec] fastlane ios deploy_prod_without_build
```

Deploy production app to App Store Connect. This lane does not build, so you need to build before running this lane.

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
