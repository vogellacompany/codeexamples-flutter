import 'package:flame/game.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:galaxygame/galaxy.dart';
import 'package:galaxygame/main.dart';

void main() {
  testWidgets('renders the game widget', (WidgetTester tester) async {
    await tester.pumpWidget(const GalaxyApp());

    expect(find.byType(GameWidget<Galaxy>), findsOneWidget);
  });

  test('starts with no points and not over', () {
    final game = Galaxy();

    expect(game.points, 0);
    expect(game.gameOver, isFalse);
    expect(game.dragons, isEmpty);
  });
}
