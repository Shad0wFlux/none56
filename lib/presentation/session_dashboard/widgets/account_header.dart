import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class AccountHeader extends StatelessWidget {
  final String username;
  final String profileImageUrl;
  final bool isConnected;
  final DateTime lastVerified;

  const AccountHeader({
    Key? key,
    required this.username,
    required this.profileImageUrl,
    required this.isConnected,
    required this.lastVerified,
  }) : super(key: key);

  String get _connectionStatus {
    if (isConnected) return 'Connected';
    final now = DateTime.now();
    final difference = now.difference(lastVerified);

    if (difference.inMinutes < 60) {
      return 'Last verified ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Last verified ${difference.inHours}h ago';
    } else {
      return 'Last verified ${difference.inDays}d ago';
    }
  }

  Color get _statusColor {
    if (isConnected) return AppTheme.lightTheme.colorScheme.tertiary;

    final now = DateTime.now();
    final difference = now.difference(lastVerified);

    if (difference.inHours < 1) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (difference.inHours < 24) {
      return Color(0xFFD97706); // Warning color
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _statusColor,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: profileImageUrl,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '@$username',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 2.w,
                      height: 2.w,
                      decoration: BoxDecoration(
                        color: _statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  _connectionStatus,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: isConnected ? 'check_circle' : 'warning',
            color: _statusColor,
            size: 24,
          ),
        ],
      ),
    );
  }
}
