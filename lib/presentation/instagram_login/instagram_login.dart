import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/error_message_widget.dart';
import './widgets/login_button_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/login_header_widget.dart';

class InstagramLogin extends StatefulWidget {
  const InstagramLogin({Key? key}) : super(key: key);

  @override
  State<InstagramLogin> createState() => _InstagramLoginState();
}

class _InstagramLoginState extends State<InstagramLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _username = '';
  String _password = '';

  // Instagram API simulation data
  final Dio _dio = Dio();
  String? _deviceId;
  String? _userAgent;
  String? _csrfToken;

  // Mock Instagram credentials for testing
  final List<Map<String, String>> _mockCredentials = [
    {"username": "demo_user", "password": "demo123", "type": "regular"},
    {"username": "test@instagram.com", "password": "test456", "type": "email"},
    {"username": "social_manager", "password": "manager789", "type": "business"}
  ];

  @override
  void initState() {
    super.initState();
    _generateDeviceFingerprint();
    _generateUserAgent();
    _generateCSRFToken();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _generateDeviceFingerprint() {
    final random = Random();
    final deviceId =
        List.generate(16, (index) => random.nextInt(16).toRadixString(16))
            .join('');
    _deviceId = 'android-$deviceId';
  }

  void _generateUserAgent() {
    final androidVersions = ['10', '11', '12', '13', '14'];
    final devices = ['SM-G991B', 'Pixel 6', 'OnePlus 9', 'SM-A525F'];
    final random = Random();

    final androidVersion =
        androidVersions[random.nextInt(androidVersions.length)];
    final device = devices[random.nextInt(devices.length)];

    _userAgent =
        'Instagram 295.0.0.32.124 Android ($androidVersion/30; 420dpi; 1080x2340; samsung; $device; beyond1; exynos9820; en_US; 458229237)';
  }

  void _generateCSRFToken() {
    final random = Random();
    _csrfToken =
        List.generate(32, (index) => random.nextInt(16).toRadixString(16))
            .join('');
  }

  bool get _isFormValid {
    return _username.isNotEmpty &&
        _password.isNotEmpty &&
        _password.length >= 6;
  }

  void _onUsernameChanged(String value) {
    setState(() {
      _username = value.trim();
      _errorMessage = null;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = value;
      _errorMessage = null;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _dismissError() {
    setState(() {
      _errorMessage = null;
    });
  }

  Future<void> _performLogin() async {
    if (!_isFormValid || _isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();

    try {
      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 1500));

      // Check mock credentials
      final matchingCredential = _mockCredentials.firstWhere(
        (cred) =>
            (cred['username'] == _username ||
                cred['username'] == _username.toLowerCase()) &&
            cred['password'] == _password,
        orElse: () => {},
      );

      if (matchingCredential.isNotEmpty) {
        // Simulate successful login
        await _simulateInstagramAPICall();

        // Check if 2FA is required (simulate 30% chance)
        final random = Random();
        final requires2FA =
            random.nextBool() && random.nextBool(); // ~25% chance

        if (requires2FA) {
          // Navigate to 2FA challenge
          Navigator.pushNamed(context, '/two-factor-challenge');
        } else {
          // Navigate to session dashboard
          Navigator.pushNamed(context, '/session-dashboard');
        }
      } else {
        // Invalid credentials
        setState(() {
          _errorMessage =
              'Sorry, your password was incorrect. Please double-check your password.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _simulateInstagramAPICall() async {
    try {
      final loginData = {
        'username': _username,
        'password': _password,
        'device_id': _deviceId,
        'login_attempt_count': 0,
        'guid': _deviceId,
        'phone_id': _deviceId,
        'adid': '',
        'google_tokens': '[]',
        'login_attempt_user': 0,
        'country_codes': '[{"country_code":"1","source":["default"]}]',
        'jazoest': '22328',
        'source': 'login',
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      };

      // Simulate Instagram API headers
      final headers = {
        'User-Agent': _userAgent,
        'Accept': '*/*',
        'Accept-Language': 'en-US,en;q=0.5',
        'Accept-Encoding': 'gzip, deflate',
        'X-CSRFToken': _csrfToken,
        'X-Instagram-AJAX': '1',
        'X-Requested-With': 'XMLHttpRequest',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Origin': 'https://www.instagram.com',
        'Referer': 'https://www.instagram.com/',
      };

      print('Simulating Instagram login with device ID: $_deviceId');
      print('User Agent: $_userAgent');
      print('Login data prepared for: $_username');
    } catch (e) {
      throw Exception('Network error occurred');
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return 'Network error. Please check your internet connection and try again.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else if (error.toString().contains('rate')) {
      return 'Too many login attempts. Please wait a few minutes before trying again.';
    } else if (error.toString().contains('account')) {
      return 'Account temporarily locked. Please try again later or reset your password.';
    }
    return 'An unexpected error occurred. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 4.h),

                    // Header with Instagram logo and title
                    LoginHeaderWidget(),

                    SizedBox(height: 2.h),

                    // Error message display
                    ErrorMessageWidget(
                      errorMessage: _errorMessage,
                      onDismiss: _dismissError,
                    ),

                    // Login form
                    LoginFormWidget(
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                      isPasswordVisible: _isPasswordVisible,
                      onPasswordVisibilityToggle: _togglePasswordVisibility,
                      onUsernameChanged: _onUsernameChanged,
                      onPasswordChanged: _onPasswordChanged,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 4.h),

                    // Login button
                    LoginButtonWidget(
                      isEnabled: _isFormValid,
                      isLoading: _isLoading,
                      onPressed: _performLogin,
                    ),

                    SizedBox(height: 4.h),

                    // Security notice
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'security',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 5.w,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Secure Authentication',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  'Your credentials are encrypted and processed securely through Instagram\'s official authentication system.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Demo credentials info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3.w),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'info_outline',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 4.w,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Demo Credentials',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Use: demo_user / demo123 or test@instagram.com / test456',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  fontFamily: 'monospace',
                                ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
