import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecurringTaskCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const RecurringTaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isRecurring = task['isRecurring'] as bool? ?? false;

    if (!isRecurring) return const SizedBox.shrink();

    final String recurringPattern =
        task['recurringPattern'] as String? ?? 'weekly';
    final DateTime? nextOccurrence = task['nextOccurrence'] as DateTime?;

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
                iconName: 'repeat',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Recurring Task',
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

          // Pattern Visualization
          _buildPatternVisualization(context, isDark, recurringPattern),

          SizedBox(height: 2.h),

          // Next Occurrence
          if (nextOccurrence != null)
            _buildNextOccurrence(context, isDark, nextOccurrence),

          SizedBox(height: 2.h),

          // Pattern Details
          _buildPatternDetails(context, isDark, recurringPattern),
        ],
      ),
    );
  }

  Widget _buildPatternVisualization(
      BuildContext context, bool isDark, String pattern) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: (isDark ? AppTheme.successDark : AppTheme.successLight)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (isDark ? AppTheme.successDark : AppTheme.successLight)
              .withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getPatternIcon(pattern),
            color: isDark ? AppTheme.successDark : AppTheme.successLight,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Text(
            _getPatternDisplayName(pattern),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: isDark ? AppTheme.successDark : AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.successDark : AppTheme.successLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'ACTIVE',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextOccurrence(
      BuildContext context, bool isDark, DateTime nextOccurrence) {
    final now = DateTime.now();
    final daysUntil = nextOccurrence.difference(now).inDays;

    return Container(
      width: double.infinity,
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
                iconName: 'event',
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Next Occurrence',
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
          Row(
            children: [
              Text(
                '${nextOccurrence.day}/${nextOccurrence.month}/${nextOccurrence.year}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                daysUntil == 0
                    ? 'Today'
                    : daysUntil == 1
                        ? 'Tomorrow'
                        : 'in $daysUntil days',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color:
                          isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPatternDetails(
      BuildContext context, bool isDark, String pattern) {
    return Container(
      width: double.infinity,
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
          Text(
            'Pattern Details',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: 1.h),
          Text(
            _getPatternDescription(pattern),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  height: 1.4,
                ),
          ),
        ],
      ),
    );
  }

  String _getPatternIcon(String pattern) {
    switch (pattern.toLowerCase()) {
      case 'daily':
        return 'today';
      case 'weekly':
        return 'date_range';
      case 'monthly':
        return 'calendar_month';
      default:
        return 'repeat';
    }
  }

  String _getPatternDisplayName(String pattern) {
    switch (pattern.toLowerCase()) {
      case 'daily':
        return 'Daily Repeat';
      case 'weekly':
        return 'Weekly Repeat';
      case 'monthly':
        return 'Monthly Repeat';
      default:
        return 'Custom Repeat';
    }
  }

  String _getPatternDescription(String pattern) {
    switch (pattern.toLowerCase()) {
      case 'daily':
        return 'This task repeats every day at the same time. A new instance will be created automatically after completion.';
      case 'weekly':
        return 'This task repeats every week on the same day. Perfect for weekly routines and regular commitments.';
      case 'monthly':
        return 'This task repeats every month on the same date. Ideal for monthly goals and periodic activities.';
      default:
        return 'This task follows a custom recurring pattern based on your specific requirements.';
    }
  }
}
