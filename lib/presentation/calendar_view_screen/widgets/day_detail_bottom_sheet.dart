import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DayDetailBottomSheet extends StatelessWidget {
  final DateTime selectedDate;
  final List<Map<String, dynamic>> dayTasks;
  final VoidCallback onAddTask;
  final Function(Map<String, dynamic>) onTaskTap;

  const DayDetailBottomSheet({
    Key? key,
    required this.selectedDate,
    required this.dayTasks,
    required this.onAddTask,
    required this.onTaskTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          _buildHeader(),
          // Tasks list
          Expanded(
            child: _buildTasksList(),
          ),
          // Add task button
          _buildAddTaskButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final formattedDate =
        '${_getMonthName(selectedDate.month)} ${selectedDate.day}, ${selectedDate.year}';
    final weekday = _getWeekdayName(selectedDate.weekday);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 0.5.h),
          Row(
            children: [
              Text(
                weekday,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(width: 4.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${dayTasks.length} ${dayTasks.length == 1 ? 'task' : 'tasks'}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    if (dayTasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'event_available',
              size: 12.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'No tasks scheduled',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Tap the + button to add your first task',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // Sort tasks by time
    final sortedTasks = List<Map<String, dynamic>>.from(dayTasks);
    sortedTasks.sort((a, b) {
      final timeA = DateTime.parse(a['date'] as String);
      final timeB = DateTime.parse(b['date'] as String);
      return timeA.compareTo(timeB);
    });

    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      itemCount: sortedTasks.length,
      separatorBuilder: (context, index) => SizedBox(height: 1.h),
      itemBuilder: (context, index) {
        final task = sortedTasks[index];
        return _buildTaskCard(task);
      },
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final taskTime = DateTime.parse(task['date'] as String);
    final timeString =
        '${taskTime.hour.toString().padLeft(2, '0')}:${taskTime.minute.toString().padLeft(2, '0')}';
    final isCompleted = task['isCompleted'] as bool? ?? false;

    return GestureDetector(
      onTap: () => onTaskTap(task),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Time
            Container(
              width: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeString,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                          task['category'] as String? ?? 'Personal'),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 4.w),
            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task['title'] as String? ?? '',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          : AppTheme.lightTheme.colorScheme.onSurface,
                      decoration:
                          isCompleted ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (task['description'] != null &&
                      (task['description'] as String).isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      task['description'] as String,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 1.h),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                              task['category'] as String? ?? 'Personal')
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      task['category'] as String? ?? 'Personal',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getCategoryColor(
                            task['category'] as String? ?? 'Personal'),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Status indicator
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppTheme.getSuccessColor(true)
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.lightTheme.colorScheme.outline,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: isCompleted
                  ? CustomIconWidget(
                      iconName: 'check',
                      size: 3.w,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton.icon(
          onPressed: onAddTask,
          icon: CustomIconWidget(
            iconName: 'add',
            size: 5.w,
            color: Colors.white,
          ),
          label: Text(
            'Add Task',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String _getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'work':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'study':
        return AppTheme.getSuccessColor(true);
      case 'family':
        return AppTheme.getWarningColor(true);
      case 'health':
        return AppTheme.getErrorColor(true);
      case 'personal':
      default:
        return AppTheme.lightTheme.colorScheme.secondary;
    }
  }
}
