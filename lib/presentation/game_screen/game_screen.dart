import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/game_board_widget.dart';
import './widgets/game_controls_widget.dart';
import './widgets/game_score_widget.dart';
import './widgets/pause_menu_widget.dart';

enum Direction { up, down, left, right }

enum GameState { playing, paused, gameOver }

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game configuration
  static const int gridSize = 20;
  static const int gameSpeed = 200; // milliseconds

  // Game state variables
  GameState _gameState = GameState.playing;
  Direction _currentDirection = Direction.right;
  Direction _nextDirection = Direction.right;
  List<Offset> _snakePositions = [];
  Offset _foodPosition = const Offset(0, 0);
  int _score = 0;
  Timer? _gameTimer;
  bool _showControls = false;

  // Game board data
  List<List<int>> _gameBoard = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startGameLoop();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    // Initialize game board
    _gameBoard = List.generate(
      gridSize,
      (index) => List.generate(gridSize, (index) => 0),
    );

    // Initialize snake at center
    _snakePositions = [
      Offset(gridSize / 2, gridSize / 2),
      Offset(gridSize / 2 - 1, gridSize / 2),
      Offset(gridSize / 2 - 2, gridSize / 2),
    ];

    // Place initial food
    _generateFood();

    // Reset game state
    _currentDirection = Direction.right;
    _nextDirection = Direction.right;
    _score = 0;
    _gameState = GameState.playing;
  }

  void _startGameLoop() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(
      const Duration(milliseconds: gameSpeed),
      (timer) {
        if (_gameState == GameState.playing) {
          _updateGame();
        }
      },
    );
  }

  void _updateGame() {
    setState(() {
      // Update direction
      _currentDirection = _nextDirection;

      // Calculate new head position
      Offset newHead = _snakePositions.first;
      switch (_currentDirection) {
        case Direction.up:
          newHead = Offset(newHead.dx, newHead.dy - 1);
          break;
        case Direction.down:
          newHead = Offset(newHead.dx, newHead.dy + 1);
          break;
        case Direction.left:
          newHead = Offset(newHead.dx - 1, newHead.dy);
          break;
        case Direction.right:
          newHead = Offset(newHead.dx + 1, newHead.dy);
          break;
      }

      // Check wall collision
      if (newHead.dx < 0 ||
          newHead.dx >= gridSize ||
          newHead.dy < 0 ||
          newHead.dy >= gridSize) {
        _gameOver();
        return;
      }

      // Check self collision
      if (_snakePositions.contains(newHead)) {
        _gameOver();
        return;
      }

      // Add new head
      _snakePositions.insert(0, newHead);

      // Check food collision
      if (newHead == _foodPosition) {
        _score += 10;
        _generateFood();
        // Provide haptic feedback
        HapticFeedback.lightImpact();
      } else {
        // Remove tail if no food eaten
        _snakePositions.removeLast();
      }
    });
  }

  void _generateFood() {
    final random = Random();
    Offset newFoodPosition;

    do {
      newFoodPosition = Offset(
        random.nextInt(gridSize).toDouble(),
        random.nextInt(gridSize).toDouble(),
      );
    } while (_snakePositions.contains(newFoodPosition));

    _foodPosition = newFoodPosition;
  }

  void _gameOver() {
    setState(() {
      _gameState = GameState.gameOver;
    });
    _gameTimer?.cancel();

    // Navigate to game over screen after a short delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/game-over-screen');
      }
    });
  }

  void _changeDirection(Direction newDirection) {
    // Prevent reverse direction
    if ((_currentDirection == Direction.up && newDirection == Direction.down) ||
        (_currentDirection == Direction.down && newDirection == Direction.up) ||
        (_currentDirection == Direction.left &&
            newDirection == Direction.right) ||
        (_currentDirection == Direction.right &&
            newDirection == Direction.left)) {
      return;
    }

    setState(() {
      _nextDirection = newDirection;
    });

    // Provide haptic feedback
    HapticFeedback.selectionClick();
  }

  void _pauseGame() {
    setState(() {
      _gameState =
          _gameState == GameState.paused ? GameState.playing : GameState.paused;
    });
  }

  void _resumeGame() {
    setState(() {
      _gameState = GameState.playing;
    });
  }

  void _restartGame() {
    _gameTimer?.cancel();
    _initializeGame();
    _startGameLoop();
  }

  void _goToMainMenu() {
    _gameTimer?.cancel();
    Navigator.pushReplacementNamed(context, '/main-menu-screen');
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryGameBackground,
      body: SafeArea(
        child: GestureDetector(
          onPanUpdate: (details) {
            // Handle swipe gestures
            if (details.delta.dx.abs() > details.delta.dy.abs()) {
              // Horizontal swipe
              if (details.delta.dx > 0) {
                _changeDirection(Direction.right);
              } else {
                _changeDirection(Direction.left);
              }
            } else {
              // Vertical swipe
              if (details.delta.dy > 0) {
                _changeDirection(Direction.down);
              } else {
                _changeDirection(Direction.up);
              }
            }
          },
          onDoubleTap: _toggleControls,
          child: Stack(
            children: [
              // Game board
              Center(
                child: GameBoardWidget(
                  gameBoard: _gameBoard,
                  snakePositions: _snakePositions,
                  foodPosition: _foodPosition,
                  gridSize: gridSize,
                ),
              ),

              // Score display
              GameScoreWidget(
                score: _score,
                onTap: _pauseGame,
              ),

              // Game controls (optional)
              GameControlsWidget(
                onUpPressed: () => _changeDirection(Direction.up),
                onDownPressed: () => _changeDirection(Direction.down),
                onLeftPressed: () => _changeDirection(Direction.left),
                onRightPressed: () => _changeDirection(Direction.right),
                isVisible: _showControls,
              ),

              // Pause menu
              PauseMenuWidget(
                onResume: _resumeGame,
                onRestart: _restartGame,
                onMainMenu: _goToMainMenu,
                isVisible: _gameState == GameState.paused,
              ),

              // Control toggle hint
              if (!_showControls)
                Positioned(
                  bottom: 4.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.7),
                        border: Border.all(
                          color: AppTheme.gridLinesColor,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        'Double tap to show controls',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textMediumEmphasisLight,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ),

              // Game over overlay
              if (_gameState == GameState.gameOver)
                Positioned.fill(
                  child: Container(
                    color:
                        AppTheme.primaryGameBackground.withValues(alpha: 0.9),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GAME OVER',
                            style: AppTheme.lightTheme.textTheme.headlineMedium
                                ?.copyWith(
                              color: AppTheme.errorStateColor,
                              fontSize: 24.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Final Score: ${_formatScore(_score)}',
                            style: AppTheme.getDataTextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.uiPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
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
