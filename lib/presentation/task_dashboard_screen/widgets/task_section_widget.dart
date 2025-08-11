import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import './task_card_widget.dart';

class TaskSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> tasks;
  final Color? accentColor;
  final Function(Map<String, dynamic>) onToggleComplete;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onDelete;
  final Function(Map<String, dynamic>) onDuplicate;
  final Function(Map<String, dynamic>) onTap;

  const TaskSectionWidget({
    Key? key,
    required this.title,
    required this.tasks,
    this.accentColor,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox.shrink();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color titleColor = accentColor ??
        (isDark ? AppTheme.textPrimaryDark : AppTheme.textPrimaryLight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            children: [
              if (accentColor != null) ...[
                Container(
                  width: 1.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(width: 3.w),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: titleColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tasks.length}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: titleColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
        ...tasks
            .map((task) => TaskCardWidget(
                  task: task,
                  onToggleComplete: () => onToggleComplete(task),
                  onEdit: () => onEdit(task),
                  onDelete: () => onDelete(task),
                  onDuplicate: () => onDuplicate(task),
                  onTap: () => onTap(task),
                ))
            .toList(),
        SizedBox(height: 2.h),
      ],
    );
  }
}
