import 'package:flutter/material.dart';

class DraggableNumber extends StatelessWidget {
  final int number;
  final VoidCallback? onDragStarted;
  final VoidCallback? onDragEnd;

  const DraggableNumber({
    super.key,
    required this.number,
    this.onDragStarted,
    this.onDragEnd,
  });

  Color _getBackgroundColor() {
    switch (number) {
      case 2: return const Color(0xFFEEE4DA);
      case 3: return const Color(0xFFEDE0C8);
      case 4: return const Color(0xFFF2B179);
      case 5: return const Color(0xFFF59563);
      case 6: return const Color(0xFFF67C5F);
      case 7: return const Color(0xFFF65E3B);
      case 8: return const Color(0xFFEDCF72);
      case 9: return const Color(0xFFEDCC61);
      case 10: return const Color(0xFFEDC850);
      case 11: return const Color(0xFFEDC53F);
      case 12: return const Color(0xFFEDC22E);
      default:
        if (number > 12) return const Color(0xFF3C3A32);
        return const Color(0xFFCDC1B4);
    }
  }

  Color _getTextColor() {
    if (number <= 4) return const Color(0xFF776E65);
    return Colors.white;
  }

  Widget _buildTile() {
    return Container(
      width: 72,
      height: 72,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
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
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            number.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _getTextColor(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: number,
      onDragStarted: onDragStarted,
      onDragEnd: (_) {
        if (onDragEnd != null) {
          onDragEnd!();
        }
      },
      feedback: _buildTile(),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildTile(),
      ),
      child: _buildTile(),
    );
  }
} 