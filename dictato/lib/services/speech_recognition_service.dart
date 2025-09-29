import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Service for speech recognition functionality
class SpeechRecognitionService {
  static final SpeechRecognitionService _instance = SpeechRecognitionService._internal();
  factory SpeechRecognitionService() => _instance;
  SpeechRecognitionService._internal();

  stt.SpeechToText? _speech;
  bool _isInitialized = false;
  bool _isListening = false;

  /// Initialize the speech recognition service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _speech = stt.SpeechToText();
    _isInitialized = await _speech!.initialize(
      onStatus: _onStatusChanged,
      onError: _onError,
    );
    
    return _isInitialized;
  }

  stt.SpeechToText get _speechToText {
    assert(_isInitialized, 'SpeechRecognitionService not initialized');
    return _speech!;
  }

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;

  /// Callback for status changes
  void _onStatusChanged(String status) {
    _isListening = status == 'listening';
    print('Speech recognition status: $status');
  }

  /// Callback for errors
  void _onError(dynamic error) {
    print('Speech recognition error: $error');
  }

  /// Start listening for speech
  Future<void> startListening({
    required Function(String) onResult,
    String language = 'en-US',
    Duration? timeout,
  }) async {
    if (!_isInitialized) {
      throw Exception('Speech recognition not initialized');
    }

    if (_isListening) {
      await stopListening();
    }

    // Convert language code
    String speechLanguage;
    switch (language.toLowerCase()) {
      case 'de':
      case 'german':
        speechLanguage = 'de-DE';
        break;
      case 'en':
      case 'english':
      default:
        speechLanguage = 'en-US';
        break;
    }

    await _speechToText.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: speechLanguage,
      listenFor: timeout ?? const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      cancelOnError: false,
      partialResults: false,
    );
  }

  /// Stop listening for speech
  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
    }
  }

  /// Cancel current listening session
  Future<void> cancel() async {
    if (_isListening) {
      await _speechToText.cancel();
    }
  }

  /// Check if speech recognition is available on this device
  Future<bool> isAvailable() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speechToText.hasPermission;
  }

  /// Get available locales
  Future<List<stt.LocaleName>> getLocales() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _speechToText.locales();
  }

  /// Listen for voice commands (Next, Repeat)
  Future<void> listenForCommand({
    required Function(VoiceCommand) onCommand,
    String language = 'en-US',
  }) async {
    await startListening(
      onResult: (result) {
        final command = _parseCommand(result, language);
        if (command != VoiceCommand.unknown) {
          onCommand(command);
        }
      },
      language: language,
      timeout: const Duration(seconds: 5),
    );
  }

  /// Parse recognized text into commands
  VoiceCommand _parseCommand(String text, String language) {
    final lowercaseText = text.toLowerCase().trim();
    
    if (language.startsWith('de')) {
      // German commands
      if (lowercaseText.contains('weiter') || 
          lowercaseText.contains('nächste') ||
          lowercaseText.contains('next')) {
        return VoiceCommand.next;
      } else if (lowercaseText.contains('wiederhole') || 
                 lowercaseText.contains('nochmal') ||
                 lowercaseText.contains('repeat')) {
        return VoiceCommand.repeat;
      } else if (lowercaseText.contains('stopp') || 
                 lowercaseText.contains('stop')) {
        return VoiceCommand.stop;
      }
    } else {
      // English commands
      if (lowercaseText.contains('next') || 
          lowercaseText.contains('continue') ||
          lowercaseText.contains('weiter')) {
        return VoiceCommand.next;
      } else if (lowercaseText.contains('repeat') || 
                 lowercaseText.contains('again') ||
                 lowercaseText.contains('wiederhole')) {
        return VoiceCommand.repeat;
      } else if (lowercaseText.contains('stop') || 
                 lowercaseText.contains('pause') ||
                 lowercaseText.contains('stopp')) {
        return VoiceCommand.stop;
      }
    }
    
    return VoiceCommand.unknown;
  }

  /// Check if device has microphone permission
  Future<bool> hasPermission() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speechToText.hasPermission;
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    if (!_isInitialized) {
      await initialize();
    }
    return _speechToText.hasPermission;
  }

  /// Dispose of resources
  void dispose() {
    _speech?.stop();
    _isInitialized = false;
  }
}

/// Voice commands that can be recognized
enum VoiceCommand {
  next,
  repeat,
  stop,
  unknown,
}