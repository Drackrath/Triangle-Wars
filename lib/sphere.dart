// sphere.dart
import 'dart:math';
import 'package:flutter/material.dart';

class Sphere {
  double x, y;
  double size;
  double speed;
  Color color;
  Color fillColor;

  Sphere({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.fillColor,
  });

  // Move the sphere towards the triangle's position
  void move(double targetX, double targetY) {
    double dx = targetX - x;
    double dy = targetY - y;
    double distance = sqrt(dx * dx + dy * dy); // Calculate distance to target

    if (distance == 0) return; // Avoid division by zero

    // Normalize the direction vector and move the sphere
    double directionX = dx / distance;
    double directionY = dy / distance;

    x += directionX * speed;
    y += directionY * speed;
  }
}
