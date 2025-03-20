import 'package:flutter/material.dart';
import 'game_settings.dart';

class GameCell extends StatelessWidget {
  final int? value;
  final bool isActive;
  final Function(int)? onDrop;
  final VoidCallback? onTap;
  final bool canAcceptDrop;
  final int? currentNumber;

  const GameCell({
    super.key,
    this.value,
    this.isActive = false,
    this.onDrop,
    this.onTap,
    this.canAcceptDrop = true,
    this.currentNumber,
  });

  Color _getCellColor() {
    if (value == null) {
      return Colors.grey.shade100;
    }
    final hue = (value! * 25) % 360;
    return HSLColor.fromAHSL(1, hue.toDouble(), 0.6, 0.9).toColor();
  }

  @override
  Widget build(BuildContext context) {
    Widget cellContent = Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _getCellColor(),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: value != null
            ? FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : null,
      ),
    );

    if (GameSettings.gameMode == GameMode.dragAndDrop) {
      return DragTarget<int>(
        onWillAccept: (data) => canAcceptDrop && value == null && onDrop != null,
        onAccept: (data) {
          if (onDrop != null) {
            onDrop!(data);
          }
        },
        builder: (context, candidateData, rejectedData) => cellContent,
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            cellContent,
            if (value == null && currentNumber != null && onTap != null)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }
} 