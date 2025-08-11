import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ResendCodeWidget extends StatefulWidget {
  final VoidCallback onResend;
  final bool isLoading;

  const ResendCodeWidget({
    Key? key,
    required this.onResend,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ResendCodeWidget> createState() => _ResendCodeWidgetState();
}

class _ResendCodeWidgetState extends State<ResendCodeWidget>
    with TickerProviderStateMixin {
  int _countdown = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _countdown = 60;
    });

    _animationController.repeat();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _countdown--;
        });
        if (_countdown <= 0) {
          _animationController.stop();
          return false;
        }
        return true;
      }
      return false;
    });
  }

  void _handleResend() {
    if (_countdown == 0 && !widget.isLoading) {
      widget.onResend();
      _startCountdown();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _countdown == 0 && !widget.isLoading;

    return Column(
      children: [
        Text(
          "Didn't receive the code?",
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: _handleResend,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: canResend
                  ? AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: canResend
                  ? Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                    )
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isLoading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                ] else if (_countdown > 0) ...[
                  RotationTransition(
                    turns: _animationController,
                    child: CustomIconWidget(
                      iconName: 'refresh',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 2.w),
                ] else ...[
                  CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                ],
                Text(
                  _countdown > 0
                      ? 'Resend in ${_countdown}s'
                      : widget.isLoading
                          ? 'Sending...'
                          : 'Resend Code',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: canResend
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontWeight: canResend ? FontWeight.w600 : FontWeight.w400,
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
