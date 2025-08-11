import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GameBoardWidget extends StatelessWidget {
  final List<List<int>> gameBoard;
  final List<Offset> snakePositions;
  final Offset foodPosition;
  final int gridSize;

  const GameBoardWidget({
    Key? key,
    required this.gameBoard,
    required this.snakePositions,
    required this.foodPosition,
    required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.primaryGameBackground,
        border: Border.all(
          color: AppTheme.gridLinesColor,
          width: 2.0,
        ),
      ),
      child: CustomPaint(
        painter: GameBoardPainter(
          snakePositions: snakePositions,
          foodPosition: foodPosition,
          gridSize: gridSize,
        ),
        size: Size(90.w, 60.h),
      ),
    );
  }
}

class GameBoardPainter extends CustomPainter {
  final List<Offset> snakePositions;
  final Offset foodPosition;
  final int gridSize;

  GameBoardPainter({
    required this.snakePositions,
    required this.foodPosition,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double cellWidth = size.width / gridSize;
    final double cellHeight = size.height / gridSize;

    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppTheme.gridLinesColor
      ..strokeWidth = 0.5;

    for (int i = 0; i <= gridSize; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(i * cellWidth, 0),
        Offset(i * cellWidth, size.height),
        gridPaint,
      );
      // Horizontal lines
      canvas.drawLine(
        Offset(0, i * cellHeight),
        Offset(size.width, i * cellHeight),
        gridPaint,
      );
    }

    // Draw snake
    final snakePaint = Paint()
      ..color = AppTheme.snakeBodyColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < snakePositions.length; i++) {
      final position = snakePositions[i];
      final rect = Rect.fromLTWH(
        position.dx * cellWidth + 1,
        position.dy * cellHeight + 1,
        cellWidth - 2,
        cellHeight - 2,
      );

      // Draw snake head slightly different
      if (i == 0) {
        final headPaint = Paint()
          ..color = AppTheme.snakeBodyColor
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, headPaint);

        // Add eyes to snake head
        final eyePaint = Paint()
          ..color = AppTheme.primaryGameBackground
          ..style = PaintingStyle.fill;

        final eyeSize = cellWidth * 0.15;
        canvas.drawCircle(
          Offset(rect.left + cellWidth * 0.3, rect.top + cellHeight * 0.3),
          eyeSize,
          eyePaint,
        );
        canvas.drawCircle(
          Offset(rect.right - cellWidth * 0.3, rect.top + cellHeight * 0.3),
          eyeSize,
          eyePaint,
        );
      } else {
        canvas.drawRect(rect, snakePaint);
      }
    }

    // Draw food with pulsing effect
    final foodPaint = Paint()
      ..color = AppTheme.foodElementColor
      ..style = PaintingStyle.fill;

    final foodRect = Rect.fromLTWH(
      foodPosition.dx * cellWidth + 2,
      foodPosition.dy * cellHeight + 2,
      cellWidth - 4,
      cellHeight - 4,
    );

    canvas.drawOval(foodRect, foodPaint);

    // Add highlight to food
    final highlightPaint = Paint()
      ..color = AppTheme.foodElementColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final highlightRect = Rect.fromLTWH(
      foodPosition.dx * cellWidth + 4,
      foodPosition.dy * cellHeight + 4,
      cellWidth * 0.4,
      cellHeight * 0.4,
    );

    canvas.drawOval(highlightRect, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
