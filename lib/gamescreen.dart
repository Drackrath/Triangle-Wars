// gamescreen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gamemanager.dart';
import 'triangle.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameManager _gameManager;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager(triangle: Triangle(x: 200, y: 400));
    _loadProgress();
  }

  // Load game progress when the screen starts
  void _loadProgress() async {
    await _gameManager.loadProgress();
    setState(() {});
  }

  // Upgrade buttons
  void _upgradeSpeed() {
    setState(() {
      _gameManager.triangle.upgradeSpeed(1.0);
    });
  }

  void _upgradeAttackPower() {
    setState(() {
      _gameManager.triangle.upgradeAttackPower(1.0);
    });
  }

  void _upgradeHealth() {
    setState(() {
      _gameManager.triangle.upgradeHealth(10.0);
    });
  }

  // Upgrade panel with buttons
  Widget _buildUpgradePanel() {
    return Column(
      children: [
        ElevatedButton(onPressed: _upgradeSpeed, child: Text('Upgrade Speed')),
        ElevatedButton(
            onPressed: _upgradeAttackPower,
            child: Text('Upgrade Attack Power')),
        ElevatedButton(
            onPressed: _upgradeHealth, child: Text('Upgrade Health')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Idle Triangle Game")),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _gameManager.triangle
                .move(details.localPosition.dx, details.localPosition.dy);
          });
        },
        child: Column(
          children: [
            CustomPaint(
              size: Size(double.infinity, 500),
              painter: GamePainter(gameManager: _gameManager),
            ),
            _buildUpgradePanel(),
          ],
        ),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final GameManager gameManager;

  GamePainter({required this.gameManager});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Colors.green;
    // Draw the triangle
    canvas.drawPath(
      Path()
        ..moveTo(gameManager.triangle.x, gameManager.triangle.y)
        ..lineTo(gameManager.triangle.x + 20, gameManager.triangle.y + 30)
        ..lineTo(gameManager.triangle.x - 20, gameManager.triangle.y + 30)
        ..close(),
      paint,
    );

    // Draw the spheres
    for (var sphere in gameManager.spheres) {
      paint.color = sphere.color;
      canvas.drawCircle(Offset(sphere.x, sphere.y), sphere.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
