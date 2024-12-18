// triangle.dart
import 'dart:math'; // For math functions like atan2
import 'package:triangle_wars/bullet.dart';

class Triangle {
  double x, y;
  double velocity;
  double attackSpeed;
  double attackPower;
  double range;
  double currentHealth;
  double maxHealth;
  double rotation;
  double rotationSpeed;
  double size;
  List<Bullet> bullets = [];

  Triangle({
    required this.x,
    required this.y,
    this.velocity = 1.0,
    this.attackSpeed = 1.0,
    this.attackPower = 1.0,
    this.range = 100.0,
    this.currentHealth = 100.0,
    this.maxHealth = 100.0,
    this.rotation = 0.0,
    this.rotationSpeed = 0.1,
    this.size = 40.0,
  });

  void move(double deltaX, double deltaY) {
    x += deltaX;
    y += deltaY;
  }

  void upgradeSpeed(double increment) {
    velocity += increment;
  }

  void upgradeRange(double increment) {
    range += increment;
  }

  void upgradeAttackPower(double increment) {
    attackPower += increment;
  }

  void upgradeAttackSpeed(double increment) {
    attackSpeed += increment;
  }

  void upgradeHealth(double increment) {
    maxHealth += increment;
    currentHealth += increment;
  }

  // Fire a bullet in the direction the triangle is facing
  void shoot() {
    // Calculate the tip of the triangle as the bullet's starting position
    double bulletX = x + cos(rotation - pi / 2) * (size / 2);
    double bulletY = y + sin(rotation - pi / 2) * (size / 2);

    // The bullet's angle matches the triangle's rotation
    double bulletAngle = rotation - pi / 2;

    // Create and add the new bullet to the list
    bullets.add(
        Bullet(x: bulletX, y: bulletY, angle: bulletAngle, speed: velocity));
  }

  // Smoothly rotate triangle to face a specific point (e.g., nearest sphere)
  void rotateTowards(double targetX, double targetY) {
    double dx = targetX - x;
    double dy = targetY - y;

    double targetAngle = atan2(dy, dx) + pi / 2;
    rotation = lerpRotation(rotation, targetAngle, rotationSpeed);
    // debugPrint('dx: $dx, dy: $dy, targetAngle: $targetAngle');
  }

  List<double> calculateLineOffsets(
      double targetX, double targetY, double length) {
    double dx = targetX - x;
    double dy = targetY - y;

    double targetAngle = atan2(dy, dx) + pi / 2;
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
