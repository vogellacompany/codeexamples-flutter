import 'package:flame/components.dart';

import 'constants.dart';

class Explosion extends SpriteAnimationComponent {
  static const _duration = 0.75;
  static const _frames = 7;

  Explosion({required Vector2 at})
      : super(
          size: Vector2.all(dragonSize),
          position: at,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    animation = await SpriteAnimation.load(
      'explosion-4.png',
      SpriteAnimationData.sequenced(
        amount: _frames,
        stepTime: _duration / _frames,
        textureSize: Vector2.all(31),
        loop: false,
      ),
    );
  }
}
