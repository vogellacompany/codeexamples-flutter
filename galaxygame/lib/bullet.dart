import 'package:flame/components.dart';

import 'constants.dart';
import 'explosion.dart';
import 'galaxy.dart';

class Bullet extends SpriteComponent with HasGameReference<Galaxy> {
  Bullet({required Vector2 start})
      : super(size: Vector2.all(bulletSize), position: start);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('gun.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (game.gameOver) {
      return;
    }

    position.y -= dt * bulletSpeed;

    if (position.y + bulletSize < 0) {
      removeFromParent();
      return;
    }

    // Copy the list, since a hit removes the dragon from it.
    final hits =
        game.dragons.where((dragon) => dragon.toRect().overlaps(toRect())).toList();
    if (hits.isEmpty) {
      return;
    }

    for (final dragon in hits) {
      game.points += 1;
      game.add(Explosion(at: dragon.position.clone()));
      dragon.removeFromParent();
    }
    removeFromParent();
  }
}
