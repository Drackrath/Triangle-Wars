// gamescreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For Ticker
import 'package:triangle_wars/gamepainter.dart';
import 'gamemanager.dart';
import 'triangle.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late GameManager _gameManager;
  double _lastTime = 0.0;
  late Ticker _ticker;
  bool _isGameRunning = false;

  @override
  void initState() {
    super.initState();
    _gameManager = GameManager(triangle: Triangle(x: 200, y: 400));
    _loadProgress();
    _ticker = Ticker(_onTick);
  }

  void _loadProgress() async {
    await _gameManager.loadProgress();
    setState(() {});
  }

  void _onTick(Duration elapsed) {
    double currentTime = elapsed.inMilliseconds / 1000.0; // Convert to seconds
    double deltaTime =
        (currentTime - _lastTime) * 100 * 2; // Time passed since last tick
    _lastTime = currentTime; // Update last time
    setState(() {
      _gameManager.update(deltaTime);
    });
  }

  void _startNewRound() {
    setState(() {
      _gameManager.startNewRound();
    });
    _ticker.start();
  }

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

  Widget _buildUpgradePanel() {
    return Column(
      children: [
        ElevatedButton(
            onPressed: _upgradeSpeed, child: const Text('Upgrade Speed')),
        ElevatedButton(
            onPressed: _upgradeAttackPower,
            child: const Text('Upgrade Attack Power')),
        ElevatedButton(
            onPressed: _upgradeHealth, child: const Text('Upgrade Health')),
        ElevatedButton(
            onPressed: _startNewRound, child: const Text('Start New Round')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Idle Triangle Game")),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _gameManager.triangle
                .move(details.localPosition.dx, details.localPosition.dy);
          });
        },
        onTap: () {
          setState(() {
            _gameManager.triangle.shoot(); // Shoot when screen is tapped
          });
        },
        child: Column(
          children: [
            CustomPaint(
              size: const Size(double.infinity, 500),
              painter: GamePainter(gameManager: _gameManager),
            ),
            _buildUpgradePanel(),
          ],
        ),
      ),
    );
  }
}
