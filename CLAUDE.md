# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Flutter mobile application implementing a simple counter. Targets iOS and Android via Material Design.

## Common Commands

```bash
flutter run          # Run with hot reload
flutter test         # Run widget tests
flutter analyze      # Static analysis / lint
flutter pub get      # Install dependencies
flutter build apk    # Build Android APK
flutter build ios    # Build iOS app
```

Run a single test file:
```bash
flutter test test/widget_test.dart
```

## Architecture

The app lives entirely in `lib/main.dart` with three classes:

- **MyApp** — StatelessWidget root; configures MaterialApp and routes to MyHomePage
- **MyHomePage** — StatefulWidget; holds the page title and creates `_MyHomePageState`
- **_MyHomePageState** — manages `_counter` state and renders the Scaffold (AppBar, Column with counter display, FloatingActionButton)

State management is local (`setState`); there is no external state library.

## Linting

Rules come from `flutter_lints` via `analysis_options.yaml`. No custom rules are currently enabled beyond the Flutter defaults.
