import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompletionHistoryCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const CompletionHistoryCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isRecurring = task['isRecurring'] as bool? ?? false;
    final List<dynamic> completionHistory =
        task['completionHistory'] as List<dynamic>? ?? [];

    if (!isRecurring || completionHistory.isEmpty)
      return const SizedBox.shrink();

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
                iconName: 'history',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Completion History',
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

          // Statistics Row
          _buildStatisticsRow(context, isDark, completionHistory),

          SizedBox(height: 2.h),

          // Streak Indicator
          _buildStreakIndicator(context, isDark, completionHistory),

          SizedBox(height: 2.h),

          // Recent Completions
          _buildRecentCompletions(context, isDark, completionHistory),
        ],
      ),
    );
  }

  Widget _buildStatisticsRow(
      BuildContext context, bool isDark, List<dynamic> history) {
    final totalCompletions = history.length;
    final currentStreak = _calculateCurrentStreak(history);
    final completionRate = _calculateCompletionRate(history);

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            isDark,
            'Total',
            totalCompletions.toString(),
            'check_circle',
            isDark ? AppTheme.successDark : AppTheme.successLight,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatItem(
            context,
            isDark,
            'Streak',
            currentStreak.toString(),
            'local_fire_department',
            isDark ? AppTheme.warningDark : AppTheme.warningLight,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatItem(
            context,
            isDark,
            'Rate',
            '${completionRate.toStringAsFixed(0)}%',
            'trending_up',
            isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    bool isDark,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 20,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
          ),
          Text(
            label,
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

  Widget _buildStreakIndicator(
      BuildContext context, bool isDark, List<dynamic> history) {
    final currentStreak = _calculateCurrentStreak(history);
    final longestStreak = _calculateLongestStreak(history);

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
                iconName: 'local_fire_department',
                color: isDark ? AppTheme.warningDark : AppTheme.warningLight,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Streak Information',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                'Current: $currentStreak',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? AppTheme.textPrimaryDark
                          : AppTheme.textPrimaryLight,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                'Best: $longestStreak',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCompletions(
      BuildContext context, bool isDark, List<dynamic> history) {
    final recentCompletions = history.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Completions',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppTheme.textSecondaryDark
                    : AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
        ),
        SizedBox(height: 1.h),
        ...recentCompletions.map((completion) {
          final completionMap = completion as Map<String, dynamic>;
          final DateTime completedDate =
              completionMap['completedDate'] as DateTime;
          final String status =
              completionMap['status'] as String? ?? 'completed';

          return Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.surfaceDark.withValues(alpha: 0.3)
                  : AppTheme.surfaceLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: status == 'completed' ? 'check_circle' : 'cancel',
                  color: status == 'completed'
                      ? (isDark ? AppTheme.successDark : AppTheme.successLight)
                      : (isDark ? AppTheme.errorDark : AppTheme.errorLight),
                  size: 16,
                ),
                SizedBox(width: 3.w),
                Text(
                  '${completedDate.day}/${completedDate.month}/${completedDate.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppTheme.textPrimaryDark
                            : AppTheme.textPrimaryLight,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const Spacer(),
                Text(
                  status.toUpperCase(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: status == 'completed'
                            ? (isDark
                                ? AppTheme.successDark
                                : AppTheme.successLight)
                            : (isDark
                                ? AppTheme.errorDark
                                : AppTheme.errorLight),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  int _calculateCurrentStreak(List<dynamic> history) {
    if (history.isEmpty) return 0;

    int streak = 0;
    final now = DateTime.now();

    for (var completion in history.reversed) {
      final completionMap = completion as Map<String, dynamic>;
      final DateTime completedDate = completionMap['completedDate'] as DateTime;
      final String status = completionMap['status'] as String? ?? 'completed';

      if (status == 'completed' && completedDate.isBefore(now)) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  int _calculateLongestStreak(List<dynamic> history) {
    if (history.isEmpty) return 0;

    int longestStreak = 0;
    int currentStreak = 0;

    for (var completion in history) {
      final completionMap = completion as Map<String, dynamic>;
      final String status = completionMap['status'] as String? ?? 'completed';

      if (status == 'completed') {
        currentStreak++;
        longestStreak =
            currentStreak > longestStreak ? currentStreak : longestStreak;
      } else {
        currentStreak = 0;
      }
    }

    return longestStreak;
  }

  double _calculateCompletionRate(List<dynamic> history) {
    if (history.isEmpty) return 0.0;

    final completedCount = history.where((completion) {
      final completionMap = completion as Map<String, dynamic>;
      final String status = completionMap['status'] as String? ?? 'completed';
      return status == 'completed';
    }).length;

    return (completedCount / history.length) * 100;
  }
}
