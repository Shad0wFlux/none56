import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskCategoryCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskCategoryCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String category = task['category'] as String? ?? 'Personal';
    final Color categoryColor = _getCategoryColor(category);

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
                iconName: 'category',
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Category',
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

          // Category Display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 3.w),
                Text(
                  category,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: categoryColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                CustomIconWidget(
                  iconName: _getCategoryIcon(category),
                  color: categoryColor,
                  size: 20,
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Category Description
          Text(
            _getCategoryDescription(category),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : AppTheme.textSecondaryLight,
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return const Color(0xFF2563EB); // Blue
      case 'study':
        return const Color(0xFF7C3AED); // Purple
      case 'family':
        return const Color(0xFFDC2626); // Red
      case 'health':
        return const Color(0xFF059669); // Green
      case 'personal':
      default:
        return const Color(0xFFD97706); // Orange
    }
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return 'work';
      case 'study':
        return 'school';
      case 'family':
        return 'family_restroom';
      case 'health':
        return 'favorite';
      case 'personal':
      default:
        return 'person';
    }
  }

  String _getCategoryDescription(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return 'Professional tasks and work-related activities';
      case 'study':
        return 'Educational activities and learning goals';
      case 'family':
        return 'Family time and household responsibilities';
      case 'health':
        return 'Health, fitness, and wellness activities';
      case 'personal':
      default:
        return 'Personal goals and self-improvement tasks';
    }
  }
}
