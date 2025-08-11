import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskScheduleCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskScheduleCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final DateTime? scheduledDate = task['scheduledDate'] as DateTime?;
    final String? scheduledTime = task['scheduledTime'] as String?;

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
                iconName: 'schedule',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Schedule',
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

          // Date and Time Display
          Row(
            children: [
              Expanded(
                child: _buildScheduleItem(
                  context,
                  isDark,
                  'Date',
                  scheduledDate != null
                      ? '${scheduledDate.day}/${scheduledDate.month}/${scheduledDate.year}'
                      : 'Not scheduled',
                  'calendar_today',
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildScheduleItem(
                  context,
                  isDark,
                  'Time',
                  scheduledTime ?? 'Not set',
                  'access_time',
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Timeline Visualization
          _buildTimelineVisualization(context, isDark, scheduledDate),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    BuildContext context,
    bool isDark,
    String label,
    String value,
    String iconName,
  ) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineVisualization(
      BuildContext context, bool isDark, DateTime? scheduledDate) {
    if (scheduledDate == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final isOverdue = scheduledDate.isBefore(now);
    final isToday = scheduledDate.day == now.day &&
        scheduledDate.month == now.month &&
        scheduledDate.year == now.year;

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (isOverdue) {
      statusColor = isDark ? AppTheme.errorDark : AppTheme.errorLight;
      statusText = 'Overdue';
      statusIcon = Icons.warning;
    } else if (isToday) {
      statusColor = isDark ? AppTheme.warningDark : AppTheme.warningLight;
      statusText = 'Due Today';
      statusIcon = Icons.today;
    } else {
      statusColor = isDark ? AppTheme.successDark : AppTheme.successLight;
      statusText = 'Upcoming';
      statusIcon = Icons.upcoming;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            statusIcon,
            color: statusColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Text(
            statusText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          if (!isOverdue && !isToday)
            Text(
              '${scheduledDate.difference(now).inDays} days left',
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
