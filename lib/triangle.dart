// triangle.dart
import 'dart:math'; // For math functions like atan2
import 'package:triangle_wars/bullet.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

// triangle.dart

class Triangle {
  double x, y;
  double speed;
  double attackSpeed;
  double attackPower;
  double range;
  double health;
  double rotation;
  double rotationSpeed;
  double size;
  List<Bullet> bullets = [];

  Triangle({
    required this.x,
    required this.y,
    this.speed = 5.0,
    this.attackSpeed = 1.0,
    this.attackPower = 1.0,
    this.range = 100.0,
    this.health = 100.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.1,
    this.size = 40.0,
  });

  void move(double deltaX, double deltaY) {
    x += deltaX;
    y += deltaY;
  }

  void upgradeSpeed(double increment) {
    speed += increment;
  }

  void upgradeAttackPower(double increment) {
    attackPower += increment;
  }

  void upgradeHealth(double increment) {
    health += increment;
  }

  // Fire a bullet in the direction the triangle is facing
  void shoot() {
    double bulletX = x + cos(rotation) * size;
    double bulletY = y + sin(rotation) * size;
    double bulletAngle = rotation;

    // Create and add the new bullet to the list
    bullets.add(Bullet(x: bulletX, y: bulletY, angle: bulletAngle));
  }

  // Smoothly rotate triangle to face a specific point (e.g., nearest sphere)
  void rotateTowards(double targetX, double targetY) {
    double dx = targetX - x;
    double dy = targetY - y;

    double targetAngle = atan2(dy, dx);
    rotation = lerpRotation(rotation, targetAngle, rotationSpeed);
    debugPrint('dx: $dx, dy: $dy, targetAngle: $targetAngle');
  }

  List<double> calculateLineOffsets(
      double targetX, double targetY, double length) {
    double dx = targetX - x;
    double dy = targetY - y;

    double targetAngle = atan2(dy, dx) - pi;
    rotation = lerpRotation(rotation, targetAngle, rotationSpeed);
    // Calculate the end point of the line based on the rotation angle
    double endX = x + cos(rotation) * length;
    double endY = y + sin(rotation) * length;

    // Return the start and end offsets
    return [x, y, endX, endY];
  }

  double lerpRotation(double currentAngle, double targetAngle, double speed) {
    double diff = (targetAngle - currentAngle) % (2 * pi);
    if (diff > pi) diff -= 2 * pi;

    return currentAngle + diff * speed;
  }
}
