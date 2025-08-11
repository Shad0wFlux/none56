import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class PauseMenuWidget extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onMainMenu;
  final bool isVisible;

  const PauseMenuWidget({
    Key? key,
    required this.onResume,
    required this.onRestart,
    required this.onMainMenu,
    this.isVisible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isVisible
        ? Positioned.fill(
            child: Container(
              color: AppTheme.primaryGameBackground.withValues(alpha: 0.8),
              child: Center(
                child: Container(
                  width: 80.w,
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    border: Border.all(
                      color: AppTheme.gridLinesColor,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'GAME PAUSED',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          color: AppTheme.uiPrimaryColor,
                          fontSize: 18.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      _buildMenuButton(
                        text: 'RESUME',
                        onPressed: onResume,
                        isPrimary: true,
                      ),
                      SizedBox(height: 2.h),
                      _buildMenuButton(
                        text: 'RESTART',
                        onPressed: onRestart,
                      ),
                      SizedBox(height: 2.h),
                      _buildMenuButton(
                        text: 'MAIN MENU',
                        onPressed: onMainMenu,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: isPrimary
          ? ElevatedButton(
              onPressed: onPressed,
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.primaryGameBackground,
                  fontSize: 14.sp,
                ),
              ),
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: AppTheme.lightTheme.outlinedButtonTheme.style,
              child: Text(
                text,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.uiPrimaryColor,
                  fontSize: 14.sp,
                ),
              ),
            ),
    );
  }
}
