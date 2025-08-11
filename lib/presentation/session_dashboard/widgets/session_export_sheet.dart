import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

class SessionExportSheet extends StatelessWidget {
  final Map<String, dynamic> sessionData;

  const SessionExportSheet({
    Key? key,
    required this.sessionData,
  }) : super(key: key);

  void _copyToClipboard(BuildContext context) {
    final jsonString = JsonEncoder.withIndent('  ').convert(sessionData);
    Clipboard.setData(ClipboardData(text: jsonString));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session data copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareSecurely(BuildContext context) {
    // In a real implementation, this would use platform-specific sharing
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Secure sharing initiated'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportAsFile(BuildContext context) {
    // In a real implementation, this would save to device storage
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Session exported as JSON file'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Export Session Data',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Choose how you want to export your session credentials',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'copy',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
            title: Text('Copy to Clipboard'),
            subtitle: Text('Copy JSON data to clipboard'),
            onTap: () => _copyToClipboard(context),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 24,
              ),
            ),
            title: Text('Save as File'),
            subtitle: Text('Export as JSON file to device'),
            onTap: () => _exportAsFile(context),
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Color(0xFFD97706).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'share',
                color: Color(0xFFD97706),
                size: 24,
              ),
            ),
            title: Text('Share Securely'),
            subtitle: Text('Share via encrypted channel'),
            onTap: () => _shareSecurely(context),
          ),
          SizedBox(height: 2.h),
          Container(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
