import 'package:flutter/material.dart';
import '../presentation/game_screen/game_screen.dart';
import '../presentation/main_menu_screen/main_menu_screen.dart';
import '../presentation/game_over_screen/game_over_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String game = '/game-screen';
  static const String mainMenu = '/main-menu-screen';
  static const String gameOver = '/game-over-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const GameScreen(),
    game: (context) => const GameScreen(),
    mainMenu: (context) => const MainMenuScreen(),
    gameOver: (context) => const GameOverScreen(),
    // TODO: Add your other routes here
  };
}
