import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/resend_code_widget.dart';
import './widgets/security_code_input.dart';
import './widgets/verification_method_card.dart';

class TwoFactorChallenge extends StatefulWidget {
  const TwoFactorChallenge({Key? key}) : super(key: key);

  @override
  State<TwoFactorChallenge> createState() => _TwoFactorChallengeState();
}

class _TwoFactorChallengeState extends State<TwoFactorChallenge>
    with TickerProviderStateMixin {
  String _securityCode = '';
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;
  String _selectedMethod = 'SMS';
  bool _isResendLoading = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  // Mock verification methods data
  final List<Map<String, dynamic>> _verificationMethods = [
    {
      "method": "SMS",
      "contactInfo": "••• ••• •• 89",
      "isAvailable": true,
    },
    {
      "method": "Email",
      "contactInfo": "j••••@gmail.com",
      "isAvailable": true,
    },
  ];

  // Mock credentials for testing
  final Map<String, String> _mockCredentials = {
    "validCode": "123456",
    "expiredCode": "000000",
    "invalidCode": "999999",
  };

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onCodeChanged(String code) {
    setState(() {
      _securityCode = code;
      _hasError = false;
      _errorMessage = null;
    });
  }

  void _onCodeCompleted(String code) {
    if (!_isLoading) {
      _verifyCode(code);
    }
  }

  Future<void> _verifyCode(String code) async {
    if (code.length != 6) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Mock verification logic
    if (code == _mockCredentials["validCode"]) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to session dashboard
      Navigator.pushReplacementNamed(context, '/session-dashboard');
    } else if (code == _mockCredentials["expiredCode"]) {
      _showError("Verification code has expired. Please request a new one.");
    } else if (code == _mockCredentials["invalidCode"]) {
      _showError("Too many failed attempts. Please try again later.");
    } else {
      _showError("Invalid verification code. Please try again.");
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showError(String message) {
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });

    // Trigger shake animation
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    // Trigger error haptic feedback
    HapticFeedback.heavyImpact();
  }

  Future<void> _resendCode() async {
    setState(() {
      _isResendLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isResendLoading = false;
      });

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification code sent to ${_selectedMethod.toLowerCase() == 'sms' ? 'your phone' : 'your email'}',
            style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }

  void _switchVerificationMethod(String method) {
    if (method != _selectedMethod) {
      setState(() {
        _selectedMethod = method;
        _hasError = false;
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, '/instagram-login'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'security',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'Verification Required',
              style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(6.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.lightTheme.primaryColor,
                            AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'verified_user',
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Instagram 2FA',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Enter the 6-digit verification code sent to your selected method',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 4.h),

              // Verification method selection
              Text(
                'Choose verification method:',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),

              ...(_verificationMethods
                  .where((method) => method["isAvailable"] as bool)
                  .map((method) {
                final methodName = method["method"] as String;
                final contactInfo = method["contactInfo"] as String;

                return VerificationMethodCard(
                  method: methodName,
                  contactInfo: contactInfo,
                  isSelected: _selectedMethod == methodName,
                  onTap: () => _switchVerificationMethod(methodName),
                );
              }).toList()),

              SizedBox(height: 4.h),

              // Security code input
              Text(
                'Enter verification code:',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),

              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: SecurityCodeInput(
                      onCodeChanged: _onCodeChanged,
                      onCodeCompleted: _onCodeCompleted,
                      hasError: _hasError,
                      errorMessage: _errorMessage,
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // Resend code widget
              Center(
                child: ResendCodeWidget(
                  onResend: _resendCode,
                  isLoading: _isResendLoading,
                ),
              ),

              SizedBox(height: 6.h),

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _securityCode.length == 6 && !_isLoading
                      ? () => _verifyCode(_securityCode)
                      : null,
                  style:
                      AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.disabled)) {
                        return AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3);
                      }
                      return AppTheme.lightTheme.primaryColor;
                    }),
                  ),
                  child: _isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'Verifying...',
                              style: AppTheme.lightTheme.elevatedButtonTheme
                                  .style?.textStyle
                                  ?.resolve({})?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Verify Code',
                          style: AppTheme
                              .lightTheme.elevatedButtonTheme.style?.textStyle
                              ?.resolve({})?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 3.h),

              // Help text
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'For testing: Use code 123456 for success, 000000 for expired, 999999 for too many attempts',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
