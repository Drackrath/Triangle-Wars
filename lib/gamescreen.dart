import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For Ticker
import 'package:triangle_wars/gamepainter.dart';
import 'gamemanager.dart';
import 'triangle.dart';
import 'upgradepanel.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late GameManager _gameManager;
  double _lastTime = 0.0;
  late Ticker _ticker;

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
      _gameManager.resetGame();
    });
    _ticker.start();
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomPaint(
              size: const Size(double.infinity, 500),
              painter: GamePainter(gameManager: _gameManager),
            ),
            UpgradePanel(
              gameManager: _gameManager,
              onStartNewRound: _startNewRound,
            ),
          ],
        ),
      ),
    );
  }
}
