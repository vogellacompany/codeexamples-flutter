import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:dictato/main.dart';
import 'package:dictato/services/storage_service.dart';
import 'package:dictato/models/models.dart';

void main() {
  group('Widget Tests', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await StorageService.initialize();
    });

    testWidgets('DictatoApp creates without error', (WidgetTester tester) async {
      await tester.pumpWidget(DictatoApp());
      await tester.pumpAndSettle();
      
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('App shows users screen when no current user', (WidgetTester tester) async {
      final appState = AppState();
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('de', ''),
          ],
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Builder(
              builder: (context) {
                final appState = Provider.of<AppState>(context);
                return appState.currentUser == null
                    ? Scaffold(body: Text('No user selected'))
                    : Scaffold(body: Text('User selected'));
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.text('No user selected'), findsOneWidget);
    });

    testWidgets('App shows home screen when user is selected', (WidgetTester tester) async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );
      
      final appState = AppState();
      await appState.setCurrentUser(user);
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''),
            Locale('de', ''),
          ],
          home: ChangeNotifierProvider<AppState>.value(
            value: appState,
            child: Builder(
              builder: (context) {
                final appState = Provider.of<AppState>(context);
                return appState.currentUser == null
                    ? Scaffold(body: Text('No user selected'))
                    : Scaffold(body: Text('User selected: ${appState.currentUser!.name}'));
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.text('User selected: Test User'), findsOneWidget);
    });

    testWidgets('AppState notifies listeners on user change', (WidgetTester tester) async {
      final appState = AppState();
      bool listenerCalled = false;
      
      appState.addListener(() {
        listenerCalled = true;
      });

      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await appState.addUser(user);
      
      expect(listenerCalled, true);
    });

    testWidgets('AppState filters texts for current user', (WidgetTester tester) async {
      final appState = AppState();
      
      final user = User(
        id: 'user1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );
      
      await appState.addUser(user);
      await appState.setCurrentUser(user);
      
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
      
      await appState.addText(publicText);
      await appState.addText(privateText);
      await appState.addText(otherPrivateText);
      
      final availableTexts = appState.availableTexts;
      
      expect(availableTexts.length, 2); // Public + user's private text
      expect(availableTexts.any((t) => t.id == publicText.id), true);
      expect(availableTexts.any((t) => t.id == privateText.id), true);
      expect(availableTexts.any((t) => t.id == otherPrivateText.id), false);
    });

    testWidgets('AppState handles empty states correctly', (WidgetTester tester) async {
      final appState = AppState();
      
      expect(appState.users, isEmpty);
      expect(appState.texts, isEmpty);
      expect(appState.sessions, isEmpty);
      expect(appState.currentUser, isNull);
      expect(appState.availableTexts, isEmpty);
      expect(appState.currentUserSessions, isEmpty);
      expect(appState.completedSessions, isEmpty);
    });
  });

  group('AppState Tests', () {
    late AppState appState;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await StorageService.initialize();
      appState = AppState();
    });

    test('Add user updates state', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await appState.addUser(user);
      
      expect(appState.users.length, 1);
      expect(appState.users.first.id, user.id);
    });

    test('Set current user works', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await appState.addUser(user);
      await appState.setCurrentUser(user);
      
      expect(appState.currentUser, isNotNull);
      expect(appState.currentUser!.id, user.id);
    });

    test('Delete user removes from state', () async {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      await appState.addUser(user);
      await appState.setCurrentUser(user);
      await appState.deleteUser(user.id);
      
      expect(appState.users.length, 0);
      expect(appState.currentUser, isNull);
    });

    test('Add text updates state', () async {
      final text = DictationText.create(
        id: '1',
        title: 'Test Text',
        content: 'Test content.',
        language: 'en',
      );

      await appState.addText(text);
      
      expect(appState.texts.length, 1);
      expect(appState.texts.first.id, text.id);
    });

    test('Save session updates state', () async {
      final session = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      await appState.saveSession(session);
      
      expect(appState.sessions.length, 1);
      expect(appState.sessions.first.id, session.id);
    });
  });
}