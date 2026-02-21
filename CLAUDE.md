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

`lib/main.dart` bootstraps the app with a `ProviderScope` wrapping `MaterialApp.router`, which is configured with a `GoRouter` instance. All routes are declared in that router.

Directory layout:

- `lib/screens/` — one sub-folder per screen (e.g. `counter_list/`, `counter_detail/`)
- `lib/db/` — Drift database class and generated code for SQLite persistence
- `lib/models/` — plain Dart model classes (Drift table companions and domain objects)
- `lib/providers/` — Riverpod providers (generated via `riverpod_annotation` + `build_runner`)

State management uses **Riverpod** (`flutter_riverpod` + `riverpod_annotation`); there is no local `setState` for business logic.

Persistence is handled by **drift** (SQLite) via `drift_flutter` and `sqlite3_flutter_libs`.

## Linting

Rules come from `flutter_lints` via `analysis_options.yaml`. No custom rules are currently enabled beyond the Flutter defaults.
