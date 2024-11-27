// triangle.dart
class Triangle {
  double x, y; // Position of the triangle
  double speed;
  double attackSpeed;
  double attackPower;
  double range;
  double health;

  Triangle({
    required this.x,
    required this.y,
    this.speed = 5.0,
    this.attackSpeed = 1.0,
    this.attackPower = 1.0,
    this.range = 100.0,
    this.health = 100.0,
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
}
