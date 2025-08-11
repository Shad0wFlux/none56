import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AboutSectionWidget extends StatelessWidget {
  final String appVersion;
  final String buildNumber;

  const AboutSectionWidget({
    super.key,
    required this.appVersion,
    required this.buildNumber,
  });

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Privacy Policy'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TaskFlow Privacy Policy',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Last updated: August 11, 2025\n\n'
                'Your privacy is important to us. TaskFlow is designed with privacy in mind:\n\n'
                '• All data is stored locally on your device\n'
                '• No data is transmitted to external servers\n'
                '• No user accounts or personal information required\n'
                '• No analytics or tracking implemented\n'
                '• Notifications are handled locally by your device\n\n'
                'Data Collection:\n'
                '• We do not collect any personal information\n'
                '• Task data remains on your device only\n'
                '• App usage is not tracked or monitored\n\n'
                'Permissions:\n'
                '• Notification permission for task reminders\n'
                '• Storage permission for data backup/export\n\n'
                'Contact:\n'
                'For questions about this privacy policy, contact us at privacy@taskflow.app',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'TaskFlow',
      applicationVersion: appVersion,
      applicationIcon: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: CustomIconWidget(
          iconName: 'task_alt',
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  void _copyVersionInfo(BuildContext context) {
    final versionInfo = 'TaskFlow v$appVersion ($buildNumber)';
    Clipboard.setData(ClipboardData(text: versionInfo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Version info copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // App Logo and Info
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'task_alt',
                  color: Colors.white,
                  size: 12.w,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'TaskFlow',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: () => _copyVersionInfo(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme
                        .lightTheme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Version $appVersion ($buildNumber)',
                    style: AppTheme.getMonospaceStyle(
                      isLight: true,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Simple, offline task management\nfor productivity-focused individuals',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        // Links
        ListTile(
          leading: CustomIconWidget(
            iconName: 'privacy_tip',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          title: Text('Privacy Policy'),
          trailing: CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onTap: () => _showPrivacyPolicy(context),
        ),
        ListTile(
          leading: CustomIconWidget(
            iconName: 'article',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          title: Text('Open Source Licenses'),
          trailing: CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onTap: () => _showLicenses(context),
        ),
        ListTile(
          leading: CustomIconWidget(
            iconName: 'email',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          title: Text('Contact Support'),
          subtitle: Text('support@taskflow.app'),
          trailing: CustomIconWidget(
            iconName: 'open_in_new',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(text: 'support@taskflow.app'));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Email address copied to clipboard'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        // Footer
        Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Text(
                '© 2025 TaskFlow. All rights reserved.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Made with ❤️ for productivity enthusiasts',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
