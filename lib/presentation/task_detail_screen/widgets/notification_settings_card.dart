import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NotificationSettingsCard extends StatefulWidget {
  final Map<String, dynamic> task;
  final Function(bool) onNotificationToggle;
  final Function(String) onReminderTimeChanged;

  const NotificationSettingsCard({
    Key? key,
    required this.task,
    required this.onNotificationToggle,
    required this.onReminderTimeChanged,
  }) : super(key: key);

  @override
  State<NotificationSettingsCard> createState() =>
      _NotificationSettingsCardState();
}

class _NotificationSettingsCardState extends State<NotificationSettingsCard> {
  late bool _notificationsEnabled;
  late String _selectedReminderTime;

  final List<Map<String, String>> _reminderOptions = [
    {'value': '10', 'label': '10 minutes before'},
    {'value': '30', 'label': '30 minutes before'},
    {'value': '60', 'label': '1 hour before'},
    {'value': '1440', 'label': '1 day before'},
  ];

  @override
  void initState() {
    super.initState();
    _notificationsEnabled =
        widget.task['notificationsEnabled'] as bool? ?? true;
    _selectedReminderTime = widget.task['reminderTime'] as String? ?? '30';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : AppTheme.cardLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppTheme.shadowDark : AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'notifications',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                    ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Notification Toggle
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.surfaceDark.withValues(alpha: 0.5)
                  : AppTheme.surfaceLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: _notificationsEnabled
                      ? 'notifications_active'
                      : 'notifications_off',
                  color: _notificationsEnabled
                      ? (isDark ? AppTheme.successDark : AppTheme.successLight)
                      : (isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    'Enable Notifications',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? AppTheme.textPrimaryDark
                              : AppTheme.textPrimaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                    widget.onNotificationToggle(value);
                  },
                  activeColor:
                      isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                ),
              ],
            ),
          ),

          if (_notificationsEnabled) ...[
            SizedBox(height: 2.h),

            // Reminder Time Selection
            Text(
              'Reminder Time',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            SizedBox(height: 1.h),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.surfaceDark.withValues(alpha: 0.5)
                    : AppTheme.surfaceLight.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                  width: 1,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedReminderTime,
                  isExpanded: true,
                  icon: CustomIconWidget(
                    iconName: 'keyboard_arrow_down',
                    color: isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight,
                    size: 20,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight,
                      ),
                  dropdownColor:
                      isDark ? AppTheme.cardDark : AppTheme.cardLight,
                  items: _reminderOptions.map((option) {
                    return DropdownMenuItem<String>(
                      value: option['value'],
                      child: Text(option['label']!),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedReminderTime = value;
                      });
                      widget.onReminderTimeChanged(value);
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Notification Preview
            _buildNotificationPreview(context, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationPreview(BuildContext context, bool isDark) {
    final reminderLabel = _reminderOptions.firstWhere(
        (option) => option['value'] == _selectedReminderTime)['label'];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isDark ? AppTheme.primaryDark : AppTheme.primaryLight)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'preview',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Notification Preview',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            'TaskFlow Reminder',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${widget.task['title'] ?? 'Your task'} is due $reminderLabel',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }
}
