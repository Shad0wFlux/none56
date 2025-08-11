import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/celebration_animation_widget.dart';
import './widgets/game_over_card_widget.dart';

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  int _currentScore = 0;
  int _highScore = 0;
  bool _isNewHighScore = false;
  bool _isLoading = true;
  bool _showCelebration = false;
  bool _isSavingScore = false;

  @override
  void initState() {
    super.initState();
    _initializeGameOverData();
  }

  Future<void> _initializeGameOverData() async {
    try {
      // Get current score from navigation arguments or default to 0
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _currentScore = args?['score'] ?? 0;

      // Load high score from SharedPreferences
      await _loadHighScore();

      // Check if current score is a new high score
      _checkNewHighScore();

      // Save current score if it's a new high score
      if (_isNewHighScore) {
        await _saveNewHighScore();
        _triggerCelebration();
      }

      setState(() {
        _isLoading = false;
      });

      // Trigger haptic feedback for game over
      _triggerHapticFeedback();
    } catch (e) {
      // Handle error gracefully
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _highScore = prefs.getInt('snake_high_score') ?? 0;
    } catch (e) {
      _highScore = 0;
    }
  }

  void _checkNewHighScore() {
    _isNewHighScore = _currentScore > _highScore;
    if (_isNewHighScore) {
      _highScore = _currentScore;
    }
  }

  Future<void> _saveNewHighScore() async {
    try {
      setState(() {
        _isSavingScore = true;
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('snake_high_score', _currentScore);

      // Save score with timestamp for potential leaderboard
      final scoreHistory = prefs.getStringList('snake_score_history') ?? [];
      final scoreEntry =
          '${_currentScore}|${DateTime.now().millisecondsSinceEpoch}';
      scoreHistory.add(scoreEntry);

      // Keep only last 10 scores
      if (scoreHistory.length > 10) {
        scoreHistory.removeAt(0);
      }

      await prefs.setStringList('snake_score_history', scoreHistory);
    } catch (e) {
      // Handle save error silently
    } finally {
      setState(() {
        _isSavingScore = false;
      });
    }
  }

  void _triggerCelebration() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _showCelebration = true;
        });
      }
    });
  }

  void _triggerHapticFeedback() {
    try {
      if (_isNewHighScore) {
        HapticFeedback.heavyImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Handle haptic feedback error silently
    }
  }

  void _onCelebrationComplete() {
    setState(() {
      _showCelebration = false;
    });
  }

  void _onPlayAgain() {
    if (_isSavingScore) return;

    HapticFeedback.selectionClick();
    Navigator.pushReplacementNamed(context, '/game-screen');
  }

  void _onHighScores() {
    if (_isSavingScore) return;

    HapticFeedback.selectionClick();
    // Navigate to high scores screen or show dialog
    _showHighScoresDialog();
  }

  void _onMainMenu() {
    if (_isSavingScore) return;

    HapticFeedback.selectionClick();
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main-menu-screen',
      (route) => false,
    );
  }

  void _showHighScoresDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          child: Container(
            width: 80.w,
            constraints: BoxConstraints(maxHeight: 60.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.gridLinesColor,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'HIGH SCORES',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.snakeBodyColor,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 3.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppTheme.gridLinesColor,
                      width: 1.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'BEST SCORE',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        _highScore.toString().padLeft(6, '0'),
                        style: AppTheme.getDataTextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.snakeBodyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),
                SizedBox(
                  width: double.infinity,
                  height: 5.h,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.accentHighlightColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    child: Text(
                      'CLOSE',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentHighlightColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onBackgroundTap() {
    if (_isSavingScore) return;
    _onMainMenu();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isSavingScore) return false;
        _onMainMenu();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryGameBackground,
        body: _isLoading ? _buildLoadingState() : _buildGameOverContent(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 8.w,
            height: 8.w,
            child: CircularProgressIndicator(
              color: AppTheme.snakeBodyColor,
              strokeWidth: 2.0,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'SAVING SCORE...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameOverContent() {
    return GestureDetector(
      onTap: _onBackgroundTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppTheme.primaryGameBackground.withValues(alpha: 0.9),
        child: SafeArea(
          child: Stack(
            children: [
              // Game board background pattern (optional visual enhancement)
              _buildBackgroundPattern(),

              // Main game over content
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Game Over Card
                      GameOverCardWidget(
                        currentScore: _currentScore,
                        highScore: _highScore,
                        isNewHighScore: _isNewHighScore,
                        onPlayAgain: _onPlayAgain,
                        onHighScores: _onHighScores,
                        onMainMenu: _onMainMenu,
                      ),
                    ],
                  ),
                ),
              ),

              // Celebration Animation Overlay
              if (_showCelebration)
                Center(
                  child: CelebrationAnimationWidget(
                    isVisible: _showCelebration,
                    onAnimationComplete: _onCelebrationComplete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _GameBackgroundPainter(),
      ),
    );
  }
}

class _GameBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.gridLinesColor.withValues(alpha: 0.1)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const gridSize = 20.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
