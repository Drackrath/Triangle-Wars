// gamepainter.dart
import 'package:flutter/material.dart';
import 'gamemanager.dart';
import 'sphere.dart';

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
    }

    // Draw the triangle
    canvas.save();
    canvas.translate(triangleX, triangleY);
    canvas.rotate(gameManager.triangle.rotation);

    // Draw the triangle with top corner facing the sphere
    canvas.drawPath(
      Path()
        ..moveTo(0, -25) // Top of the triangle (this is the top corner)
        ..lineTo(15, 15) // Right of the triangle
        ..lineTo(-15, 15) // Left of the triangle
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
      paint.color = Colors.red; // Bullet color
      canvas.drawCircle(Offset(bullet.x, bullet.y), bullet.size / 2, paint);
    }

    // Draw a translucent circle around the triangle
    paint
      ..color = Colors.green.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0; // Set the thickness of the border
    canvas.drawCircle(
      Offset(triangleX,
          triangleY), // Center of the circle (same as the triangle's center)
      gameManager.triangle.range, // Radius of the circle
      paint,
    );

    // Draw the health bar
    _drawHealthBar(canvas, size);
  }

  void _drawHealthBar(Canvas canvas, Size size) {
    final healthBarWidth = 200.0;
    final healthBarHeight = 20.0;
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.fill;

    final healthPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    // Bar position
    final double barX = 20.0;
    final double barY = 20.0;

    // Draw the background bar
    canvas.drawRect(Rect.fromLTWH(barX, barY, healthBarWidth, healthBarHeight),
        backgroundPaint);

    // Calculate the health ratio
    double healthRatio =
        (gameManager.triangle.currentHealth / gameManager.triangle.maxHealth)
            .clamp(0.0, 1.0);

    // Draw the current health bar
    canvas.drawRect(
        Rect.fromLTWH(
            barX, barY, healthBarWidth * healthRatio, healthBarHeight),
        healthPaint);

    // Draw the border
    canvas.drawRect(Rect.fromLTWH(barX, barY, healthBarWidth, healthBarHeight),
        borderPaint);

    // Draw the health text
    final textPainter = TextPainter(
      text: TextSpan(
        text:
            '${gameManager.triangle.currentHealth.toInt()} / ${gameManager.triangle.maxHealth.toInt()}',
        style: TextStyle(color: Colors.black, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(barX + (healthBarWidth / 2) - (textPainter.width / 2),
            barY + (healthBarHeight / 2) - (textPainter.height / 2)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
