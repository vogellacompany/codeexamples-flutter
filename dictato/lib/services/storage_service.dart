import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// Service for persisting application data locally
class StorageService {
  static const String _usersKey = 'dictato_users';
  static const String _textsKey = 'dictato_texts';
  static const String _sessionsKey = 'dictato_sessions';
  static const String _currentUserKey = 'dictato_current_user';

  static SharedPreferences? _prefs;

  /// Initialize the storage service
  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _preferences {
    assert(_prefs != null, 'StorageService not initialized');
    return _prefs!;
  }

  // User management
  Future<List<User>> getUsers() async {
    final String? usersJson = _preferences.getString(_usersKey);
    if (usersJson == null || usersJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> usersList = jsonDecode(usersJson);
      return usersList.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      print('Error decoding users: $e');
      return [];
    }
  }

  Future<void> saveUsers(List<User> users) async {
    try {
      final String usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
      await _preferences.setString(_usersKey, usersJson);
    } catch (e) {
      print('Error saving users: $e');
      rethrow;
    }
  }

  Future<void> addUser(User user) async {
    final users = await getUsers();
    users.add(user);
    await saveUsers(users);
  }

  Future<void> deleteUser(String userId) async {
    final users = await getUsers();
    users.removeWhere((user) => user.id == userId);
    await saveUsers(users);
    
    // Clear current user if it was deleted
    final currentUser = await getCurrentUser();
    if (currentUser?.id == userId) {
      await setCurrentUser(null);
    }
  }

  Future<User?> getCurrentUser() async {
    final String? currentUserId = _preferences.getString(_currentUserKey);
    if (currentUserId == null) return null;

    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == currentUserId);
    } catch (e) {
      // User no longer exists
      await setCurrentUser(null);
      return null;
    }
  }

  Future<void> setCurrentUser(User? user) async {
    if (user == null) {
      await _preferences.remove(_currentUserKey);
    } else {
      await _preferences.setString(_currentUserKey, user.id);
    }
  }

  // Text management
  Future<List<DictationText>> getTexts() async {
    final String? textsJson = _preferences.getString(_textsKey);
    if (textsJson == null || textsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> textsList = jsonDecode(textsJson);
      return textsList.map((json) => DictationText.fromJson(json)).toList();
    } catch (e) {
      print('Error decoding texts: $e');
      return [];
    }
  }

  Future<void> saveTexts(List<DictationText> texts) async {
    try {
      final String textsJson = jsonEncode(texts.map((text) => text.toJson()).toList());
      await _preferences.setString(_textsKey, textsJson);
    } catch (e) {
      print('Error saving texts: $e');
      rethrow;
    }
  }

  Future<void> addText(DictationText text) async {
    final texts = await getTexts();
    texts.add(text);
    await saveTexts(texts);
  }

  Future<void> deleteText(String textId) async {
    final texts = await getTexts();
    texts.removeWhere((text) => text.id == textId);
    await saveTexts(texts);
  }

  Future<List<DictationText>> getTextsForUser(String? userId) async {
    final texts = await getTexts();
    return texts.where((text) => text.userId == userId || text.userId == null).toList();
  }

  // Training session management
  Future<List<TrainingSession>> getSessions() async {
    final String? sessionsJson = _preferences.getString(_sessionsKey);
    if (sessionsJson == null || sessionsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> sessionsList = jsonDecode(sessionsJson);
      return sessionsList.map((json) => TrainingSession.fromJson(json)).toList();
    } catch (e) {
      print('Error decoding sessions: $e');
      return [];
    }
  }

  Future<void> saveSessions(List<TrainingSession> sessions) async {
    try {
      final String sessionsJson = jsonEncode(sessions.map((session) => session.toJson()).toList());
      await _preferences.setString(_sessionsKey, sessionsJson);
    } catch (e) {
      print('Error saving sessions: $e');
      rethrow;
    }
  }

  Future<void> addSession(TrainingSession session) async {
    final sessions = await getSessions();
    sessions.add(session);
    await saveSessions(sessions);
  }

  Future<void> updateSession(TrainingSession session) async {
    final sessions = await getSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
      await saveSessions(sessions);
    }
  }

  Future<List<TrainingSession>> getSessionsForUser(String userId) async {
    final sessions = await getSessions();
    return sessions.where((session) => session.userId == userId).toList();
  }

  Future<List<TrainingSession>> getCompletedSessionsForUser(String userId) async {
    final sessions = await getSessionsForUser(userId);
    return sessions.where((session) => session.isCompleted).toList();
  }

  /// Clear all stored data (useful for testing or reset)
  Future<void> clearAll() async {
    await _preferences.remove(_usersKey);
    await _preferences.remove(_textsKey);
    await _preferences.remove(_sessionsKey);
    await _preferences.remove(_currentUserKey);
  }
}