// gamemanager.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'triangle.dart';
import 'sphere.dart';

class GameManager {
  Triangle triangle;
  List<Sphere> spheres = [];
  double deltaTime = 0.0; // Time elapsed for game logic
  int score = 0; // Score based on how long the triangle survives

  GameManager({required this.triangle});

  void spawnSphere() {
    // Logic to spawn spheres (randomize attributes)
    double size = (50 + (100 * 0.5)); // Randomize size
    double speed = 1.0; // Randomize speed
    Color color = Colors.blue; // Randomize color
    Color fillColor = Colors.red; // Randomize fill color

    Sphere newSphere = Sphere(
      x: 100, // Example position
      y: 0,
      size: size,
      speed: speed,
      color: color,
      fillColor: fillColor,
    );
    spheres.add(newSphere);
  }

  void update(double deltaTime) {
    this.deltaTime = deltaTime;
    for (var sphere in spheres) {
      sphere.move();
    }
    checkCollisions();
  }

  void checkCollisions() {
    for (var sphere in spheres) {
      double distance =
          (triangle.x - sphere.x).abs() + (triangle.y - sphere.y).abs();
      if (distance < sphere.size / 2) {
        triangle.health -= sphere.size; // Deduct health based on sphere size
        spheres.remove(sphere);
        if (triangle.health <= 0) {
          // Triangle loses all health
          saveProgress();
          resetGame();
        }
      }
    }
  }

  // Save the triangle's progress to SharedPreferences
  Future<void> saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('triangleSpeed', triangle.speed);
    await prefs.setDouble('triangleAttackPower', triangle.attackPower);
    await prefs.setDouble('triangleHealth', triangle.health);
    await prefs.setInt('score', score);
  }

  // Load the progress from SharedPreferences
  Future<void> loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    triangle.speed = prefs.getDouble('triangleSpeed') ?? 5.0;
    triangle.attackPower = prefs.getDouble('triangleAttackPower') ?? 1.0;
    triangle.health = prefs.getDouble('triangleHealth') ?? 100.0;
    score = prefs.getInt('score') ?? 0;
  }

  // Reset the game after the triangle loses all health
  void resetGame() {
    triangle.health = 100.0;
    score = 0;
    // Add logic to spawn new spheres or reset game state
  }
}
