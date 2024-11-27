import "package:flutter/material.dart";

class Sphere {
  double x, y; // Position of the sphere
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

  void move() {
    y += speed;
  }
}
