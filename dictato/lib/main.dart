import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';

import 'models/models.dart';
import 'screens/home_screen.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await StorageService.initialize();
  await TextToSpeechService().initialize();
  await SpeechRecognitionService().initialize();
  
  runApp(DictatoApp());
}

class DictatoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Dictato',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''), // English
          Locale('de', ''), // German
        ],
        home: HomeScreen(),
      ),
    );
  }
}

/// Global application state
class AppState extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  // Current user
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Available users
  List<User> _users = [];
  List<User> get users => _users;

  // Available texts
  List<DictationText> _texts = [];
  List<DictationText> get texts => _texts;

  // Training sessions
  List<TrainingSession> _sessions = [];
  List<TrainingSession> get sessions => _sessions;

  // Current app language
  String _appLanguage = 'en';
  String get appLanguage => _appLanguage;

  AppState() {
    _loadData();
  }

  /// Load all data from storage
  Future<void> _loadData() async {
    try {
      _currentUser = await _storageService.getCurrentUser();
      _users = await _storageService.getUsers();
      _texts = await _storageService.getTexts();
      _sessions = await _storageService.getSessions();
      notifyListeners();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  /// Set current user
  Future<void> setCurrentUser(User? user) async {
    try {
      await _storageService.setCurrentUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      print('Error setting current user: $e');
      rethrow;
    }
  }

  /// Add a new user
  Future<void> addUser(User user) async {
    try {
      await _storageService.addUser(user);
      _users = await _storageService.getUsers();
      notifyListeners();
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await _storageService.deleteUser(userId);
      _users = await _storageService.getUsers();
      _currentUser = await _storageService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  /// Add a new text
  Future<void> addText(DictationText text) async {
    try {
      await _storageService.addText(text);
      _texts = await _storageService.getTexts();
      notifyListeners();
    } catch (e) {
      print('Error adding text: $e');
      rethrow;
    }
  }

  /// Delete a text
  Future<void> deleteText(String textId) async {
    try {
      await _storageService.deleteText(textId);
      _texts = await _storageService.getTexts();
      notifyListeners();
    } catch (e) {
      print('Error deleting text: $e');
      rethrow;
    }
  }

  /// Get texts available to current user
  List<DictationText> get availableTexts {
    if (_currentUser == null) return [];
    return _texts.where((text) => 
      text.userId == null || text.userId == _currentUser!.id
    ).toList();
  }

  /// Add or update training session
  Future<void> saveSession(TrainingSession session) async {
    try {
      final existingIndex = _sessions.indexWhere((s) => s.id == session.id);
      if (existingIndex != -1) {
        await _storageService.updateSession(session);
      } else {
        await _storageService.addSession(session);
      }
      _sessions = await _storageService.getSessions();
      notifyListeners();
    } catch (e) {
      print('Error saving session: $e');
      rethrow;
    }
  }

  /// Get sessions for current user
  List<TrainingSession> get currentUserSessions {
    if (_currentUser == null) return [];
    return _sessions.where((session) => session.userId == _currentUser!.id).toList();
  }

  /// Get completed sessions for current user
  List<TrainingSession> get completedSessions {
    return currentUserSessions.where((session) => session.isCompleted).toList();
  }

  /// Set app language
  void setAppLanguage(String language) {
    _appLanguage = language;
    notifyListeners();
  }

  /// Refresh all data from storage
  Future<void> refresh() async {
    await _loadData();
  }
}