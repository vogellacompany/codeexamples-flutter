import 'package:flutter_tts/flutter_tts.dart';

/// Service for text-to-speech functionality
class TextToSpeechService {
  static final TextToSpeechService _instance = TextToSpeechService._internal();
  factory TextToSpeechService() => _instance;
  TextToSpeechService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;

  /// Initialize the TTS service
  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterTts = FlutterTts();
    
    // Configure TTS settings
    await _flutterTts!.setSharedInstance(true);
    await _flutterTts!.awaitSpeakCompletion(true);
    
    // Set default speaking rate
    await _flutterTts!.setSpeechRate(0.4); // Slower for learning
    
    // Set default pitch
    await _flutterTts!.setPitch(1.0);
    
    _isInitialized = true;
  }

  FlutterTts get _tts {
    assert(_isInitialized, 'TextToSpeechService not initialized');
    return _flutterTts!;
  }

  /// Set the language for speech
  Future<void> setLanguage(String language) async {
    String ttsLanguage;
    switch (language.toLowerCase()) {
      case 'de':
      case 'german':
        ttsLanguage = 'de-DE';
        break;
      case 'en':
      case 'english':
      default:
        ttsLanguage = 'en-US';
        break;
    }
    
    await _tts.setLanguage(ttsLanguage);
  }

  /// Set speaking rate (0.0 to 1.0, where 0.5 is normal)
  Future<void> setSpeechRate(double rate) async {
    await _tts.setSpeechRate(rate);
  }

  /// Set voice pitch (0.5 to 2.0, where 1.0 is normal)
  Future<void> setPitch(double pitch) async {
    await _tts.setPitch(pitch);
  }

  /// Speak the given text
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    
    await _tts.speak(text);
  }

  /// Stop current speech
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Pause current speech
  Future<void> pause() async {
    await _tts.pause();
  }

  /// Check if TTS is currently speaking
  Future<bool> get isSpeaking async {
    final state = await _tts.getState();
    return state == FlutterTtsState.playing;
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    return await _tts.getLanguages();
  }

  /// Get available voices for current language
  Future<List<dynamic>> getVoices() async {
    return await _tts.getVoices();
  }

  /// Set voice by name
  Future<void> setVoice(Map<String, String> voice) async {
    await _tts.setVoice(voice);
  }

  /// Configure TTS for child-friendly dictation
  Future<void> configureForDictation() async {
    await setSpeechRate(0.3); // Very slow for dictation
    await setPitch(1.1); // Slightly higher pitch for clarity
  }

  /// Configure TTS for normal reading
  Future<void> configureForReading() async {
    await setSpeechRate(0.5); // Normal reading speed
    await setPitch(1.0); // Normal pitch
  }

  /// Set completion callback
  void setCompletionHandler(void Function() onComplete) {
    _tts.setCompletionHandler(onComplete);
  }

  /// Set error callback
  void setErrorHandler(void Function(String message) onError) {
    _tts.setErrorHandler(onError);
  }

  /// Set progress callback for word-by-word highlighting
  void setProgressHandler(void Function(String text, int start, int end, String word) onProgress) {
    _tts.setProgressHandler(onProgress);
  }

  /// Dispose of resources
  void dispose() {
    _flutterTts?.stop();
    _isInitialized = false;
  }
}