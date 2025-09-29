# Dictato - Flutter Learning App

Dictato is a Flutter application designed to help kids improve their writing skills through dictation exercises. The app provides an interactive learning experience with voice-controlled training sessions, multi-user support, and progress tracking.

## Features

### Core Functionality
- **Multi-User Support**: Create and manage multiple user profiles
- **Text Management**: Add, edit, and organize texts for dictation practice
- **Training Sessions**: Interactive dictation exercises with text-to-speech
- **Voice Control**: Voice commands ("Next", "Repeat") during training sessions
- **Progress Tracking**: Detailed statistics and performance analytics
- **Error Tracking**: Record and analyze mistakes for improvement

### Language Support
- **Content Languages**: German and English text support
- **Localization**: App interface available in German and English
- **Language-Specific TTS**: Appropriate text-to-speech for each language

### Technical Features
- **Local Storage**: All data stored securely on device using SharedPreferences
- **Text Segmentation**: Automatic intelligent splitting of texts into manageable chunks
- **Modern Flutter**: Built with Flutter 3.x and latest best practices
- **Comprehensive Testing**: Unit tests, widget tests, and integration tests
- **Material Design**: Clean, intuitive user interface

## Architecture

### Project Structure
```
dictato/
├── lib/
│   ├── main.dart                 # App entry point and global state
│   ├── models/                   # Data models
│   │   ├── user.dart
│   │   ├── dictation_text.dart
│   │   ├── training_session.dart
│   │   └── models.dart           # Barrel file
│   ├── services/                 # Business logic services
│   │   ├── storage_service.dart  # Local data persistence
│   │   ├── text_to_speech_service.dart
│   │   ├── speech_recognition_service.dart
│   │   └── services.dart         # Barrel file
│   ├── screens/                  # UI screens
│   │   ├── home_screen.dart
│   │   ├── users_screen.dart
│   │   ├── texts_screen.dart
│   │   ├── training_screen.dart
│   │   ├── progress_screen.dart
│   │   └── screens.dart          # Barrel file
│   └── l10n/                     # Localization files
│       ├── app_en.arb           # English translations
│       └── app_de.arb           # German translations
├── test/                         # Test files
├── assets/                       # App assets
└── pubspec.yaml                 # Dependencies and configuration
```

### State Management
- **Provider Pattern**: Used for global app state management
- **AppState Class**: Centralized state container for users, texts, and sessions
- **Local Storage Integration**: Automatic persistence of all state changes

### Data Models
- **User**: User profiles with language preferences
- **DictationText**: Texts with automatic segmentation for training
- **TrainingSession**: Training progress with detailed segment results
- **JSON Serialization**: All models support JSON persistence

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (2.12 or higher)
- Android Studio or VS Code
- Device with microphone for voice features

### Installation

1. **Clone the repository**:
```bash
cd codeexamples-flutter/dictato
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Generate localization files**:
```bash
flutter gen-l10n
```

4. **Generate JSON serialization code**:
```bash
flutter pub run build_runner build
```

5. **Run the app**:
```bash
flutter run
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test files
flutter test test/models_test.dart
flutter test test/services_test.dart
flutter test test/widget_test.dart
```

### Building for Release

```bash
# Android
flutter build apk --release

# iOS (requires macOS and Xcode)
flutter build ios --release

# Web
flutter build web --release
```

## Usage Guide

### First Time Setup
1. **Launch the app** - You'll be prompted to create a user
2. **Create a user** - Enter name and select preferred language
3. **Add texts** - Navigate to the Texts tab and add your first dictation text
4. **Start training** - Go to Training tab and begin your first session

### Creating Training Texts
1. Navigate to the **Texts** screen
2. Tap the **+** button to add a new text
3. Enter a title and the text content
4. Choose the language (German or English)
5. Optionally mark as personal text (visible only to you)
6. Use voice input or keyboard input for text entry

### Training Sessions
1. Select a text from the **Training** screen
2. Listen to each segment being read aloud
3. Write down what you hear
4. Use voice commands ("Next", "Repeat") or buttons
5. Record the number of errors for each segment
6. View your results and progress

### Voice Commands
During training sessions, you can use these voice commands:
- **"Next"** / **"Weiter"** - Move to next segment
- **"Repeat"** / **"Wiederholen"** - Repeat current segment
- **"Stop"** / **"Stopp"** - Stop the training session

### Progress Tracking
- View overall statistics on the **Progress** screen
- See performance by language
- Track improvement trends over time
- Review detailed history of all sessions

## Configuration

### Text-to-Speech Settings
The app automatically configures TTS settings for optimal dictation:
- **Speech Rate**: Slower for better comprehension
- **Language**: Matches text language (German/English)
- **Voice**: System default for selected language

### Speech Recognition
Voice commands are language-aware:
- **English**: "Next", "Repeat", "Stop"
- **German**: "Weiter", "Wiederholen", "Stopp"

## Dependencies

### Core Flutter
- `flutter`: SDK framework
- `flutter_localizations`: Internationalization support

### UI Components
- `cupertino_icons`: iOS-style icons
- `provider`: State management

### Functionality
- `flutter_tts`: Text-to-speech functionality
- `speech_to_text`: Voice recognition
- `shared_preferences`: Local data storage
- `path_provider`: File system access

### Serialization
- `json_annotation`: JSON serialization annotations
- `json_serializable`: Code generation for JSON
- `build_runner`: Code generation runner

### Internationalization
- `intl`: International formatters and date handling

### Development
- `flutter_test`: Testing framework
- `flutter_lints`: Code linting
- `mockito`: Mocking for tests

## Contributing

### Code Style
- Follow Flutter/Dart conventions
- Use meaningful variable and function names
- Document public APIs
- Maintain test coverage

### Adding Features
1. Create feature branch
2. Implement functionality with tests
3. Update documentation
4. Submit pull request

### Testing Guidelines
- Write unit tests for models and services
- Add widget tests for UI components
- Include integration tests for user flows
- Maintain minimum 80% test coverage

## Troubleshooting

### Common Issues

**Speech recognition not working**:
- Check microphone permissions
- Ensure device has network connectivity
- Verify supported language is selected

**Text-to-speech issues**:
- Check system TTS settings
- Verify language packs are installed
- Test with different text content

**Storage problems**:
- Clear app data and restart
- Check device storage space
- Verify permissions are granted

### Performance Tips
- Limit text content length for better segmentation
- Use appropriate speech rate settings
- Close other audio apps during training
- Ensure stable microphone input

## License

This project is part of the vogella Flutter examples repository and follows the same licensing terms.

## Support

For issues, questions, or contributions, please refer to the main repository at:
https://github.com/vogellacompany/codeexamples-flutter

## Acknowledgments

- Flutter team for the excellent framework
- Text-to-speech and speech recognition plugin maintainers
- Localization contributors
- Testing framework developers