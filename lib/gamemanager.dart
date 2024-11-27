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
    for (int i = 0; i < 5; i++) {
      double angle = rand.nextDouble() * 2 * pi;
      double distance = 100 + rand.nextDouble() * 100;
      double x = triangle.x + cos(angle) * distance;
      double y = triangle.y + sin(angle) * distance;
      double size = 20 + rand.nextDouble() * 40;
      double speed = 1.0 + rand.nextDouble() * 2;
      Color color = Color.fromRGBO(
          rand.nextInt(256), rand.nextInt(256), rand.nextInt(256), 1);
      Color fillColor = Color.fromRGBO(
          rand.nextInt(256), rand.nextInt(256), rand.nextInt(256), 1);
      Sphere sphere = Sphere(
          x: x,
          y: y,
          size: size,
          speed: speed,
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
    for (var bullet in bullets) {
      for (var sphere in spheres) {
        double distance =
            sqrt(pow(bullet.x - sphere.x, 2) + pow(bullet.y - sphere.y, 2));
        if (distance < sphere.size / 2) {
          // Bullet hits the sphere
          spheres.remove(sphere);
          bullets.remove(bullet);
          score += 10; // Increase score for destroying a sphere
          break; // Exit loop after collision
        }
      }
    }

    // Check if triangle is hit by any spheres
    for (var sphere in spheres) {
      double distance =
          sqrt(pow(triangle.x - sphere.x, 2) + pow(triangle.y - sphere.y, 2));
      if (distance < sphere.size / 2) {
        triangle.health -= sphere.size; // Reduce health based on sphere size
        spheres.remove(sphere);
        if (triangle.health <= 0) {
          isRoundActive = false;
          saveProgress();
          resetGame();
        }
      }
    }
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
