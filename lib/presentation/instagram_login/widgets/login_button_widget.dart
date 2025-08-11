import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoginButtonWidget extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback onPressed;

  const LoginButtonWidget({
    Key? key,
    required this.isEnabled,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 12.h,
      child: ElevatedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: Colors.white,
          elevation: isEnabled ? 2 : 0,
          shadowColor: AppTheme.lightTheme.colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.w),
          ),
          padding: EdgeInsets.symmetric(vertical: 4.w),
        ),
        child: isLoading
            ? SizedBox(
                width: 6.w,
                height: 6.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Log In',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
              ),
      ),
    );
  }
}
