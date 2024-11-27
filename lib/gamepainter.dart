// gamepainter.dart
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'gamemanager.dart';
import 'sphere.dart';
import 'bullet.dart';

class GamePainter extends CustomPainter {
  final GameManager gameManager;

  GamePainter({required this.gameManager});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.green;

    // Center the triangle on the screen
    double triangleX = size.width / 2;
    double triangleY = size.height / 2;
    gameManager.triangle.x = triangleX;
    gameManager.triangle.y = triangleY;

    // Find the closest sphere and rotate the triangle towards it
    if (gameManager.spheres.isNotEmpty) {
      Sphere closestSphere = gameManager.spheres[0];
      double minDistance = double.infinity;

      // Find the nearest sphere
      for (var sphere in gameManager.spheres) {
        double distance =
            (triangleX - sphere.x).abs() + (triangleY - sphere.y).abs();
        if (distance < minDistance) {
          minDistance = distance;
          closestSphere = sphere;
        }
      }

      // Rotate the triangle to face the closest sphere
      gameManager.triangle.rotateTowards(closestSphere.x, closestSphere.y);

      List<double> offsets = gameManager.triangle
          .calculateLineOffsets(closestSphere.x, closestSphere.y, 50.0);
      canvas.drawLine(Offset(offsets[0], offsets[1]),
          Offset(offsets[2], offsets[3]), paint);
    }

    // Draw the triangle
    canvas.save();
    canvas.translate(triangleX, triangleY);
    canvas.rotate(gameManager.triangle.rotation);

    // Draw the triangle with top corner facing the sphere
    canvas.drawPath(
      Path()
        ..moveTo(0, -20) // Top of the triangle (this is the top corner)
        ..lineTo(20, 20) // Right of the triangle
        ..lineTo(-20, 20) // Left of the triangle
        ..close(),
      paint,
    );
    canvas.restore();

    // Draw the spheres
    for (var sphere in gameManager.spheres) {
      paint.color = sphere.color;
      canvas.drawCircle(Offset(sphere.x, sphere.y), sphere.size / 2, paint);
    }

    // Draw the bullets fired by the triangle
    for (var bullet in gameManager.triangle.bullets) {
      bullet.move(); // Move the bullet based on its angle and speed
      paint.color = Colors.red; // Bullet color
      canvas.drawCircle(Offset(bullet.x, bullet.y), bullet.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
