<h1 align="center">ModMopet</h1>

<h4 align="center"><b>ModMopet is a mod manager for Nintendo Switch emulators <b>yuzu and <b>Ryujinx</b>. It uses the Dart language and the Flutter framework and will be available as a multi-platform application for Windows, MacOs and Linux systems.</h4>

## Info
Currently we are in the **pre-release** phase and are in the middle of the initial phase and development of ModMopet. Do you think you can support us with your skills?  
  
Then just contact us in our [Discord](https://discord.gg/TthKPE3X).

## Build
We do not yet offer finished releases. But if you like, you can compile ModMopet yourself and try it out. But note that ModMopet may not start or run properly on your system yet.

#### Requirements
- Flutter v3.10.1+ (comes with dart-lang v3.0.1)
	- Guide to install Flutter you can find [here](https://docs.flutter.dev/get-started/install)
- Git (You can use [Github for Desktop](https://desktop.github.com) to checkout the repository)

#### Compile
    # Fetch flutter packages before build
    > flutter pub get
    > flutter build (windows|macos|linux)

#### Run & Testing
    # Fetch flutter packages before running
    > flutter pub get
    > flutter run lib/main.dart --debug
    > Choose device to test on with 0-9
