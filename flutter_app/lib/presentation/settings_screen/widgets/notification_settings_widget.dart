import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsWidget extends StatefulWidget {
  final bool notificationsEnabled;
  final String defaultReminderTime;
  final String notificationSound;
  final Function(bool) onNotificationToggle;
  final Function(String) onReminderTimeChanged;
  final Function(String) onSoundChanged;
  final VoidCallback onTestNotification;

  const NotificationSettingsWidget({
    super.key,
    required this.notificationsEnabled,
    required this.defaultReminderTime,
    required this.notificationSound,
    required this.onNotificationToggle,
    required this.onReminderTimeChanged,
    required this.onSoundChanged,
    required this.onTestNotification,
  });

  @override
  State<NotificationSettingsWidget> createState() =>
      _NotificationSettingsWidgetState();
}

class _NotificationSettingsWidgetState
    extends State<NotificationSettingsWidget> {
  final List<Map<String, String>> reminderTimes = [
    {'value': '10', 'label': '10 minutes before'},
    {'value': '30', 'label': '30 minutes before'},
    {'value': '60', 'label': '1 hour before'},
    {'value': '120', 'label': '2 hours before'},
    {'value': '1440', 'label': '1 day before'},
  ];

  final List<Map<String, String>> notificationSounds = [
    {'value': 'default', 'label': 'Default'},
    {'value': 'gentle', 'label': 'Gentle Bell'},
    {'value': 'chime', 'label': 'Chime'},
    {'value': 'alert', 'label': 'Alert'},
    {'value': 'none', 'label': 'Silent'},
  ];

  void _showReminderTimeSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
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
            SizedBox(height: 3.h),
            Text(
              'Default Reminder Time',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ...reminderTimes.map((time) => ListTile(
                  title: Text(time['label']!),
                  trailing: widget.defaultReminderTime == time['value']
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    widget.onReminderTimeChanged(time['value']!);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSoundSelector() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
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
            SizedBox(height: 3.h),
            Text(
              'Notification Sound',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            ...notificationSounds.map((sound) => ListTile(
                  title: Text(sound['label']!),
                  trailing: widget.notificationSound == sound['value']
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    widget.onSoundChanged(sound['value']!);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getReminderTimeLabel() {
    final time = reminderTimes.firstWhere(
      (time) => time['value'] == widget.defaultReminderTime,
      orElse: () => reminderTimes.first,
    );
    return time['label']!;
  }

  String _getSoundLabel() {
    final sound = notificationSounds.firstWhere(
      (sound) => sound['value'] == widget.notificationSound,
      orElse: () => notificationSounds.first,
    );
    return sound['label']!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'notifications',
              color: widget.notificationsEnabled
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'Enable Notifications',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Switch(
              value: widget.notificationsEnabled,
              onChanged: widget.onNotificationToggle,
            ),
          ],
        ),
        if (widget.notificationsEnabled) ...[
          SizedBox(height: 2.h),
          InkWell(
            onTap: _showReminderTimeSelector,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'schedule',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Default Reminder',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _getReminderTimeLabel(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          InkWell(
            onTap: _showSoundSelector,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'volume_up',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notification Sound',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _getSoundLabel(),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ElevatedButton.icon(
            onPressed: widget.onTestNotification,
            icon: CustomIconWidget(
              iconName: 'notifications_active',
              color: Colors.white,
              size: 20,
            ),
            label: Text('Test Notification'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            ),
          ),
        ],
      ],
    );
  }
}
