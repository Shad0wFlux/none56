import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TaskFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onTaskSaved;
  final VoidCallback? onSaveAndAddAnother;

  const TaskFormWidget({
    Key? key,
    required this.onTaskSaved,
    this.onSaveAndAddAnother,
  }) : super(key: key);

  @override
  State<TaskFormWidget> createState() => _TaskFormWidgetState();
}

class _TaskFormWidgetState extends State<TaskFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCategory = 'Personal';
  bool _isRecurring = false;
  String _recurringFrequency = 'Daily';
  bool _notificationsEnabled = true;
  int _notificationMinutes = 30;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Work', 'color': Color(0xFF2563EB), 'icon': 'work'},
    {'name': 'Study', 'color': Color(0xFF059669), 'icon': 'school'},
    {'name': 'Family', 'color': Color(0xFFD97706), 'icon': 'family_restroom'},
    {'name': 'Health', 'color': Color(0xFFDC2626), 'icon': 'health_and_safety'},
    {'name': 'Personal', 'color': Color(0xFF64748B), 'icon': 'person'},
  ];

  final List<String> _recurringOptions = ['Daily', 'Weekly', 'Monthly'];
  final List<Map<String, dynamic>> _notificationOptions = [
    {'label': '10 minutes', 'value': 10},
    {'label': '30 minutes', 'value': 30},
    {'label': '1 hour', 'value': 60},
  ];

  @override
  void initState() {
    super.initState();
    // Set smart defaults
    final now = DateTime.now();
    _selectedTime = TimeOfDay(hour: now.hour + 1, minute: 0);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveTask({bool saveAndAddAnother = false}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate database save
    await Future.delayed(Duration(milliseconds: 500));

    final taskData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'date': _selectedDate.toIso8601String(),
      'time': '${_selectedTime.hour}:${_selectedTime.minute}',
      'category': _selectedCategory,
      'isRecurring': _isRecurring,
      'recurringFrequency': _isRecurring ? _recurringFrequency : null,
      'notificationsEnabled': _notificationsEnabled,
      'notificationMinutes': _notificationMinutes,
      'isCompleted': false,
      'createdAt': DateTime.now().toIso8601String(),
    };

    widget.onTaskSaved(taskData);

    if (saveAndAddAnother) {
      // Clear form for next task
      _titleController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay(hour: DateTime.now().hour + 1, minute: 0);
        _isRecurring = false;
        _isLoading = false;
      });
      widget.onSaveAndAddAnother?.call();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Title
          Text(
            'Task Title',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter task title',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'task_alt',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Task title is required';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 3.h),

          // Task Description
          Text(
            'Description (Optional)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add task description...',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'description',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            textInputAction: TextInputAction.newline,
          ),
          SizedBox(height: 3.h),

          // Date and Time Selection
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                _selectedTime.format(context),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Category Selection
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            height: 6.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => SizedBox(width: 2.w),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'];

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'];
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? category['color']
                          : category['color'].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: category['color'],
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: category['icon'],
                          color: isSelected ? Colors.white : category['color'],
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          category['name'],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : category['color'],
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 3.h),

          // Recurring Task Toggle
          Row(
            children: [
              Switch(
                value: _isRecurring,
                onChanged: (value) {
                  setState(() {
                    _isRecurring = value;
                  });
                },
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Recurring Task',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),

          // Recurring Frequency (if enabled)
          _isRecurring
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Frequency',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: _recurringOptions.map((option) {
                        final isSelected = _recurringFrequency == option;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _recurringFrequency = option;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 2.w),
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1)
                                    : Colors.transparent,
                                border: Border.all(
                                  color: isSelected
                                      ? AppTheme.lightTheme.primaryColor
                                      : AppTheme.lightTheme.colorScheme.outline,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: isSelected
                                          ? AppTheme.lightTheme.primaryColor
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          SizedBox(height: 3.h),

          // Notification Settings
          Row(
            children: [
              Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Enable Notifications',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),

          // Notification Time (if enabled)
          _notificationsEnabled
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Notify me before',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      children: _notificationOptions.map((option) {
                        final isSelected =
                            _notificationMinutes == option['value'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _notificationMinutes = option['value']!;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.5.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.lightTheme.primaryColor
                                      .withValues(alpha: 0.1)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.outline,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              option['label'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected
                                        ? AppTheme.lightTheme.primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.color,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : SizedBox.shrink(),
          SizedBox(height: 4.h),

          // Action Buttons
          Column(
            children: [
              // Save Task Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _saveTask(),
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Save Task'),
                ),
              ),
              SizedBox(height: 2.h),

              // Save & Add Another Button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () => _saveTask(saveAndAddAnother: true),
                  child: Text('Save & Add Another'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}