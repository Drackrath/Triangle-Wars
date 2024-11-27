// bullet.dart
import 'dart:math';
import 'package:flutter/material.dart';

class Bullet {
  double x, y; // Position of the bullet
  double speed; // Speed of the bullet
  double angle; // Direction in radians
  double size; // Size of the bullet

  Bullet({
    required this.x,
    required this.y,
    required this.angle,
    this.speed = 5.0,
    this.size = 5.0,
  });

  // Move the bullet towards its target direction
  void move() {
    x += cos(angle) * speed;
    y += sin(angle) * speed;
  }
}
