import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CalendarGridWidget extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final List<Map<String, dynamic>> tasks;
  final Function(DateTime) onDateTap;
  final Function(DateTime) onDateLongPress;

  const CalendarGridWidget({
    Key? key,
    required this.currentMonth,
    required this.selectedDate,
    required this.tasks,
    required this.onDateTap,
    required this.onDateLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final firstWeekday = firstDayOfMonth.weekday;
    final today = DateTime.now();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Week days header
          _buildWeekDaysHeader(),
          SizedBox(height: 1.h),
          // Calendar grid
          _buildCalendarGrid(daysInMonth, firstWeekday, today),
        ],
      ),
    );
  }

  Widget _buildWeekDaysHeader() {
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: weekDays
          .map((day) => Expanded(
                child: Container(
                  height: 5.h,
                  alignment: Alignment.center,
                  child: Text(
                    day,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(int daysInMonth, int firstWeekday, DateTime today) {
    final totalCells = ((daysInMonth + firstWeekday - 1) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - firstWeekday + 2;

        if (dayNumber <= 0 || dayNumber > daysInMonth) {
          return Container(); // Empty cell
        }

        final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
        final isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final isSelected = date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;

        final dayTasks = _getTasksForDate(date);

        return GestureDetector(
          onTap: () => onDateTap(date),
          onLongPress: () => onDateLongPress(date),
          child: Container(
            margin: EdgeInsets.all(0.5.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : isToday
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 1.5,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dayNumber.toString(),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    color: isToday
                        ? AppTheme.lightTheme.colorScheme.primary
                        : isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                _buildTaskIndicators(dayTasks),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskIndicators(List<Map<String, dynamic>> dayTasks) {
    if (dayTasks.isEmpty) return Container(height: 1.h);

    final maxDots = 3;
    final visibleTasks = dayTasks.take(maxDots).toList();
    final hasMore = dayTasks.length > maxDots;

    return Container(
      height: 1.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...visibleTasks.map((task) => Container(
                width: 1.w,
                height: 1.w,
                margin: EdgeInsets.symmetric(horizontal: 0.2.w),
                decoration: BoxDecoration(
                  color: _getCategoryColor(
                      task['category'] as String? ?? 'Personal'),
                  shape: BoxShape.circle,
                ),
              )),
          hasMore
              ? Container(
                  margin: EdgeInsets.only(left: 0.5.w),
                  child: Text(
                    '+${dayTasks.length - maxDots}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getTasksForDate(DateTime date) {
    return (tasks as List)
        .where((dynamic task) {
          final taskMap = task as Map<String, dynamic>;
          final taskDate = DateTime.parse(taskMap['date'] as String);
          return taskDate.year == date.year &&
              taskDate.month == date.month &&
              taskDate.day == date.day;
        })
        .cast<Map<String, dynamic>>()
        .toList();
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
