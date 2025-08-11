import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class GameOverCardWidget extends StatelessWidget {
  final int currentScore;
  final int highScore;
  final bool isNewHighScore;
  final VoidCallback onPlayAgain;
  final VoidCallback onHighScores;
  final VoidCallback onMainMenu;

  const GameOverCardWidget({
    Key? key,
    required this.currentScore,
    required this.highScore,
    required this.isNewHighScore,
    required this.onPlayAgain,
    required this.onHighScores,
    required this.onMainMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      constraints: BoxConstraints(
        maxWidth: 400,
        minHeight: 50.h,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.gridLinesColor,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Game Over Title
            Text(
              'GAME OVER',
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                color: AppTheme.foodElementColor,
                letterSpacing: 2.0,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 3.h),

            // Current Score Display
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.gridLinesColor,
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'SCORE',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    currentScore.toString().padLeft(6, '0'),
                    style: AppTheme.getDataTextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.snakeBodyColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // High Score Status
            isNewHighScore
                ? _buildNewHighScoreWidget()
                : _buildCurrentRankingWidget(),

            SizedBox(height: 4.h),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewHighScoreWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      decoration: BoxDecoration(
        color: AppTheme.successStateColor.withValues(alpha: 0.1),
        border: Border.all(
          color: AppTheme.successStateColor,
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'star',
            color: AppTheme.successStateColor,
            size: 20.sp,
          ),
          SizedBox(height: 0.5.h),
          Text(
            'NEW HIGH SCORE!',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.successStateColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentRankingWidget() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        children: [
          Text(
            'HIGH SCORE',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            highScore.toString().padLeft(6, '0'),
            style: AppTheme.getDataTextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: AppTheme.textHighEmphasisLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Play Again Button (Primary Action)
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: ElevatedButton(
            onPressed: onPlayAgain,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.snakeBodyColor,
              foregroundColor: AppTheme.primaryGameBackground,
              elevation: 0.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'refresh',
                  color: AppTheme.primaryGameBackground,
                  size: 18.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'PLAY AGAIN',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryGameBackground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // High Scores Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: OutlinedButton(
            onPressed: onHighScores,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.uiPrimaryColor,
              side: const BorderSide(
                color: AppTheme.uiPrimaryColor,
                width: 1.0,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'leaderboard',
                  color: AppTheme.uiPrimaryColor,
                  size: 18.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'HIGH SCORES',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.uiPrimaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 2.h),

        // Main Menu Button
        SizedBox(
          width: double.infinity,
          height: 6.h,
          child: TextButton(
            onPressed: onMainMenu,
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.accentHighlightColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'home',
                  color: AppTheme.accentHighlightColor,
                  size: 18.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  'MAIN MENU',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.accentHighlightColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
