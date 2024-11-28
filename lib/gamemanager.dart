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

  GameManager({required this.triangle});

  void startNewRound() {
    isRoundActive = true;
    score = 0;
    spheres.clear();
    spawnSpheres();
  }

  void spawnSpheres() {
    Random rand = Random();
    for (int i = 0; i < 1; i++) {
      double angle = rand.nextDouble() * 2 * pi;
      double distance = 100 + rand.nextDouble() * 100;
      double x = triangle.x + cos(angle) * distance;
      double y = triangle.y + sin(angle) * distance;
      double size = 20 + rand.nextDouble() * 40;
      double speed = 0 + rand.nextDouble() * 0.1;
      Color color = Color.fromRGBO(
          rand.nextInt(256), rand.nextInt(256), rand.nextInt(256), 1);
      Color fillColor = Color.fromRGBO(
          rand.nextInt(256), rand.nextInt(256), rand.nextInt(256), 1);
      Sphere sphere = Sphere(
          x: x,
          y: y,
          size: size,
          health: 2,
          speed: speed,
          damage: 1,
          color: color,
          fillColor: fillColor);
      spheres.add(sphere);
    }
  }

  void update(double deltaTime) {
    if (!isRoundActive) return;

    this.deltaTime = deltaTime;

    // Move each sphere towards the triangle
    for (var sphere in spheres) {
      sphere.move(triangle.x, triangle.y);
    }

    // Move each bullet and check collisions
    for (var bullet in bullets) {
      bullet.move();
    }

    // Check collisions between bullets and spheres
    checkCollisions();
  }

  void checkCollisions() {
    List<Sphere> spheresToRemove = [];
    List<Bullet> bulletsToRemove = [];

    for (var bullet in bullets) {
      for (var sphere in spheres) {
        double dx = bullet.x - sphere.x;
        double dy = bullet.y - sphere.y;
        double distance = sqrt(dx * dx + dy * dy);

        debugPrint("Hit calculation at dx:$dx, dy:$dy");

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
        } else {
          debugPrint(
              "No hit: Distance = $distance, Threshold = $collisionThreshold");
        }
      }
    }

    // Remove bullets and spheres
    bullets.removeWhere((bullet) => bulletsToRemove.contains(bullet));
    spheres.removeWhere((sphere) => spheresToRemove.contains(sphere));

    // Check if the triangle is hit by any spheres
    for (var sphere in spheres) {
      double distance =
          sqrt(pow(triangle.x - sphere.x, 2) + pow(triangle.y - sphere.y, 2));
      if (distance < sphere.size / 2) {
        // Triangle takes damage
        triangle.health -=
            sphere.damage; // Reduce health based on sphere damage
        spheresToRemove.add(sphere); // Mark sphere for removal

        if (triangle.health <= 0) {
          // Triangle is dead
          isRoundActive = false;
          saveProgress();
          resetGame();
          break;
        }
      }
    }

    // Remove remaining spheres
    spheres.removeWhere((sphere) => spheresToRemove.contains(sphere));
  }

  Future<void> saveProgress() async {
    // Save game progress (not implemented)
  }

  Future<void> loadProgress() async {
    // Load game progress (not implemented)
  }

  void resetGame() {
    triangle.health = 100.0;
    score = 0;
    spheres.clear();
  }
}
