import 'package:flutter/material.dart';
import '../presentation/session_dashboard/session_dashboard.dart';
import '../presentation/two_factor_challenge/two_factor_challenge.dart';
import '../presentation/instagram_login/instagram_login.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String sessionDashboard = '/session-dashboard';
  static const String twoFactorChallenge = '/two-factor-challenge';
  static const String instagramLogin = '/instagram-login';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const InstagramLogin(),
    sessionDashboard: (context) => const SessionDashboard(),
    twoFactorChallenge: (context) => const TwoFactorChallenge(),
    instagramLogin: (context) => const InstagramLogin(),
    // TODO: Add your other routes here
  };
}
