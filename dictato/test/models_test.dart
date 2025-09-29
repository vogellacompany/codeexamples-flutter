import 'package:flutter_test/flutter_test.dart';
import 'package:dictato/models/models.dart';

void main() {
  group('User Model Tests', () {
    test('User creation', () {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      expect(user.id, '1');
      expect(user.name, 'Test User');
      expect(user.preferredLanguage, 'en');
    });

    test('User equality', () {
      final now = DateTime.now();
      final user1 = User(
        id: '1',
        name: 'Test User',
        createdAt: now,
        preferredLanguage: 'en',
      );
      final user2 = User(
        id: '1',
        name: 'Different Name',
        createdAt: now,
        preferredLanguage: 'de',
      );

      expect(user1, equals(user2)); // Same ID
    });

    test('User copyWith', () {
      final user = User(
        id: '1',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferredLanguage: 'en',
      );

      final updatedUser = user.copyWith(name: 'Updated Name');

      expect(updatedUser.id, user.id);
      expect(updatedUser.name, 'Updated Name');
      expect(updatedUser.preferredLanguage, user.preferredLanguage);
    });
  });

  group('DictationText Model Tests', () {
    test('DictationText creation with segmentation', () {
      const content = 'This is a test sentence. This is another sentence for testing. And one more for good measure.';
      
      final text = DictationText.create(
        id: '1',
        title: 'Test Text',
        content: content,
        language: 'en',
      );

      expect(text.id, '1');
      expect(text.title, 'Test Text');
      expect(text.content, content);
      expect(text.language, 'en');
      expect(text.segments, isNotEmpty);
      expect(text.segments.length, greaterThan(0));
    });

    test('DictationText segmentation', () {
      const content = 'Short sentence. Another short one.';
      
      final text = DictationText.create(
        id: '1',
        title: 'Test',
        content: content,
        language: 'en',
      );

      expect(text.segments.length, 2);
      expect(text.segments[0], contains('Short sentence'));
      expect(text.segments[1], contains('Another short one'));
    });

    test('DictationText with long sentences', () {
      const content = 'This is a very long sentence that should be split because it exceeds the maximum recommended length for dictation segments and should be broken down into smaller, more manageable pieces. This is another sentence.';
      
      final text = DictationText.create(
        id: '1',
        title: 'Test',
        content: content,
        language: 'en',
      );

      expect(text.segments.length, greaterThan(1));
      // Each segment should be reasonably short
      for (final segment in text.segments) {
        expect(segment.length, lessThanOrEqualTo(120));
      }
    });
  });

  group('TrainingSession Model Tests', () {
    test('TrainingSession creation', () {
      final session = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      expect(session.id, '1');
      expect(session.userId, 'user1');
      expect(session.textId, 'text1');
      expect(session.totalSegments, 3);
      expect(session.currentSegmentIndex, 0);
      expect(session.segmentResults, isEmpty);
      expect(session.isCompleted, false);
    });

    test('TrainingSession adding segment results', () {
      final session = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      final result = SegmentResult(
        segmentIndex: 0,
        errorCount: 2,
        completedAt: DateTime.now(),
      );

      final updatedSession = session.addSegmentResult(result);

      expect(updatedSession.segmentResults.length, 1);
      expect(updatedSession.segmentResults.first, result);
      expect(updatedSession.currentSegmentIndex, 1);
    });

    test('TrainingSession completion', () {
      final session = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 2,
      );

      final completedSession = session.complete();

      expect(completedSession.isCompleted, true);
      expect(completedSession.completedAt, isNotNull);
    });

    test('TrainingSession total errors calculation', () {
      var session = TrainingSession.create(
        id: '1',
        userId: 'user1',
        textId: 'text1',
        totalSegments: 3,
      );

      session = session.addSegmentResult(SegmentResult(
        segmentIndex: 0,
        errorCount: 2,
        completedAt: DateTime.now(),
      ));

      session = session.addSegmentResult(SegmentResult(
        segmentIndex: 1,
        errorCount: 1,
        completedAt: DateTime.now(),
      ));

      expect(session.totalErrors, 3);
    });
  });

  group('SegmentResult Model Tests', () {
    test('SegmentResult creation', () {
      final now = DateTime.now();
      final result = SegmentResult(
        segmentIndex: 0,
        errorCount: 2,
        completedAt: now,
      );

      expect(result.segmentIndex, 0);
      expect(result.errorCount, 2);
      expect(result.completedAt, now);
    });

    test('SegmentResult equality', () {
      final now = DateTime.now();
      final result1 = SegmentResult(
        segmentIndex: 0,
        errorCount: 2,
        completedAt: now,
      );
      final result2 = SegmentResult(
        segmentIndex: 0,
        errorCount: 5,
        completedAt: now.add(Duration(minutes: 1)),
      );

      expect(result1, equals(result2)); // Same segment index
    });
  });
}