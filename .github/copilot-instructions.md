# Copilot Instructions for Flutter Code Examples Repository

## Repository Summary

This repository contains **21 Flutter example projects** demonstrating various Flutter features and patterns. It serves as a collection of learning resources for Flutter development, covering everything from basic widgets to complex applications like a StackOverflow client. The repository contains **112 Dart files** across all projects and is actively maintained as educational material.

**Key Features:**
- Multiple standalone Flutter projects showcasing different concepts
- Web, mobile, and desktop Flutter application examples
- Demonstrations of state management, UI patterns, and platform integrations
- Tutorial-oriented code samples with corresponding documentation

## High-Level Repository Information

**Repository Structure:**
- **Type:** Multi-project Flutter examples repository
- **Size:** Medium (112 Dart files, 21 projects, 35 README files)
- **Language:** Dart (Flutter framework)
- **Target Platforms:** Web, Android, iOS, Linux Desktop
- **Framework Versions:** Flutter 2.x - 3.x (varies by project)
- **Dependencies:** Standard Flutter packages plus project-specific dependencies

**Project Categories:**
- **Basic Examples:** hello_world, first_app, flexible, basic_listview
- **Widget Demos:** widgetsexample, flutterui
- **State Management:** bloc (BLoC pattern demonstration)
- **Games:** galaxygame, clock
- **Complex Apps:** flutter_overflow (StackOverflow client), github_viewer
- **Web Apps:** web_demo, web_app_prototype, web_monitor
- **Platform-Specific:** batterylevel (platform channels)

## Build and Validation Instructions

### Prerequisites

**Required Tools:**
- **Flutter SDK:** Version 2.0+ (some projects require 3.0+)
- **Dart SDK:** Included with Flutter
- **Android Studio/VS Code:** For development
- **Git:** For version control

### Environment Setup

**ALWAYS run these commands before building any project:**

1. **Navigate to specific project directory** (projects are in root-level directories):
   ```bash
   cd [project_name]  # e.g., cd web_demo
   ```

2. **Install dependencies** (ALWAYS required):
   ```bash
   flutter pub get
   ```

3. **Check Flutter installation:**
   ```bash
   flutter doctor
   ```

### Build Commands by Platform

**Web Applications:**
```bash
# For web projects (web_demo, web_app_prototype, web_monitor)
flutter build web
flutter run -d chrome  # To run in development
```

**Android Applications:**
```bash
# Ensure Android SDK is configured
flutter build apk          # Debug build
flutter build apk --release # Release build
flutter run                # Run on connected device/emulator
```

**iOS Applications:**
```bash
# macOS only - ensure Xcode is installed
flutter build ios --no-codesign
flutter run -d ios         # Run on iOS simulator
```

**Linux Desktop:**
```bash
# For projects with linux/ directory (like web_demo)
flutter build linux
flutter run -d linux
```

### Testing Instructions

**Run Tests:**
```bash
cd [project_directory]
flutter test
```

**Common Test Patterns:**
- Most projects have basic widget tests in `test/widget_test.dart`
- Some projects have unit tests for business logic
- Complex projects like `flutter_overflow` may have integration tests

### Linting and Code Quality

**Projects with analysis_options.yaml** (flutter_overflow, hello_world):
```bash
flutter analyze
```

**Standard Dart Linting:**
- Projects use **pedantic** linting rules where configured
- Always run `flutter analyze` before committing changes
- Format code with `dart format .`

### Common Build Issues and Solutions

**Issue:** "Flutter SDK not found"
- **Solution:** Ensure `flutter` is in PATH and `flutter doctor` shows no critical issues
- **Workaround:** Set `flutter.sdk` in `local.properties` for Android builds

**Issue:** Dependencies not found
- **Solution:** ALWAYS run `flutter pub get` first
- **Additional:** Delete `pubspec.lock` and `pub-cache` if issues persist

**Issue:** Build fails with version conflicts
- **Solution:** Check Flutter version with `flutter --version`
- **Workaround:** Some older projects may require Flutter 2.x compatibility

**Issue:** Web builds fail to load
- **Solution:** Use `flutter run -d chrome --web-renderer html` for compatibility
- **Note:** Some projects require specific web renderers

### Project-Specific Instructions

**flutter_overflow:**
- **CRITICAL:** Requires `assets/secret.json` file for StackOverflow API credentials
- **Build Models:** Run `flutter pub run build_runner build` after changing models
- **Dependencies:** Uses older package versions, may need dependency resolution

**web_demo:**
- **Platforms:** Supports web, Android, iOS, and Linux
- **CMake:** Linux builds require CMake and GTK+ 3.0 development libraries
- **Web:** Progressive Web App (PWA) features enabled

**batterylevel:**
- **Platform Channels:** Demonstrates native platform integration
- **Testing:** Requires physical device for full platform channel testing

**bloc:**
- **State Management:** Uses BLoC pattern with provider package
- **Architecture:** Follow BLoC architectural patterns when modifying

## Project Layout and Architecture

### Directory Structure

