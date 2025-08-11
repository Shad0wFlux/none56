import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TaskInfoCard extends StatelessWidget {
  final Map<String, dynamic> task;
  final bool isEditing;
  final Function(String) onTitleChanged;
  final Function(String) onDescriptionChanged;

  const TaskInfoCard({
    Key? key,
    required this.task,
    required this.isEditing,
    required this.onTitleChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

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
          // Title Section
          isEditing
              ? _buildEditableTitle(context, isDark)
              : _buildStaticTitle(context, isDark),

          SizedBox(height: 3.h),

          // Description Section
          Text(
            'Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppTheme.textPrimaryDark
                      : AppTheme.textPrimaryLight,
                ),
          ),
          SizedBox(height: 1.h),

          isEditing
              ? _buildEditableDescription(context, isDark)
              : _buildStaticDescription(context, isDark),
        ],
      ),
    );
  }

  Widget _buildEditableTitle(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Title',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          initialValue: task['title'] as String? ?? '',
          onChanged: onTitleChanged,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppTheme.textPrimaryDark
                    : AppTheme.textPrimaryLight,
              ),
          decoration: InputDecoration(
            hintText: 'Enter task title',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaticTitle(BuildContext context, bool isDark) {
    return SelectableText(
      task['title'] as String? ?? 'Untitled Task',
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color:
                isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight,
          ),
    );
  }

  Widget _buildEditableDescription(BuildContext context, bool isDark) {
    return TextFormField(
      initialValue: task['description'] as String? ?? '',
      onChanged: onDescriptionChanged,
      maxLines: 4,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isDark
                ? AppTheme.textSecondaryDark
                : AppTheme.textSecondaryLight,
            height: 1.6,
          ),
      decoration: InputDecoration(
        hintText: 'Enter task description',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppTheme.borderDark : AppTheme.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppTheme.primaryDark : AppTheme.primaryLight,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildStaticDescription(BuildContext context, bool isDark) {
    final description =
        task['description'] as String? ?? 'No description available';

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
      child: SelectableText(
        description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? AppTheme.textSecondaryDark
                  : AppTheme.textSecondaryLight,
              height: 1.6,
            ),
      ),
    );
  }
}
