import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dictato/services/storage_service.dart';
import 'package:dictato/models/models.dart';

void main() {
  group('StorageService Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await StorageService.initialize();
      storageService = StorageService();
    });

    tearDown(() async {
      await storageService.clearAll();
    });

    test('Add and get users', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await storageService.addUser(user);
      final users = await storageService.getUsers();

      expect(users.length, 1);
      expect(users.first.id, user.id);
      expect(users.first.name, user.name);
    });

    test('Set and get current user', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await storageService.addUser(user);
      await storageService.setCurrentUser(user);

      final currentUser = await storageService.getCurrentUser();
      expect(currentUser, isNotNull);
      expect(currentUser!.id, user.id);
    });

    test('Delete user', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await storageService.addUser(user);
      await storageService.setCurrentUser(user);
      await storageService.deleteUser(user.id);

      final users = await storageService.getUsers();
      final currentUser = await storageService.getCurrentUser();

      expect(users.length, 0);
      expect(currentUser, isNull);
    });

    test('Add and get texts', () async {
      final text = DictationText.create(
        id: '1',
        title: 'Test Text',
        content: 'This is a test content.',
        language: 'en',
      );

      await storageService.addText(text);
      final texts = await storageService.getTexts();

      expect(texts.length, 1);
      expect(texts.first.id, text.id);
      expect(texts.first.title, text.title);
    });

    test('Get texts for user', () async {
      final publicText = DictationText.create(
        id: '1',
        title: 'Public Text',
        content: 'Public content.',
        language: 'en',
        userId: null,
      );

      final privateText = DictationText.create(
        id: '2',
        title: 'Private Text',
        content: 'Private content.',
        language: 'en',
        userId: 'user1',
      );

      final otherPrivateText = DictationText.create(
        id: '3',
        title: 'Other Private Text',
        content: 'Other private content.',
        language: 'en',
        userId: 'user2',
      );

      await storageService.addText(publicText);
      await storageService.addText(privateText);
      await storageService.addText(otherPrivateText);

      final user1Texts = await storageService.getTextsForUser('user1');
      final user2Texts = await storageService.getTextsForUser('user2');

      expect(user1Texts.length, 2); // Public + private for user1
      expect(user2Texts.length, 2); // Public + private for user2
      
      expect(user1Texts.any((t) => t.id == publicText.id), true);
      expect(user1Texts.any((t) => t.id == privateText.id), true);
      expect(user1Texts.any((t) => t.id == otherPrivateText.id), false);
    });

    test('Add and update training session', () async {
      final session = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      await storageService.addSession(session);
      
      final result = SegmentResult(
        segmentIndex: 0,
        errorCount: 1,
        completedAt: DateTime.now(),
      );
      
      final updatedSession = session.addSegmentResult(result);
      await storageService.updateSession(updatedSession);

      final sessions = await storageService.getSessions();
      expect(sessions.length, 1);
      expect(sessions.first.segmentResults.length, 1);
      expect(sessions.first.totalErrors, 1);
    });

    test('Get sessions for user', () async {
      final session1 = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      final session2 = TrainingSession.create(
        id: '2',
        userId: 'user2',
        textId: 'text1',
        totalSegments: 3,
      );

      await storageService.addSession(session1);
      await storageService.addSession(session2);

      final user1Sessions = await storageService.getSessionsForUser('user1');
      expect(user1Sessions.length, 1);
      expect(user1Sessions.first.userId, 'user1');
    });

    test('Get completed sessions for user', () async {
      final incompleteSession = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      final completeSession = TrainingSession.create(
        id: '2',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      ).complete();

      await storageService.addSession(incompleteSession);
      await storageService.addSession(completeSession);

      final completedSessions = await storageService.getCompletedSessionsForUser('user1');
      expect(completedSessions.length, 1);
      expect(completedSessions.first.isCompleted, true);
    });

    test('Clear all data', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      final text = DictationText.create(
        id: '1',
        title: 'Test Text',
        content: 'Test content.',
        language: 'en',
      );

      await storageService.addUser(user);
      await storageService.addText(text);
      await storageService.setCurrentUser(user);

      await storageService.clearAll();

      final users = await storageService.getUsers();
      final texts = await storageService.getTexts();
      final sessions = await storageService.getSessions();
      final currentUser = await storageService.getCurrentUser();

      expect(users.length, 0);
      expect(texts.length, 0);
      expect(sessions.length, 0);
      expect(currentUser, isNull);
    });
  });
}