**Root Level Projects:**
```
├── basic_listview/          # ListView demonstrations
├── batterylevel/            # Platform channel examples
├── bloc/                    # BLoC state management pattern
├── clock/                   # Clock widget/game
├── first_app/              # Beginner Flutter app
├── flexible/               # Flexible/Expanded widget demos
├── flutter_overflow/       # Complex StackOverflow client app
├── flutterui/             # UI component examples
├── galaxygame/            # Game development example
├── github_viewer/         # GitHub API integration
├── hello_world/           # Basic Hello World app
├── helloflutter/          # Alternative Hello World
├── mysample/              # Sample project template
├── web_app_prototype/     # Web application prototype
├── web_demo/              # Multi-platform web demo
├── web_monitor/           # Web monitoring application
├── widgetsexample/        # Widget catalog examples
└── WebMonitor/            # Legacy web monitor (capitalized)
```

### Standard Flutter Project Structure

Each Flutter project follows this structure:
```
project_name/
├── android/               # Android-specific files
├── ios/                   # iOS-specific files
├── lib/                   # Main Dart source code
│   ├── main.dart         # Application entry point
│   ├── pages/            # Page/screen components (when present)
│   ├── models/           # Data models (when present)
│   └── services/         # Business logic services (when present)
├── test/                 # Test files
├── web/ (if web-enabled) # Web-specific files
├── linux/ (if enabled)  # Linux desktop files
├── pubspec.yaml          # Dependencies and metadata
└── README.md             # Project-specific documentation
```

### Configuration Files

**Build Configuration:**
- `pubspec.yaml`: Dependencies, metadata, assets
- `android/build.gradle`: Android build configuration
- `android/app/build.gradle`: App-specific Android settings
- `ios/Runner/Info.plist`: iOS app configuration
- `web/index.html`: Web app entry point

**Linting Configuration:**
- `analysis_options.yaml`: Dart/Flutter linting rules (when present)
- Most projects use pedantic linting standards

**Flutter Configuration:**
- `.metadata`: Flutter project metadata (auto-generated)
- `.gitignore`: Comprehensive Flutter-specific ignore patterns
- `linux/CMakeLists.txt`: Linux desktop build configuration (when present)

### Validation and CI/CD

**No Automated CI/CD Pipeline:**
- Repository does not currently have GitHub Actions or other CI/CD
- Manual testing and validation required
- Consider adding GitHub Actions workflow for flutter analyze and flutter test

**Manual Validation Steps:**
1. `flutter analyze` - Check for code issues
2. `flutter test` - Run all tests
3. `flutter build [platform]` - Ensure builds complete
4. Manual testing on target platforms

### Dependencies and Version Management

**Common Dependencies Across Projects:**
- `flutter: sdk: flutter` (core framework)
- `cupertino_icons` (iOS-style icons)
- `flutter_test: sdk: flutter` (testing framework)

**Project-Specific Dependencies:**
- **flutter_overflow:** provider, http, json_annotation, build_runner, mockito
- **web_app_prototype:** groovin_material_icons (custom icons)
- **github_viewer:** http, provider (GitHub API integration)

**Version Compatibility:**
- Dart SDK: ">=2.12.0 <3.0.0" (null safety enabled)
- Some older projects use Dart 2.2+ (pre-null safety)
- Flutter versions range from 2.x to 3.x depending on project age

### Key Files for Code Changes

**Main Application Entry Points:**
- `lib/main.dart` - Contains `main()` function and app initialization
- Look for `runApp()` call to find root widget

**Common Modification Points:**
- `lib/pages/` or `lib/screens/` - UI screens and navigation
- `lib/models/` - Data structures and business objects
- `lib/services/` - API calls and business logic
- `pubspec.yaml` - Adding dependencies or assets

**Asset Management:**
- Assets defined in `pubspec.yaml` under `flutter.assets`
- Common asset directories: `assets/`, `img/`, `images/`
- Web-specific assets in `web/` directory

### Testing Architecture

**Widget Tests:**
- Located in `test/widget_test.dart`
- Follow Flutter testing best practices
- Use `testWidgets()` for UI testing

**Unit Tests:**
- Business logic testing (when present)
- Mock dependencies using `mockito` package

### Special Considerations

**Web Development:**
- Web projects may require specific renderers (HTML vs CanvasKit)
- CORS issues possible with API calls from web
- Service Workers enabled for PWA functionality

**Platform Channels:**
- `batterylevel` project demonstrates native platform integration
- Requires platform-specific code in `android/` and `ios/` directories

**State Management:**
- `bloc` project uses BLoC pattern
- Other projects may use setState, Provider, or other patterns
- Follow existing patterns within each project

### Agent Instructions

**Trust These Instructions:** Always refer to this document first before exploring. Only search the codebase if information here is incomplete or contradictory.

**Project Selection:** Always verify which project you're working in - each directory is a separate Flutter project.

**Build First:** Always run `flutter pub get` before any other operations.

**Test Strategy:** Run `flutter analyze` and `flutter test` early to understand current project state.

**Platform Awareness:** Check for platform-specific directories to understand target platforms.
