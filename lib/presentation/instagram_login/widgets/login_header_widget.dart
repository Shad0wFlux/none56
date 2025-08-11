import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Column(
        children: [
          // Instagram Logo
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFF58529),
                  Color(0xFFDD2A7B),
                  Color(0xFF8134AF),
                  Color(0xFF515BD4),
                ],
              ),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.white,
                size: 8.w,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          // Instagram Text
          Text(
            'Instagram',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.5,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Sign in to your account',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
