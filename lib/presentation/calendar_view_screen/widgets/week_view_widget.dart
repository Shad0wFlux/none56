import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class WeekViewWidget extends StatelessWidget {
  final DateTime currentWeek;
  final DateTime selectedDate;
  final List<Map<String, dynamic>> tasks;
  final Function(DateTime) onDateTap;
  final Function(DateTime) onDateLongPress;

  const WeekViewWidget({
    Key? key,
    required this.currentWeek,
    required this.selectedDate,
    required this.tasks,
    required this.onDateTap,
    required this.onDateLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekDates = _getWeekDates(currentWeek);
    final today = DateTime.now();

    return Container(
      height: 25.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Week header with dates
          Container(
            height: 8.h,
            child: Row(
              children: weekDates.map((date) {
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onDateTap(date),
                    onLongPress: () => onDateLongPress(date),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : isToday
                                ? AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekdayName(date.weekday),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            date.day.toString(),
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : isToday
                                      ? AppTheme.lightTheme.colorScheme.primary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 2.h),
          // Tasks timeline
          Expanded(
            child: SingleChildScrollView(
              child: _buildTasksTimeline(weekDates),
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _getWeekDates(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return weekdays[weekday % 7];
  }

  Widget _buildTasksTimeline(List<DateTime> weekDates) {
    final hours = List.generate(24, (index) => index);

    return Column(
      children: hours.map((hour) {
        return Container(
          height: 6.h,
          child: Row(
            children: [
              // Time label
              Container(
                width: 12.w,
                alignment: Alignment.topCenter,
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              // Tasks for each day
              Expanded(
                child: Row(
                  children: weekDates.map((date) {
                    final hourTasks = _getTasksForDateAndHour(date, hour);

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          children: hourTasks
                              .map((task) => Container(
                                    height: 2.h,
                                    margin:
                                        EdgeInsets.symmetric(vertical: 0.2.h),
                                    decoration: BoxDecoration(
                                      color: _getCategoryColor(
                                              task['category'] as String? ??
                                                  'Personal')
                                          .withValues(alpha: 0.8),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        task['title'] as String? ?? '',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 8.sp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Map<String, dynamic>> _getTasksForDateAndHour(DateTime date, int hour) {
    return (tasks as List)
        .where((dynamic task) {
          final taskMap = task as Map<String, dynamic>;
          final taskDateTime = DateTime.parse(taskMap['date'] as String);
          return taskDateTime.year == date.year &&
              taskDateTime.month == date.month &&
              taskDateTime.day == date.day &&
              taskDateTime.hour == hour;
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
