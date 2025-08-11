import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class GameScoreWidget extends StatelessWidget {
  final int score;
  final VoidCallback onTap;

  const GameScoreWidget({
    Key? key,
    required this.score,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 6.h,
      left: 4.w,
      right: 4.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.h,
          ),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
            border: Border.all(
              color: AppTheme.gridLinesColor,
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SCORE',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.textMediumEmphasisLight,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                _formatScore(score),
                style: AppTheme.getDataTextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.snakeBodyColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatScore(int score) {
    if (score >= 1000000) {
      return '${(score / 1000000).toStringAsFixed(1)}M';
    } else if (score >= 1000) {
      return '${(score / 1000).toStringAsFixed(score % 1000 == 0 ? 0 : 1)}K';
    }
    return score.toString();
  }
}
