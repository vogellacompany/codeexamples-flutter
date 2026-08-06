import 'package:flame/components.dart';

import 'constants.dart';
import 'galaxy.dart';

class Dragon extends SpriteComponent with HasGameReference<Galaxy> {
  Dragon({required this.column, required this.row})
      : super(size: Vector2.all(dragonSize));

  final int column;
  final int row;

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('dragon.png');
    position = Vector2(dragonSize * column, dragonSize * row);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameOver) {
      return;
    }

    position.y += dt * dragonSpeed;

    // A dragon that reaches the bottom of the screen ends the game.
    if (position.y >= game.size.y) {
      game.gameOver = true;
    }
  }

  @override
  void onRemove() {
    game.dragons.remove(this);
    super.onRemove();
  }
}
