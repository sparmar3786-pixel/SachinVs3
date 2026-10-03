# SachinVs3 QuantDesk

## Native Android implementation

This repository now uses **native Android + Kotlin** for the APK. Flutter and Dart are removed from the Android build path.

### APK build
GitHub Actions runs JDK 17, Gradle 8.7, Kotlin unit tests, Android lint, the native release build, an APK ZIP integrity check, and artifact upload.

APK output:
`app/build/outputs/apk/release/app-release.apk`

### App
- Native Kotlin Activity
- Paper-only signal engine
- Six AI-layer status display
- Five strategy status display
- Auto refresh / pause / manual refresh
- No broker order routing
- No Angel One/NSE credentials embedded in APK

### Backend
The existing FastAPI backend remains separate under `backend/`. Live broker credentials stay server-side.

### Build guard
The workflow explicitly checks that `pubspec.yaml` and `lib/main.dart` do not exist, preventing an accidental Flutter/Dart build.
