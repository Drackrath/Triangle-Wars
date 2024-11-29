// gamemanager.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:triangle_wars/bullet.dart';
import 'sphere.dart';
import 'triangle.dart';

// gamemanager.dart

class GameManager {
  Triangle triangle;
  List<Sphere> spheres = [];
  List<Bullet> bullets = []; // List to store the bullets
  double deltaTime = 0.0;
  int score = 0;
  bool isRoundActive = false;
  double _timeSinceLastShot = 0.0;
  double shootInterval = 100; // Time between shots in seconds
  double level = 1;

  GameManager({required this.triangle});

  void startNewRound() {
    isRoundActive = true;
    score = 0;
    spheres.clear();
    level++;
    spawnSpheres(level);
  }

  void spawnSpheres(double level) {
    Random rand = Random();
    for (int i = 0; i < rand.nextInt(15) + level; i++) {
      double angle = rand.nextDouble() * 2 * pi;
      double distance = 300 + rand.nextDouble() * 100;
      double x = triangle.x + cos(angle) * distance;
      double y = triangle.y + sin(angle) * distance;
      double health = level;
      double size = health * 10;
      double speed = 0.2 + rand.nextDouble() * 0.1;

      Color color = Color.fromRGBO(
          rand.nextInt(256), rand.nextInt(256), rand.nextInt(256), 1);
      Color fillColor = Color.fromRGBO(
          rand.nextInt(256), rand.nextInt(256), rand.nextInt(256), 1);
      Sphere sphere = Sphere(
          x: x,
          y: y,
          size: size,
          health: health,
          speed: speed,
          damage: 20,
          color: color,
          fillColor: fillColor);
      spheres.add(sphere);
    }
  }

  void update(double deltaTime) {
    if (!isRoundActive) return;

    this.deltaTime = deltaTime;
    this.shootInterval = this.shootInterval * triangle.attackSpeed;

    // Check for the closest sphere within vision range
    Sphere? closestSphere;
    double minDistance = triangle.range;
    // Move each sphere towards the triangle
    for (var sphere in spheres) {
      sphere.move(triangle.x, triangle.y, deltaTime);

      double distance =
          sqrt(pow(triangle.x - sphere.x, 2) + pow(triangle.y - sphere.y, 2));
      if (distance < minDistance) {
        closestSphere = sphere;
        minDistance = distance;
      }
    }

    // Move each bullet and check collisions
    for (var bullet in bullets) {
      bullet.move(deltaTime);
    }

    _timeSinceLastShot += deltaTime;

    // Rotate and shoot only if a sphere is within the vision range
    if (closestSphere != null) {
      triangle.rotateTowards(closestSphere.x, closestSphere.y);
      if (_timeSinceLastShot >= shootInterval) {
        triangle.shoot();
        _timeSinceLastShot = 0.0; // Reset the timer
      }
    }

    // Check collisions between bullets and spheres
    checkCollisions();
  }

  void checkCollisions() {
    List<Sphere> spheresToRemove = [];
    List<Bullet> bulletsToRemove = [];
    bullets = triangle.bullets; // Get the bullets from the triangle

    for (var bullet in bullets) {
      for (var sphere in spheres) {
        double dx = bullet.x - sphere.x;
        double dy = bullet.y - sphere.y;
        double distance = sqrt(dx * dx + dy * dy);

        //double collisionThreshold = sphere.size / 2; // Radius of the sphere
        // If bullets have size, add bullet radius:
        double collisionThreshold = sphere.size / 2 + bullet.size / 2;

        if (distance < collisionThreshold) {
          // Bullet hits the sphere
          sphere.health -= triangle.attackPower; // Reduce sphere health
          if (sphere.health <= 0) {
            spheresToRemove.add(sphere); // Mark sphere for removal
            score += 10; // Increase score for destroying a sphere
            debugPrint("Sphere destroyed at ${sphere.x}, ${sphere.y}");
          }
          bulletsToRemove.add(bullet); // Mark bullet for removal
          debugPrint("Bullet hit on sphere at ${bullet.x}, ${bullet.y}");
          break; // Exit loop after collision
        }
      }
    }

    // Check if the triangle is hit by any spheres
    for (var sphere in spheres) {
      double distance =
          sqrt(pow(triangle.x - sphere.x, 2) + pow(triangle.y - sphere.y, 2));
      if (distance < sphere.size / 2) {
        // Triangle takes damage
        triangle.currentHealth -=
            sphere.damage; // Reduce health based on sphere damage
        spheresToRemove.add(sphere); // Mark sphere for removal

        if (triangle.currentHealth <= 0) {
          // Triangle is dead
          isRoundActive = false;
          saveProgress();
          resetGame();
          break;
        }
      }
    }

    // Remove bullets and spheres
    bullets.removeWhere((bullet) => bulletsToRemove.contains(bullet));
    spheres.removeWhere((sphere) => spheresToRemove.contains(sphere));
  }

  Future<void> saveProgress() async {
    // Save game progress (not implemented)
  }

  Future<void> loadProgress() async {
    // Load game progress (not implemented)
  }

  void resetGame() {
    triangle.currentHealth = 100.0;
    score = 0;
    bullets.clear();
    deltaTime = 0.0;
    isRoundActive = false;
    _timeSinceLastShot = 0.0;
    level = 1;
    spheres.clear();
  }
}
