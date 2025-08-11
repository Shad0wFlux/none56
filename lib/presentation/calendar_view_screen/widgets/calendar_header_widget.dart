import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalendarHeaderWidget extends StatelessWidget {
  final DateTime currentDate;
  final Function(DateTime) onDateChanged;
  final VoidCallback onTodayTap;

  const CalendarHeaderWidget({
    Key? key,
    required this.currentDate,
    required this.onDateChanged,
    required this.onTodayTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        children: [
          // Previous month button
          GestureDetector(
            onTap: () => _navigateMonth(-1),
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_left',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Month/Year selector
          Expanded(
            child: GestureDetector(
              onTap: () => _showMonthYearPicker(context),
              child: Container(
                height: 10.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_getMonthName(currentDate.month)} ${currentDate.year}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'expand_more',
                      size: 5.w,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Next month button
          GestureDetector(
            onTap: () => _navigateMonth(1),
            child: Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'chevron_right',
                size: 6.w,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Today button
          GestureDetector(
            onTap: onTodayTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Today',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateMonth(int direction) {
    final newDate = DateTime(
      currentDate.year,
      currentDate.month + direction,
      1,
    );
    onDateChanged(newDate);
  }

  void _showMonthYearPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _MonthYearPickerDialog(
          initialDate: currentDate,
          onDateSelected: onDateChanged,
        );
      },
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
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const _MonthYearPickerDialog({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  _MonthYearPickerDialogState createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 80.w,
        height: 60.h,
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            // Header
            Text(
              'Select Month & Year',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 4.h),
            // Year selector
            Row(
              children: [
                Text(
                  'Year: ',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 20.h,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 8.h,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = DateTime.now().year - 10 + index;
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          final year = DateTime.now().year - 10 + index;
                          final isSelected = year == selectedYear;

                          return Container(
                            alignment: Alignment.center,
                            child: Text(
                              year.toString(),
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: isSelected
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          );
                        },
                        childCount: 21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            // Month selector
            Text(
              'Month',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 12,
                itemBuilder: (context, index) {
                  final month = index + 1;
                  final isSelected = month == selectedMonth;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMonth = month;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _getMonthName(month),
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 4.h),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final newDate = DateTime(selectedYear, selectedMonth, 1);
                      widget.onDateSelected(newDate);
                      Navigator.of(context).pop();
                    },
                    child: Text('Select'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
