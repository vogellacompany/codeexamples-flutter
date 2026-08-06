import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';

import 'bullet.dart';
import 'constants.dart';
import 'dragon.dart';

class Galaxy extends FlameGame with TapDetector, HorizontalDragDetector {
  static const _waveInterval = 4.0;

  final List<Dragon> dragons = <Dragon>[];

  bool gameOver = false;
  int points = 0;

  /// Where the next bullet is fired from.
  Vector2 aim = Vector2.zero();

  double _waveTimer = _waveInterval;

  final TextPaint _textPaint = TextPaint(
    style: const TextStyle(color: Colors.white, fontSize: 48.0),
  );

  @override
  void update(double dt) {
    super.update(dt);
    if (gameOver) {
      return;
    }

    _waveTimer += dt;
    if (_waveTimer >= _waveInterval) {
      _waveTimer = 0.0;
      _spawnWave();
    }
  }

  void _spawnWave() {
    for (var column = 1; column <= dragonSize ~/ 7; column++) {
      for (var row = 0; row < column; row++) {
        final dragon = Dragon(column: column, row: row);
        dragons.add(dragon);
        add(dragon);
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (gameOver) {
      _textPaint.render(canvas, 'Game over', Vector2(size.x / 5, size.y / 2));
    } else {
      _textPaint.render(
        canvas,
        '$points',
        Vector2(size.x - 10, size.y - 10),
        anchor: Anchor.bottomRight,
      );
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if (gameOver) {
      return;
    }
    aim = info.eventPosition.widget;
    add(Bullet(start: aim.clone()));
  }

  @override
  void onHorizontalDragUpdate(DragUpdateInfo info) {
    aim = info.eventPosition.widget;
  }
}
