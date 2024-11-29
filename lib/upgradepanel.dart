// upgrade_panel.dart
import 'package:flutter/material.dart';
import 'gamemanager.dart';

class UpgradePanel extends StatelessWidget {
  final GameManager gameManager;
  final VoidCallback onStartNewRound;

  const UpgradePanel({
    Key? key,
    required this.gameManager,
    required this.onStartNewRound,
  }) : super(key: key);

  void _upgradeSpeed() {
    gameManager.triangle.upgradeSpeed(1.0);
  }

  void _upgradeAttackPower() {
    gameManager.triangle.upgradeAttackPower(1.0);
  }

  void _upgradeAttackSpeed() {
    gameManager.triangle.upgradeAttackSpeed(1.0);
  }

  void _upgradeHealth() {
    gameManager.triangle.upgradeHealth(10.0);
  }

  void _upgradeRange() {
    gameManager.triangle.upgradeRange(10.0);
  }

  void _upgradeMaxHealth() {
    // gameManager.triangle.upgradeMaxHealth(10.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Upgrades',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
          },
          children: [
            TableRow(children: [
              _buildUpgradeButton(
                label: 'Speed',
                value: gameManager.triangle.velocity.toStringAsFixed(1),
                onUpgrade: _upgradeSpeed,
              ),
              _buildUpgradeButton(
                label: 'Attack Power',
                value: gameManager.triangle.attackPower.toStringAsFixed(1),
                onUpgrade: _upgradeAttackPower,
              ),
            ]),
            TableRow(children: [
              _buildUpgradeButton(
                label: 'Heal',
                value: gameManager.triangle.currentHealth.toStringAsFixed(1),
                onUpgrade: _upgradeHealth,
              ),
              _buildUpgradeButton(
                label: 'Max Health',
                value: gameManager.triangle.maxHealth.toStringAsFixed(1),
                onUpgrade: _upgradeMaxHealth,
              ),
            ]),
            TableRow(children: [
              _buildUpgradeButton(
                label: 'Range',
                value: gameManager.triangle.range.toStringAsFixed(1),
                onUpgrade: _upgradeRange,
              ),
              _buildUpgradeButton(
                label: 'Attack Speed',
                value: gameManager.triangle.attackSpeed.toStringAsFixed(1),
                onUpgrade: _upgradeAttackSpeed,
              ),
            ]),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onStartNewRound,
          child: const Text('Start New Round'),
        ),
      ],
    );
  }

  Widget _buildUpgradeButton({
    required String label,
    required String value,
    required VoidCallback onUpgrade,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onUpgrade,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          '$label $value',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
