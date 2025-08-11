import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with TickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late AnimationController _buttonAnimationController;
  late Animation<double> _titleGlowAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _titleAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _titleGlowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeInOut,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    _titleAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onButtonPressed(VoidCallback onPressed) async {
    await _buttonAnimationController.forward();
    await _buttonAnimationController.reverse();

    // Haptic feedback for better user experience
    HapticFeedback.lightImpact();

    onPressed();
  }

  void _navigateToGameScreen() {
    Navigator.pushNamed(context, '/game-screen');
  }

  void _showHighScores() {
    // For now, show a dialog since high scores screen is not implemented
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            'HIGH SCORES',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.snakeBodyColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildScoreEntry('1ST', '2,450'),
              SizedBox(height: 2.h),
              _buildScoreEntry('2ND', '1,890'),
              SizedBox(height: 2.h),
              _buildScoreEntry('3RD', '1,340'),
              SizedBox(height: 2.h),
              _buildScoreEntry('4TH', '980'),
              SizedBox(height: 2.h),
              _buildScoreEntry('5TH', '750'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CLOSE',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.accentHighlightColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScoreEntry(String position, String score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          position,
          style: AppTheme.getDataTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppTheme.uiPrimaryColor,
          ),
        ),
        Text(
          score,
          style: AppTheme.getDataTextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.snakeBodyColor,
          ),
        ),
      ],
    );
  }

  void _showSettings() {
    // For now, show a dialog since settings screen is not implemented
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            'SETTINGS',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.snakeBodyColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSettingItem('Sound Effects', true),
              SizedBox(height: 2.h),
              _buildSettingItem('Vibration', true),
              SizedBox(height: 2.h),
              _buildSettingItem('Grid Lines', false),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CLOSE',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.accentHighlightColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem(String title, bool isEnabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.uiPrimaryColor,
          ),
        ),
        Switch(
          value: isEnabled,
          onChanged: (value) {
            // Settings functionality would be implemented here
          },
        ),
      ],
    );
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          title: Text(
            'EXIT GAME',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.errorStateColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Are you sure you want to exit Snake Classic?',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.uiPrimaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CANCEL',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.accentHighlightColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: Text(
                'EXIT',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.errorStateColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitConfirmation();
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryGameBackground,
        body: SafeArea(
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: AppTheme.primaryGameBackground,
              image: DecorationImage(
                image: const AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                opacity: 0.05,
                onError: (exception, stackTrace) {
                  // Gracefully handle missing background pattern
                },
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game Title Section
                Expanded(
                  flex: 2,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _titleGlowAnimation,
                      builder: (context, child) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SNAKE',
                                style: AppTheme
                                    .lightTheme.textTheme.displayMedium
                                    ?.copyWith(
                                  color: AppTheme.snakeBodyColor.withValues(
                                    alpha: _titleGlowAnimation.value,
                                  ),
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.snakeBodyColor.withValues(
                                        alpha: _titleGlowAnimation.value * 0.5,
                                      ),
                                      blurRadius: 10.0,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'CLASSIC',
                                style: AppTheme
                                    .lightTheme.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: AppTheme.uiPrimaryColor.withValues(
                                    alpha: _titleGlowAnimation.value,
                                  ),
                                  letterSpacing: 4.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Menu Buttons Section
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Start Game Button
                        AnimatedBuilder(
                          animation: _buttonScaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonScaleAnimation.value,
                              child: _buildMenuButton(
                                text: 'START GAME',
                                onPressed: () =>
                                    _onButtonPressed(_navigateToGameScreen),
                                isPrimary: true,
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 3.h),

                        // High Scores Button
                        _buildMenuButton(
                          text: 'HIGH SCORES',
                          onPressed: () => _onButtonPressed(_showHighScores),
                          isPrimary: false,
                        ),

                        SizedBox(height: 3.h),

                        // Settings Button
                        _buildMenuButton(
                          text: 'SETTINGS',
                          onPressed: () => _onButtonPressed(_showSettings),
                          isPrimary: false,
                        ),
                      ],
                    ),
                  ),
                ),

                // Footer Section
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'v1.0.0',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.inactiveUIColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required String text,
    required VoidCallback onPressed,
    required bool isPrimary,
  }) {
    return Container(
      width: double.infinity,
      height: 6.h,
      constraints: BoxConstraints(
        minHeight: 44.0, // Minimum touch target
        maxHeight: 60.0,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? AppTheme.snakeBodyColor : Colors.transparent,
          foregroundColor: isPrimary
              ? AppTheme.primaryGameBackground
              : AppTheme.uiPrimaryColor,
          side: isPrimary
              ? null
              : const BorderSide(
                  color: AppTheme.uiPrimaryColor,
                  width: 1.0,
                ),
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
            vertical: 2.h,
          ),
        ),
        child: Text(
          text,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            color: isPrimary
                ? AppTheme.primaryGameBackground
                : AppTheme.uiPrimaryColor,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
